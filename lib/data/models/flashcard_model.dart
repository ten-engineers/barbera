import 'package:hive/hive.dart';
import '../../domain/entities/flashcard.dart';

part 'flashcard_model.g.dart';

@HiveType(typeId: 0)
class FlashcardModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String word;

  @HiveField(2)
  final String translation;

  @HiveField(3)
  final String? example;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime lastReviewed;

  @HiveField(6)
  final int reviewCount;

  @HiveField(7)
  final double easeFactor;

  @HiveField(8)
  final int intervalDays;

  @HiveField(9)
  final DateTime nextReviewDate;

  @HiveField(10)
  final bool isArchived;

  FlashcardModel({
    required this.id,
    required this.word,
    required this.translation,
    this.example,
    required this.createdAt,
    required this.lastReviewed,
    required this.reviewCount,
    required this.easeFactor,
    required this.intervalDays,
    required this.nextReviewDate,
    this.isArchived = false,
  });

  factory FlashcardModel.fromEntity(Flashcard flashcard) {
    return FlashcardModel(
      id: flashcard.id,
      word: flashcard.word,
      translation: flashcard.translation,
      example: flashcard.example,
      createdAt: flashcard.createdAt,
      lastReviewed: flashcard.lastReviewed,
      reviewCount: flashcard.reviewCount,
      easeFactor: flashcard.easeFactor,
      intervalDays: flashcard.intervalDays,
      nextReviewDate: flashcard.nextReviewDate,
      isArchived: flashcard.isArchived,
    );
  }

  Flashcard toEntity() {
    return Flashcard(
      id: id,
      word: word,
      translation: translation,
      example: example,
      createdAt: createdAt,
      lastReviewed: lastReviewed,
      reviewCount: reviewCount,
      easeFactor: easeFactor,
      intervalDays: intervalDays,
      nextReviewDate: nextReviewDate,
      isArchived: isArchived,
    );
  }
}

