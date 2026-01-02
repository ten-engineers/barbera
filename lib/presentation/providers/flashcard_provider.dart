import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../../domain/services/spaced_repetition_service.dart';
import '../../data/repositories/flashcard_repository_impl.dart';
import '../../data/repositories/stats_repository_impl.dart';
import '../../domain/repositories/stats_repository.dart';

final flashcardRepositoryProvider = Provider<FlashcardRepository>((ref) {
  return FlashcardRepositoryImpl();
});

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepositoryImpl();
});

final spacedRepetitionServiceProvider = Provider<SpacedRepetitionService>((ref) {
  return SpacedRepetitionService();
});

final dueFlashcardsProvider = FutureProvider<List<Flashcard>>((ref) async {
  final repository = ref.watch(flashcardRepositoryProvider);
  return await repository.getDueFlashcards();
});

final allFlashcardsProvider = FutureProvider<List<Flashcard>>((ref) async {
  final repository = ref.watch(flashcardRepositoryProvider);
  return await repository.getAllFlashcards();
});

final archivedFlashcardsProvider = FutureProvider<List<Flashcard>>((ref) async {
  final repository = ref.watch(flashcardRepositoryProvider);
  return await repository.getArchivedFlashcards();
});

final knownFlashcardsProvider = FutureProvider<List<Flashcard>>((ref) async {
  final repository = ref.watch(flashcardRepositoryProvider);
  return await repository.getKnownFlashcards();
});

final flashcardNotifierProvider = StateNotifierProvider<FlashcardNotifier, AsyncValue<List<Flashcard>>>((ref) {
  return FlashcardNotifier(ref);
});

class FlashcardNotifier extends StateNotifier<AsyncValue<List<Flashcard>>> {
  final Ref _ref;
  
  FlashcardNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    state = const AsyncValue.loading();
    try {
      final repository = _ref.read(flashcardRepositoryProvider);
      final flashcards = await repository.getDueFlashcards();
      state = AsyncValue.data(flashcards);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> markAsKnown(Flashcard flashcard) async {
    final service = _ref.read(spacedRepetitionServiceProvider);
    final repository = _ref.read(flashcardRepositoryProvider);
    final statsRepo = _ref.read(statsRepositoryProvider);
    
    final updated = service.updateAfterReview(flashcard, true);
    await repository.updateFlashcard(updated);
    await statsRepo.incrementDailyReview();
    await statsRepo.updateStreak();
    
    _loadFlashcards();
  }

  Future<void> archiveFlashcard(Flashcard flashcard) async {
    final repository = _ref.read(flashcardRepositoryProvider);
    await repository.archiveFlashcard(flashcard.id);
    _ref.invalidate(archivedFlashcardsProvider);
    _loadFlashcards();
  }

  Future<void> unarchiveFlashcard(Flashcard flashcard) async {
    final repository = _ref.read(flashcardRepositoryProvider);
    await repository.unarchiveFlashcard(flashcard.id);
    _ref.invalidate(archivedFlashcardsProvider);
    _loadFlashcards();
  }

  Future<void> markAsRepeat(Flashcard flashcard) async {
    final service = _ref.read(spacedRepetitionServiceProvider);
    final repository = _ref.read(flashcardRepositoryProvider);
    final statsRepo = _ref.read(statsRepositoryProvider);
    
    final updated = service.updateAfterReview(flashcard, false);
    await repository.updateFlashcard(updated);
    await statsRepo.incrementDailyReview();
    await statsRepo.updateStreak();
    
    _loadFlashcards();
  }

  Future<void> addFlashcard(Flashcard flashcard) async {
    final repository = _ref.read(flashcardRepositoryProvider);
    await repository.saveFlashcard(flashcard);
    _ref.invalidate(allFlashcardsProvider);
    _loadFlashcards();
  }
}

