import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opinion_bluff/core/config/env_config.dart';
import 'package:opinion_bluff/domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements IReviewRepository {
  static const String _reviewRequestedKey = 'has_requested_review';
  final InAppReview _inAppReview = InAppReview.instance;

  @override
  Future<void> requestReview() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. Check Testing Mode bypass
      if (!EnvConfig.isTestingMode) {
        final hasRequested = prefs.getBool(_reviewRequestedKey) ?? false;
        if (hasRequested) {
          debugPrint('ℹ️ [ReviewRepository] Previously requested. Skipping (Production).');
          return;
        }
      } else {
        debugPrint('🧪 [ReviewRepository] Testing Mode: Bypassing persistent gate.');
      }

      // 2. Check availability with a timeout
      debugPrint('🔍 [ReviewRepository] Checking if review API is available...');
      final isAvailable = await _inAppReview.isAvailable().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          debugPrint('⏰ [ReviewRepository] isAvailable timed out. Defaulting to false.');
          return false;
        },
      );

      if (isAvailable) {
        debugPrint('🚀 [ReviewRepository] Starting native app review prompt request...');

        // 3. Persist flag only in Production
        if (!EnvConfig.isTestingMode) {
          await prefs.setBool(_reviewRequestedKey, true);
          debugPrint('💾 [ReviewRepository] Review flag persisted.');
        }

        // 4. Request Review with a safety timeout to prevent "freezing" on some platforms/Simulators
        debugPrint('📣 [ReviewRepository] Calling _inAppReview.requestReview()...');
        await _inAppReview
            .requestReview()
            .timeout(
              const Duration(seconds: 3),
              onTimeout: () {
                debugPrint('⏰ [ReviewRepository] requestReview timed out after 3s. Continuing anyway.');
              },
            )
            .catchError((error) {
              debugPrint('❌ [ReviewRepository] Error calling requestReview: $error');
            });

        debugPrint('✅ [ReviewRepository] native review request sequence finished.');
      } else {
        debugPrint('⚠️ [ReviewRepository] Native review API reported NOT available.');
      }
    } catch (e) {
      debugPrint('❌ [ReviewRepository] Silent failure: $e');
    }
  }

  @override
  Future<void> clearReviewFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_reviewRequestedKey);
    debugPrint('🧹 [ReviewRepository] Review flag reset.');
  }
}
