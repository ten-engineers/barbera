import '../entities/flashcard.dart';

class SpacedRepetitionService {
  static const double initialEaseFactor = 2.5;
  static const double easeFactorChange = 0.15;
  static const int minIntervalDays = 1;

  Flashcard updateAfterReview(Flashcard flashcard, bool isCorrect) {
    final now = DateTime.now();
    
    if (isCorrect) {
      final newEaseFactor = (flashcard.easeFactor + easeFactorChange)
          .clamp(1.3, double.infinity);
      
      int newIntervalDays;
      if (flashcard.reviewCount == 0) {
        newIntervalDays = 1;
      } else if (flashcard.reviewCount == 1) {
        newIntervalDays = 6;
      } else {
        newIntervalDays = (flashcard.intervalDays * newEaseFactor).round();
      }

      final nextReview = now.add(Duration(days: newIntervalDays));

      return flashcard.copyWith(
        lastReviewed: now,
        reviewCount: flashcard.reviewCount + 1,
        easeFactor: newEaseFactor,
        intervalDays: newIntervalDays,
        nextReviewDate: nextReview,
      );
    } else {
      final newEaseFactor = (flashcard.easeFactor - easeFactorChange)
          .clamp(1.3, double.infinity);
      
      return flashcard.copyWith(
        lastReviewed: now,
        reviewCount: flashcard.reviewCount + 1,
        easeFactor: newEaseFactor,
        intervalDays: minIntervalDays,
        nextReviewDate: now.add(const Duration(days: minIntervalDays)),
      );
    }
  }
}

