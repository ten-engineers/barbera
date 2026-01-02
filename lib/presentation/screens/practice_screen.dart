import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/flashcard.dart';
import '../providers/flashcard_provider.dart';
import '../widgets/flashcard_widget.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashcardsAsync = ref.watch(flashcardNotifierProvider);
    final notifier = ref.read(flashcardNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice'),
        elevation: 0,
      ),
      body: flashcardsAsync.when(
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
                      'All caught up!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No flashcards due for review.\nAdd some words to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${flashcards.length} cards due',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      children: [
                        _ActionButton(
                          icon: Icons.archive,
                          label: 'Archive',
                          color: Colors.orange,
                          onPressed: () {
                            if (flashcards.isNotEmpty) {
                              notifier.archiveFlashcard(flashcards[0]);
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        _ActionButton(
                          icon: Icons.check_circle,
                          label: 'Known',
                          color: Colors.green,
                          onPressed: () {
                            if (flashcards.isNotEmpty) {
                              notifier.markAsKnown(flashcards[0]);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: flashcards.isEmpty
                      ? const SizedBox.shrink()
                      : _SingleFlashcardView(
                          flashcard: flashcards[0],
                          onSwipeRight: () {
                            notifier.markAsKnown(flashcards[0]);
                          },
                          onSwipeLeft: () {
                            notifier.archiveFlashcard(flashcards[0]);
                          },
                        ),
                ),
              ),
            ],
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

class _SingleFlashcardView extends StatefulWidget {
  final Flashcard flashcard;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;

  const _SingleFlashcardView({
    required this.flashcard,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  });

  @override
  State<_SingleFlashcardView> createState() => _SingleFlashcardViewState();
}

class _SingleFlashcardViewState extends State<_SingleFlashcardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isSwipingOut = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_SingleFlashcardView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.flashcard.id != widget.flashcard.id) {
      _isSwipingOut = false;
      _controller.reset();
    }
  }

  void _handleSwipeRight() {
    if (!_isSwipingOut) {
      setState(() {
        _isSwipingOut = true;
      });
      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(1.5, 0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ));
      _controller.forward().then((_) {
        widget.onSwipeRight();
      });
    }
  }

  void _handleSwipeLeft() {
    if (!_isSwipingOut) {
      setState(() {
        _isSwipingOut = true;
      });
      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1.5, 0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ));
      _controller.forward().then((_) {
        widget.onSwipeLeft();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: FlashcardWidget(
          flashcard: widget.flashcard,
          onSwipeRight: _handleSwipeRight,
          onSwipeLeft: _handleSwipeLeft,
        ),
      ),
    );
  }
}
