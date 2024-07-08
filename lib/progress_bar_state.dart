import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  late AudioPlayer _audioPlayer;
  late ConcatenatingAudioSource _playlist;
  late List<Map<String, dynamic>> _songs;
  late List<ValueNotifier<ProgressBarState>> progressNotifier;
  late List<ValueNotifier<ButtonState>> buttonNotifier;

  PageManager(List<Map<String, dynamic>> songs) {
    _songs = songs;
    _init();
  }

  void _init() {
    _audioPlayer = AudioPlayer();
    _updatePlaylist();

    // Initialize progress and button notifiers for each song
    progressNotifier = List.generate(
      _songs.length,
      (_) => ValueNotifier<ProgressBarState>(
        ProgressBarState(
          current: Duration.zero,
          buffered: Duration.zero,
          total: Duration.zero,
        ),
      ),
    );

    buttonNotifier = List.generate(
      _songs.length,
      (_) => ValueNotifier<ButtonState>(ButtonState.paused),
    );

    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier[_audioPlayer.currentIndex ?? 0].value =
            ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier[_audioPlayer.currentIndex ?? 0].value =
            ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier[_audioPlayer.currentIndex ?? 0].value =
            ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final int index = _audioPlayer.currentIndex ?? 0;
      final oldState = progressNotifier[index].value;
      progressNotifier[index].value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final int index = _audioPlayer.currentIndex ?? 0;
      final oldState = progressNotifier[index].value;
      progressNotifier[index].value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final int index = _audioPlayer.currentIndex ?? 0;
      final oldState = progressNotifier[index].value;
      progressNotifier[index].value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void _updatePlaylist() {
    _playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: _songs
          .map((song) => AudioSource.uri(Uri.parse(song['url'])))
          .toList(),
    );
  }

  Future<void> setAudioSource(ConcatenatingAudioSource source,
      {int initialIndex = 0}) async {
    try {
      await _audioPlayer.setAudioSource(source, initialIndex: initialIndex);
    } catch (e) {
      print('Error setting audio source: $e');
      // Handle error, e.g., show a message to the user
    }
  }

  void togglePlayPause(int index) async {
    if (buttonNotifier[index].value == ButtonState.paused) {
      for (int i = 0; i < _songs.length; i++) {
        if (i != index) {
          buttonNotifier[i].value = ButtonState.paused;
        }
      }
      await setAudioSource(_playlist, initialIndex: index);
      play();
    } else {
      pause();
    }
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(int index, Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  Future<void> reorderSongs(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final song = _songs.removeAt(oldIndex);
    _songs.insert(newIndex, song);

    // Check if the current index needs to be updated
    int? currentIndex = _audioPlayer.currentIndex;
    if (currentIndex != null) {
      if (oldIndex == currentIndex) {
        currentIndex = newIndex;
      } else if (oldIndex < currentIndex && newIndex >= currentIndex) {
        currentIndex -= 1;
      } else if (oldIndex > currentIndex && newIndex <= currentIndex) {
        currentIndex += 1;
      }
    }

    _updatePlaylist();

    // Update audio source without reloading
    await _audioPlayer.setAudioSource(_playlist,
        initialIndex: currentIndex ?? 0);
  }
}

class ProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
}

enum ButtonState { paused, playing, loading }
