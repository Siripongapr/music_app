import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/data.dart';
import 'package:music_app/widget/draggable_sheet.dart';
import 'package:music_app/widget/player.dart';

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
  const Playlist({super.key});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  final DraggableScrollableController sheetController =
      DraggableScrollableController();
  final player = AudioPlayer();
  final playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [
      AudioSource.uri(Uri.parse(
          'https://archive.org/download/attack-on-titan-advance-trails/01.%20Nikagetsu-go%20no%20Kimi%20e.mp3')),
      AudioSource.uri(Uri.parse(
          'https://archive.org/download/attack-on-titan-advance-trails/02.%20Guren%20no%20Yumiya.mp3')),
      AudioSource.uri(Uri.parse(
          'https://archive.org/download/attack-on-titan-advance-trails/03.%2014-moji%20no%20Dengon.mp3')),
      AudioSource.uri(Uri.parse(
          'https://archive.org/download/attack-on-titan-advance-trails/04.%20Guren%20no%20Zahyou.mp3')),
      AudioSource.uri(Uri.parse(
          'https://archive.org/download/attack-on-titan-advance-trails/05.%20Saigo%20no%20Senka.mp3')),
      AudioSource.uri(Uri.parse(
          'https://archive.org/download/attack-on-titan-advance-trails/06.%20Kami%20no%20Miwaza.mp3')),
      AudioSource.uri(Uri.parse(
          'https://archive.org/download/attack-on-titan-advance-trails/07.%20Jiyuu%20no%20Tsubasa.mp3')),
      AudioSource.uri(Uri.parse(
          'https://archive.org/download/attack-on-titan-advance-trails/08.%20Souyoku%20no%20Hikari.mp3')),
      AudioSource.uri(Uri.parse(
          'https://archive.org/download/attack-on-titan-advance-trails/09.%20Jiyuu%20no%20Daishou.mp3')),
      AudioSource.uri(Uri.parse(
          'https://archive.org/download/attack-on-titan-advance-trails/10.%20Kanojo%20wa%20Tsumetai%20Hitsugi%20no%20Naka%20de.mp3')),
      AudioSource.uri(Uri.parse(
          'https://archive.org/download/attack-on-titan-advance-trails/11.%20Shinzou%20wo%20Sasageyo%21.mp3')),
    ],
  );
  List<Map<String, dynamic>> songs = SongData().songs;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _togglePlayPause(int index) async {
    if (songs[index]['status'] == false) {
      songs.forEach((song) {
        song['status'] = false;
      });
      if (player.audioSource != playlist.children.indexed) {
        await player.setAudioSource(playlist, initialIndex: index);
      }
      setState(() {
        songs[index]['status'] = true;
      });

      player.play();
    } else {
      setState(() {
        songs[index]['status'] = false;
      });
      player.pause();
    }
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
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                _togglePlayPause(index);
                                setState(() {});
                              },
                              icon: Icon(
                                songs[index]['status']
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
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
