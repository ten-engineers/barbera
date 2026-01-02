import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/repositories/stats_repository.dart';
import '../../data/repositories/stats_repository_impl.dart';
import '../../data/repositories/flashcard_repository_impl.dart';
import '../../domain/repositories/flashcard_repository.dart';
import 'flashcard_provider.dart';

final userStatsProvider = FutureProvider<UserStats>((ref) async {
  final repository = ref.watch(statsRepositoryProvider);
  
  ref.watch(allFlashcardsProvider);
  
  final stats = await repository.getStats();
  final allFlashcards = await ref.read(flashcardRepositoryProvider).getAllFlashcards();
  
  return stats.copyWith(totalWords: allFlashcards.length);
});

