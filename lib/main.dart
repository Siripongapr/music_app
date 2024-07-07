import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_app/widget/player.dart';
import 'package:music_app/widget/draggable_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  List<Map<String, dynamic>> songs = [
    {
      'song': 'Song 1',
      'artist': 'Artist 1',
      'image': 'https://mpics.mgronline.com/pics/Images/566000000527601.JPEG',
      'status': false
    },
    {
      'song': 'Song 2',
      'artist': 'Artist 2',
      'image':
          'https://m.media-amazon.com/images/M/MV5BNDFjYTIxMjctYTQ2ZC00OGQ4LWE3OGYtNDdiMzNiNDZlMDAwXkEyXkFqcGdeQXVyNzI3NjY3NjQ@._V1_FMjpg_UX1000_.jpg',
      "status": false
    },
    {
      'song': 'Song 3',
      'artist': 'Artist 3',
      'image':
          'https://static1.srcdn.com/wordpress/wp-content/uploads/2022/01/attack-on-titan-warrior-characters-season-4.jpg',
      'status': false
    },
    {
      'song': 'Song 4',
      'artist': 'Artist 4',
      'image': 'https://mpics.mgronline.com/pics/Images/566000000527601.JPEG',
      'status': false
    },
    {
      'song': 'Song 5',
      'artist': 'Artist 5',
      'image':
          'https://m.media-amazon.com/images/M/MV5BNDFjYTIxMjctYTQ2ZC00OGQ4LWE3OGYtNDdiMzNiNDZlMDAwXkEyXkFqcGdeQXVyNzI3NjY3NjQ@._V1_FMjpg_UX1000_.jpg',
      "status": false
    },
    {
      'song': 'Song 6',
      'artist': 'Artist 6',
      'image':
          'https://static1.srcdn.com/wordpress/wp-content/uploads/2022/01/attack-on-titan-warrior-characters-season-4.jpg',
      'status': false
    },
    {
      'song': 'Song 7',
      'artist': 'Artist 7',
      'image': 'https://mpics.mgronline.com/pics/Images/566000000527601.JPEG',
      'status': false
    },
    {
      'song': 'Song 8',
      'artist': 'Artist 8',
      'image':
          'https://m.media-amazon.com/images/M/MV5BNDFjYTIxMjctYTQ2ZC00OGQ4LWE3OGYtNDdiMzNiNDZlMDAwXkEyXkFqcGdeQXVyNzI3NjY3NjQ@._V1_FMjpg_UX1000_.jpg',
      "status": false
    },
    {
      'song': 'Song 9',
      'artist': 'Artist 9',
      'image':
          'https://static1.srcdn.com/wordpress/wp-content/uploads/2022/01/attack-on-titan-warrior-characters-season-4.jpg',
      'status': false
    },
    // Add more songs here
  ];
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
                            )),
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
                                setState(() {
                                  songs[index]['status'] =
                                      !songs[index]['status'];
                                });
                                print("status: ${songs[index]['status']}");
                              },
                              icon: Icon(songs[index]['status']
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
          DraggableScrollableSheetExample(
            songs: songs,
          )
        ],
      ),
      // bottomSheet: DraggableScrollableSheetExample()

      // SizedBox(
      //   height: 100,
      //   child: Padding(
      //     padding: const EdgeInsets.all(10.0),
      //     child: Row(
      //       children: [
      //         SizedBox(
      //             width: 100,
      //             height: 100,
      //             child: Image.network(
      //               songs[1]['image']!,
      //               fit: BoxFit.fill,
      //             )),
      //         SizedBox(
      //           width: 100,
      //           height: 100,
      //           child: ListTile(
      //             title: Text(songs[1]['song']!),
      //             subtitle: Text(songs[1]['artist']!),
      //           ),
      //         ),
      //         Expanded(
      //           child: Align(
      //             alignment: Alignment.centerRight,
      //             child: IconButton(
      //               onPressed: () {
      //                 setState(() {
      //                   songs[1]['status'] = !songs[1]['status'];
      //                 });
      //                 print("status: ${songs[1]['status']}");
      //               },
      //               icon: Icon(
      //                   songs[1]['status'] ? Icons.play_arrow : Icons.pause),
      //             ),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

// class Playlist extends StatelessWidget {
//   const Playlist({super.key});
//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> songs = [
//       {
//         'song': 'Song 1',
//         'artist': 'Artist 1',
//         'image': 'https://mpics.mgronline.com/pics/Images/566000000527601.JPEG',
//         'status': false
//       },
//       {
//         'song': 'Song 2',
//         'artist': 'Artist 2',
//         'image':
//             'https://m.media-amazon.com/images/M/MV5BNDFjYTIxMjctYTQ2ZC00OGQ4LWE3OGYtNDdiMzNiNDZlMDAwXkEyXkFqcGdeQXVyNzI3NjY3NjQ@._V1_FMjpg_UX1000_.jpg',
//         "status": false
//       },
//       {
//         'song': 'Song 3',
//         'artist': 'Artist 3',
//         'image':
//             'https://static1.srcdn.com/wordpress/wp-content/uploads/2022/01/attack-on-titan-warrior-characters-season-4.jpg',
//         'status': false
//       },
//       // Add more songs here
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Playlist'),
//         centerTitle: false,
//       ),
//       body: ListView.builder(
//         itemCount: songs.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     SizedBox(
//                         width: 100,
//                         height: 100,
//                         child: Image.network(
//                           songs[index]['image']!,
//                           fit: BoxFit.fill,
//                         )),
//                     SizedBox(
//                       width: 100,
//                       height: 100,
//                       child: ListTile(
//                         title: Text(songs[index]['song']!),
//                         subtitle: Text(songs[index]['artist']!),
//                       ),
//                     ),
//                     Expanded(
//                       child: Align(
//                         alignment: Alignment.centerRight,
//                         child: IconButton(
//                           onPressed: () {
//                             songs[index]['status'] = !songs[index]['status'];
//                           },
//                           icon: Icon(songs[index]['status']
//                               ? Icons.play_arrow
//                               : Icons.pause),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// class DashBoard extends StatelessWidget {
//   const DashBoard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     List<ValueNotifier<bool>> isPlaylistSelectedNotifierList = List.generate(
//       10,
//       (index) => ValueNotifier<bool>(false),
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: const Align(
//             alignment: Alignment.topLeft, child: Text('My Playlist')),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: 10,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text('Song $index'),
//                   subtitle: Text('Artist $index'),
//                   leading: const Icon(Icons.music_note),
//                   trailing: MouseRegion(
//                     cursor: SystemMouseCursors.click,
//                     child: GestureDetector(
//                         onTap: () {
//                           print('pressed');
//                           isPlaylistSelectedNotifierList[index].value =
//                               !isPlaylistSelectedNotifierList[index].value;
//                         },
//                         child: ValueListenableBuilder(
//                           valueListenable:
//                               isPlaylistSelectedNotifierList[index],
//                           builder: (context, value, child) {
//                             return Icon(
//                                 isPlaylistSelectedNotifierList[index].value
//                                     ? Icons.play_arrow
//                                     : Icons.pause);
//                           },
//                         )),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
