abstract class IReviewRepository {
  /// Attempts to trigger the native in-app review dialog.
  Future<void> requestReview();

  /// Resets any persistence flags related to reviews (for debugging).
  Future<void> clearReviewFlag();
}
