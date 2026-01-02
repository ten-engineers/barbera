import 'package:flutter/material.dart';
import '../../domain/entities/flashcard.dart';
import 'flashcard_widget.dart';

class SwipeableFlashcardStack extends StatefulWidget {
  final List<Flashcard> flashcards;
  final Function(Flashcard) onSwipeRight;
  final Function(Flashcard) onSwipeLeft;
  final Function(Flashcard)? onTap;

  const SwipeableFlashcardStack({
    super.key,
    required this.flashcards,
    required this.onSwipeRight,
    required this.onSwipeLeft,
    this.onTap,
  });

  @override
  State<SwipeableFlashcardStack> createState() =>
      _SwipeableFlashcardStackState();
}

class _SwipeableFlashcardStackState extends State<SwipeableFlashcardStack> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SwipeableFlashcardStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flashcards.length != oldWidget.flashcards.length) {
      if (_currentIndex >= widget.flashcards.length && widget.flashcards.isNotEmpty) {
        _currentIndex = 0;
        _pageController.jumpToPage(0);
      }
    }
  }

  void _handleSwipeRight() {
    if (_currentIndex < widget.flashcards.length) {
      final flashcard = widget.flashcards[_currentIndex];
      widget.onSwipeRight(flashcard);
      _moveToNext();
    }
  }

  void _handleSwipeLeft() {
    if (_currentIndex < widget.flashcards.length) {
      final flashcard = widget.flashcards[_currentIndex];
      widget.onSwipeLeft(flashcard);
      _moveToNext();
    }
  }

  void _moveToNext() {
    if (_currentIndex < widget.flashcards.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flashcards.isEmpty) {
      return const Center(
        child: Text(
          'No flashcards due for review!\nAdd some words to get started.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: widget.flashcards.length,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemBuilder: (context, index) {
        if (index >= widget.flashcards.length) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: FlashcardWidget(
            flashcard: widget.flashcards[index],
            onSwipeRight: _handleSwipeRight,
            onSwipeLeft: _handleSwipeLeft,
            onTap: () => widget.onTap?.call(widget.flashcards[index]),
          ),
        );
      },
    );
  }
}

