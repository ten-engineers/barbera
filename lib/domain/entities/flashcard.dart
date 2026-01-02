import 'package:uuid/uuid.dart';

class Flashcard {
  final String id;
  final String word;
  final String translation;
  final String? example;
  final DateTime createdAt;
  final DateTime lastReviewed;
  final int reviewCount;
  final double easeFactor;
  final int intervalDays;
  final DateTime nextReviewDate;
  final bool isArchived;

  Flashcard({
    String? id,
    required this.word,
    required this.translation,
    this.example,
    DateTime? createdAt,
    DateTime? lastReviewed,
    this.reviewCount = 0,
    this.easeFactor = 2.5,
    this.intervalDays = 1,
    DateTime? nextReviewDate,
    this.isArchived = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        lastReviewed = lastReviewed ?? DateTime.now(),
        nextReviewDate = nextReviewDate ?? DateTime.now();

  Flashcard copyWith({
    String? word,
    String? translation,
    String? example,
    DateTime? lastReviewed,
    int? reviewCount,
    double? easeFactor,
    int? intervalDays,
    DateTime? nextReviewDate,
    bool? isArchived,
  }) {
    return Flashcard(
      id: id,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      example: example ?? this.example,
      createdAt: createdAt,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      reviewCount: reviewCount ?? this.reviewCount,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  bool get isDue => DateTime.now().isAfter(nextReviewDate) || 
                    DateTime.now().isAtSameMomentAs(nextReviewDate);
}

