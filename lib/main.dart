import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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
      home: Playlist(),
    );
  }
}

class Playlist extends StatefulWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  late final PageManager _pageManager;

  List<Map<String, dynamic>> songs = SongData().songs;

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
        title: Text('My Playlist'),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: songs.length,
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
                            songs[index]['image']!,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ListTile(
                            title: Text(songs[index]['song']!),
                            subtitle: Text(songs[index]['artist']!),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: ValueListenableBuilder<ProgressBarState>(
                            valueListenable:
                                _pageManager.progressNotifier[index],
                            builder: (_, value, __) {
                              return ProgressBar(
                                progress: value.current,
                                buffered: value.buffered,
                                total: value.total,
                                onSeek: (duration) {
                                  _pageManager.seek(index, duration);
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ValueListenableBuilder<ButtonState>(
                              valueListenable:
                                  _pageManager.buttonNotifier[index],
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
                                        _togglePlayPause(index);
                                      },
                                    );
                                  case ButtonState.playing:
                                    return IconButton(
                                      icon: const Icon(Icons.pause),
                                      iconSize: 32.0,
                                      onPressed: () {
                                        _togglePlayPause(index);
                                      },
                                    );
                                }
                              },
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
          DraggableScrollableSheetExample(
            songs: songs,
          ),
        ],
      ),
    );
  }
}
