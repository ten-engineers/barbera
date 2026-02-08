import '../entities/flashcard.dart';

abstract class FlashcardRepository {
  Future<List<Flashcard>> getAllFlashcards();
  Future<List<Flashcard>> getAllFlashcardsIncludingArchived();
  Future<List<Flashcard>> getDueFlashcards();
  Future<List<Flashcard>> getArchivedFlashcards();
  Future<List<Flashcard>> getKnownFlashcards();
  Future<Flashcard?> getFlashcardById(String id);
  Future<void> saveFlashcard(Flashcard flashcard);
  Future<void> deleteFlashcard(String id);
  Future<void> archiveFlashcard(String id);
  Future<void> unarchiveFlashcard(String id);
  Future<void> updateFlashcard(Flashcard flashcard);
}

