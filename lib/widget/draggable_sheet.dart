import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DraggableScrollableSheetExample extends StatefulWidget {
  const DraggableScrollableSheetExample({super.key});

  @override
  State<DraggableScrollableSheetExample> createState() =>
      _DraggableScrollableSheetExampleState();
}

class _DraggableScrollableSheetExampleState
    extends State<DraggableScrollableSheetExample>
    with SingleTickerProviderStateMixin {
  double _sheetPosition = 0.1;
  final double _dragSensitivity = 600;

  // Define the minimum and maximum values
  final double _minSheetPosition = 0.1;
  final double _maxSheetPosition = 1.0;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {
          _sheetPosition = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _snapSheetPosition() {
    final targetPosition = _sheetPosition < 0.3
        ? _minSheetPosition
        : (_sheetPosition < 0.7 ? _maxSheetPosition : _minSheetPosition);

    _animation = Tween<double>(
      begin: _sheetPosition,
      end: targetPosition,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: _sheetPosition,
      minChildSize: 0.1,
      maxChildSize: _maxSheetPosition,
      builder: (BuildContext context, ScrollController scrollController) {
        return ColoredBox(
          color: colorScheme.primary,
          child: Column(
            children: <Widget>[
              Grabber(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    _sheetPosition -= details.delta.dy / _dragSensitivity;
                    // print(_sheetPosition);
                    if (_sheetPosition < _minSheetPosition) {
                      _sheetPosition = _minSheetPosition;
                    }
                    if (_sheetPosition > _maxSheetPosition) {
                      _sheetPosition = _maxSheetPosition;
                    }
                  });
                },
                onVerticalDragEnd: (DragEndDetails details) {
                  _snapSheetPosition();
                },
                isOnDesktopAndWeb: true, // Make the grabber always visible
              ),
              Flexible(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 25,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        'Item $index',
                        style: TextStyle(color: colorScheme.surface),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A draggable widget that accepts vertical drag gestures
/// and this is visible on all platforms.
class Grabber extends StatelessWidget {
  const Grabber({
    super.key,
    required this.onVerticalDragUpdate,
    required this.isOnDesktopAndWeb,
    this.onVerticalDragEnd,
  });

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;
  final GestureDragEndCallback? onVerticalDragEnd;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            width: 32.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
