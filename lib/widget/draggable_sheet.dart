import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DraggableScrollableSheetExample extends StatefulWidget {
  const DraggableScrollableSheetExample({super.key, required this.songs});
  final List<Map<String, dynamic>> songs;
  @override
  State<DraggableScrollableSheetExample> createState() =>
      _DraggableScrollableSheetExampleState();
}

class _DraggableScrollableSheetExampleState
    extends State<DraggableScrollableSheetExample>
    with SingleTickerProviderStateMixin {
  double _sheetPosition = 0;
  final double _dragSensitivity = 600;

  // Define the minimum and maximum values
  final double _minSheetPosition = 0.16;
  final double _maxSheetPosition = 1.0;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _sheetPosition = _minSheetPosition;
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
    double targetPosition;

    // Check the _sheetPosition value and determine the target position
    if (_sheetPosition > 0.2) {
      if (_sheetPosition <= 0.8) {
        targetPosition = _minSheetPosition;
      } else {
        targetPosition = _maxSheetPosition;
      }
    } else {
      targetPosition =
          _minSheetPosition; // Fallback to _minSheetPosition if conditions are not met
      print('Condition met: _sheetPosition <= 0.8');
    }

    print('Sheet Position: $_sheetPosition, Snap to: $targetPosition');
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
      minChildSize: _minSheetPosition,
      maxChildSize: _maxSheetPosition,
      builder: (BuildContext context, ScrollController scrollController) {
        return ColoredBox(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Grabber(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    _sheetPosition -= details.delta.dy / _dragSensitivity;
                    if (_sheetPosition < _minSheetPosition) {
                      _sheetPosition = _minSheetPosition;
                    }
                    if (_sheetPosition > _maxSheetPosition) {
                      _sheetPosition = _maxSheetPosition;
                    }
                    print(_sheetPosition);
                  });
                },

                onVerticalDragEnd: (DragEndDetails details) {
                  _snapSheetPosition();
                },
                isOnDesktopAndWeb: true, // Make the grabber always visible
              ),
              Row(
                children: [
                  SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(
                        widget.songs[1]['image']!,
                        fit: BoxFit.fill,
                      )),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ListTile(
                      title: Text(widget.songs[1]['song']!),
                      subtitle: Text(widget.songs[1]['artist']!),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            widget.songs[1]['status'] =
                                !widget.songs[1]['status'];
                          });
                          print("status: ${widget.songs[1]['status']}");
                        },
                        icon: Icon(widget.songs[1]['status']
                            ? Icons.play_arrow
                            : Icons.pause),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.songs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image.network(
                                    widget.songs[index]['image']!,
                                    fit: BoxFit.fill,
                                  )),
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: ListTile(
                                  title: Text(widget.songs[index]['song']!),
                                  subtitle:
                                      Text(widget.songs[index]['artist']!),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.songs[index]['status'] =
                                            !widget.songs[index]['status'];
                                      });
                                      print(
                                          "status: ${widget.songs[index]['status']}");
                                    },
                                    icon: Icon(widget.songs[index]['status']
                                        ? Icons.play_arrow
                                        : Icons.pause),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
