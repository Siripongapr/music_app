import 'package:flutter/material.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:music_app/progress_bar_state.dart';

class DraggableScrollableSheetExample extends StatefulWidget {
  const DraggableScrollableSheetExample(
      {Key? key,
      required this.songs,
      required this.onReorder,
      required this.pageManager})
      : super(key: key);

  final List<Map<String, dynamic>> songs;
  final void Function(int oldIndex, int newIndex) onReorder;
  final PageManager pageManager;

  @override
  _DraggableScrollableSheetExampleState createState() =>
      _DraggableScrollableSheetExampleState();
}

class _DraggableScrollableSheetExampleState
    extends State<DraggableScrollableSheetExample>
    with SingleTickerProviderStateMixin {
  double _sheetPosition = 0.17; // Initial position
  final double _dragSensitivity = 600;
  final double _minSheetPosition = 0.17;
  final double _maxSheetPosition = 1.0;

  late AnimationController _animationController;
  late Animation<double> _animation;

  late final PageManager _pageManager;
  late List<Map<String, dynamic>> _songs;

  @override
  void initState() {
    super.initState();
    _songs = List.from(widget.songs); // Copy the initial songs list
    _pageManager = widget.pageManager;
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
    _pageManager.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _snapSheetPosition() {
    double targetPosition;

    if (_sheetPosition > 0.2) {
      if (_sheetPosition <= 0.8) {
        targetPosition = _minSheetPosition;
      } else {
        targetPosition = _maxSheetPosition;
      }
    } else {
      targetPosition = _minSheetPosition;
    }

    _animation = Tween<double>(
      begin: _sheetPosition,
      end: targetPosition,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward(from: 0);
  }

  void _togglePlayPause(int index) async {
    _pageManager.togglePlayPause(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                  });
                },
                onVerticalDragEnd: (DragEndDetails details) {
                  _snapSheetPosition();
                },
                isOnDesktopAndWeb: true,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ValueListenableBuilder<ProgressBarState>(
                    valueListenable: _pageManager.progressNotifier[0],
                    builder: (_, value, __) {
                      return ProgressBar(
                        thumbRadius: 0,
                        timeLabelLocation: TimeLabelLocation.none,
                        progress: value.current,
                        buffered: value.buffered,
                        total: value.total,
                        onSeek: (duration) {
                          _pageManager.seek(0, duration);
                        },
                      );
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      _songs[0]['image']!,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ListTile(
                      title: Text(_songs[0]['song']!),
                      subtitle: Text(_songs[0]['artist']!),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ValueListenableBuilder<ButtonState>(
                          valueListenable: _pageManager.buttonNotifier[0],
                          builder: (_, value, __) {
                            switch (value) {
                              case ButtonState.loading:
                                return Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: 32.0,
                                  height: 32.0,
                                  child: const CircularProgressIndicator(),
                                );
                              case ButtonState.paused:
                                return IconButton(
                                  icon: const Icon(Icons.play_arrow),
                                  iconSize: 32.0,
                                  onPressed: () {
                                    _togglePlayPause(0);
                                  },
                                );
                              case ButtonState.playing:
                                return IconButton(
                                  icon: const Icon(Icons.pause),
                                  iconSize: 32.0,
                                  onPressed: () {
                                    _togglePlayPause(0);
                                  },
                                );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ReorderableListView(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  children: _songs.map((song) {
                    int index = _songs.indexOf(song);
                    return _buildListItem(song, index);
                  }).toList(),
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final Map<String, dynamic> song =
                          _songs.removeAt(oldIndex);
                      _songs.insert(newIndex, song);
                      widget.onReorder(oldIndex, newIndex);
                      // _pageManager.reorderSongs(oldIndex,
                      //     newIndex); // Update PageManager with new order
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListItem(Map<String, dynamic> song, int index) {
    return ListTile(
      key: Key(song['song']!), // Required for ReorderableListView
      leading: SizedBox(
        width: 100,
        height: 100,
        child: Image.network(
          song['image']!,
          fit: BoxFit.fill,
        ),
      ),
      title: Text(song['song']!),
      subtitle: Text(song['artist']!),
      trailing: Icon(Icons.reorder),
    );
  }
}

class Grabber extends StatelessWidget {
  const Grabber({
    Key? key,
    required this.onVerticalDragUpdate,
    required this.isOnDesktopAndWeb,
    required this.child,
    this.onVerticalDragEnd,
  }) : super(key: key);

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;
  final GestureDragEndCallback? onVerticalDragEnd;
  final bool isOnDesktopAndWeb;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                width: 32.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
