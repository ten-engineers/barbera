import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/flashcard.dart';
import '../providers/flashcard_provider.dart';

class KnownCardsScreen extends ConsumerWidget {
  const KnownCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final knownAsync = ref.watch(knownFlashcardsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Known Cards'),
        elevation: 0,
      ),
      body: knownAsync.when(
        data: (flashcards) {
          if (flashcards.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                    SizedBox(height: 16),
                    Text(
                      'No known cards yet',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Cards you mark as "Known" will appear here',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(knownFlashcardsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = flashcards[index];
                return _FlashcardListItem(flashcard: flashcard);
              },
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
            ],
          ),
        ),
      ),
    );
  }
}

class _FlashcardListItem extends StatelessWidget {
  final Flashcard flashcard;

  const _FlashcardListItem({required this.flashcard});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          flashcard.word,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              flashcard.translation,
              style: const TextStyle(fontSize: 16),
            ),
            if (flashcard.example != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  flashcard.example!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[900],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                _StatChip(
                  icon: Icons.repeat,
                  label: '${flashcard.reviewCount} reviews',
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  icon: Icons.trending_up,
                  label: 'Ease: ${flashcard.easeFactor.toStringAsFixed(1)}',
                  color: Colors.green,
                ),
                if (flashcard.nextReviewDate.isAfter(DateTime.now())) ...[
                  const SizedBox(width: 8),
                  _StatChip(
                    icon: Icons.schedule,
                    label: 'Next: ${_formatNextReview(flashcard.nextReviewDate)}',
                    color: Colors.orange,
                  ),
                ],
              ],
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  String _formatNextReview(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'tomorrow';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks';
    } else {
      return '${(difference.inDays / 30).floor()} months';
    }
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color),
          ),
        ],
      ),
    );
  }
}

