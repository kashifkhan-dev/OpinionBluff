import 'package:flutter/foundation.dart';

class EnvConfig {
  /// Toggle this to switch between Testing Mode and Production Mode.
  /// Testing Mode: Forced review prompt after onboarding.
  /// Production Mode: Standard gated review prompt.
  static const bool isTestingMode = true;

  /// Debug check to see if we should force behaviors.
  static bool get shouldForceReview => isTestingMode || kDebugMode;
}
