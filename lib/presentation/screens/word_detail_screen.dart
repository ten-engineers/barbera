import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/flashcard.dart';
import '../providers/flashcard_provider.dart';
import '../widgets/flashcard_widget.dart';

class WordDetailScreen extends ConsumerWidget {
  final String flashcardId;

  const WordDetailScreen({
    super.key,
    required this.flashcardId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allFlashcardsAsync = ref.watch(allFlashcardsIncludingArchivedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Details'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: allFlashcardsAsync.when(
        data: (flashcards) {
          Flashcard? flashcard;
          try {
            flashcard = flashcards.firstWhere((card) => card.id == flashcardId);
          } catch (e) {
            flashcard = null;
          }
          
          if (flashcard == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Word not found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FlashcardWidget(
                flashcard: flashcard,
                onSwipeRight: () {}, // Disable swipe actions in detail view
                onSwipeLeft: () {}, // Disable swipe actions in detail view
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
