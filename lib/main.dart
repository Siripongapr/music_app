import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/data.dart';
import 'package:music_app/progress_bar_state.dart';
import 'package:music_app/widget/draggable_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const Playlist(),
    );
  }
}

class Playlist extends StatefulWidget {
  const Playlist({super.key});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  List<Map<String, dynamic>> songs = SongData().songs;
  late final PageManager _pageManager;

  @override
  void initState() {
    super.initState();
    _pageManager = PageManager(songs);
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  void _togglePlayPause(int index) async {
    _pageManager.togglePlayPause(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Playlist'),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  songs[0]['image']!,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: ListTile(
                  title: Text(songs[0]['song']!),
                  subtitle: Text(songs[0]['artist']!),
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
          DraggableScrollableSheetExample(
            songs: songs,
          ),
        ],
      ),
    );
  }
}
