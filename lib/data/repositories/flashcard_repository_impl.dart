import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../models/flashcard_model.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  static const String _boxName = 'flashcards';

  Future<Box<FlashcardModel>> get _box async =>
      await Hive.openBox<FlashcardModel>(_boxName);

  @override
  Future<List<Flashcard>> getAllFlashcards() async {
    final box = await _box;
    return box.values
        .where((model) => !model.isArchived)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<Flashcard>> getAllFlashcardsIncludingArchived() async {
    final box = await _box;
    return box.values
        .map((model) => model.toEntity())
        .toList()
      ..sort((a, b) => b.lastReviewed.compareTo(a.lastReviewed));
  }

  @override
  Future<List<Flashcard>> getDueFlashcards() async {
    final box = await _box;
    final now = DateTime.now();
    return box.values
        .where((model) => 
            !model.isArchived && 
            (model.nextReviewDate.isBefore(now) || 
             model.nextReviewDate.isAtSameMomentAs(now)))
        .map((model) => model.toEntity())
        .toList()
      ..shuffle();
  }

  @override
  Future<List<Flashcard>> getArchivedFlashcards() async {
    final box = await _box;
    return box.values
        .where((model) => model.isArchived)
        .map((model) => model.toEntity())
        .toList()
      ..sort((a, b) => b.lastReviewed.compareTo(a.lastReviewed));
  }

  @override
  Future<List<Flashcard>> getKnownFlashcards() async {
    final box = await _box;
    return box.values
        .where((model) => 
            !model.isArchived && 
            model.reviewCount > 0 &&
            model.easeFactor >= 2.5)
        .map((model) => model.toEntity())
        .toList()
      ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
  }

  @override
  Future<Flashcard?> getFlashcardById(String id) async {
    final box = await _box;
    final model = box.get(id);
    return model?.toEntity();
  }

  @override
  Future<void> saveFlashcard(Flashcard flashcard) async {
    final box = await _box;
    await box.put(
      flashcard.id,
      FlashcardModel.fromEntity(flashcard),
    );
  }

  @override
  Future<void> deleteFlashcard(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  @override
  Future<void> archiveFlashcard(String id) async {
    final flashcard = await getFlashcardById(id);
    if (flashcard != null) {
      await saveFlashcard(flashcard.copyWith(isArchived: true));
    }
  }

  @override
  Future<void> unarchiveFlashcard(String id) async {
    final flashcard = await getFlashcardById(id);
    if (flashcard != null) {
      await saveFlashcard(flashcard.copyWith(isArchived: false));
    }
  }

  @override
  Future<void> updateFlashcard(Flashcard flashcard) async {
    await saveFlashcard(flashcard);
  }
}

