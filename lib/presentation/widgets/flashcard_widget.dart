import 'package:flutter/material.dart';
import '../../domain/entities/flashcard.dart';

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;
  final VoidCallback? onTap;

  const FlashcardWidget({
    super.key,
    required this.flashcard,
    required this.onSwipeRight,
    required this.onSwipeLeft,
    this.onTap,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  bool _isFlipped = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  
  Offset _position = Offset.zero;
  double _angle = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_isFlipped && !_isDragging) {
      setState(() {
        _isFlipped = true;
      });
      _flipController.forward();
      widget.onTap?.call();
    }
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position += details.delta;
      _angle = _position.dx * 0.01;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    const swipeThreshold = 100.0;
    const velocityThreshold = 500.0;
    
    final velocity = details.velocity.pixelsPerSecond.dx;
    final shouldSwipeRight = _position.dx > swipeThreshold || velocity > velocityThreshold;
    final shouldSwipeLeft = _position.dx < -swipeThreshold || velocity < -velocityThreshold;

    if (shouldSwipeRight) {
      widget.onSwipeRight();
    } else if (shouldSwipeLeft) {
      widget.onSwipeLeft();
    } else {
      _resetPosition();
    }
  }

  void _resetPosition() {
    setState(() {
      _position = Offset.zero;
      _angle = 0.0;
      _isDragging = false;
    });
  }

  @override
  void didUpdateWidget(FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.flashcard.id != widget.flashcard.id) {
      _resetPosition();
      _isFlipped = false;
      _flipController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform.translate(
        offset: _position,
        child: Transform.rotate(
          angle: _angle,
          child: _buildCardContent(),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * 3.14159;
        final isFront = angle < 1.5708;
        
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(isFront ? angle : angle - 3.14159),
          child: Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: isFront ? Colors.white : Colors.blue[50],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isFront ? _buildFront() : _buildBack(),
          ),
        );
      },
    );
  }

  Widget _buildFront() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.flashcard.word,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Tap to reveal',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.flashcard.translation,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.flashcard.example != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.flashcard.example!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[900],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

