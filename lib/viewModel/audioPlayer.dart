import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart' as rx;
import '../model/positionData.dart';
import '../model/song.dart';

///audio player view model
///provide method to fully control audio. it can setAudioSource, play, pause, previous, and next,etc...
class AudioPlayerVM extends GetxController {
  final _equalizer = AndroidEqualizer();
  final _loudnessEnhancer = AndroidLoudnessEnhancer();

  ///return current source metadata that is playing
  Song? get currentSource => _player.sequenceState?.currentSource?.tag as Song?;

  /// to adjust the gain for different frequency bands
  AndroidEqualizer get equalizer => _equalizer;

  ///boosts the volume of the audio signal to a target gain, which defaults to zero
  AndroidLoudnessEnhancer get loudnessEnhancer => _loudnessEnhancer;

  ///main audio controller
  late final AudioPlayer _player = AudioPlayer(
      audioPipeline:
          AudioPipeline(androidAudioEffects: [_loudnessEnhancer, _equalizer]));
  ConcatenatingAudioSource _playerList = ConcatenatingAudioSource(children: []);

  ///return current position of the song that is playing
  Stream<PositionData> get positionDataStream =>
      rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
  Stream<SequenceState?> get sequenceStateStream => _player.sequenceStateStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  ///append audio source to current playList
  Future addPlayList(Song song) async {
    AudioSource source = LockCachingAudioSource(
        Uri.parse(song.previewUrl.toString()),
        tag: song);
    await _playerList.add(source);
  }

  ///set multiple audio source
  Future setPlayList(List<Song> songList) async {
    await _playerList.clear();
    List<AudioSource> sourceList = [];
    for (var item in songList) {
      sourceList.add(LockCachingAudioSource(
          Uri.parse(item.previewUrl.toString()),
          tag: item));
    }
    await _playerList.addAll(sourceList);
    await _player.setAudioSource(_playerList);
  }

  ///remove specific item from playlist
  Future removePlayList(int index) async {
    await _playerList.removeAt(index);
  }

  ///clear playlist
  Future clearPlayList() async {
    await _playerList.clear();
  }

  /// seek to specific position, if index != null then it will seek to specific song in the playlist
  Future seek(Duration newPosition, {int? index}) async {
    await _player.seek(newPosition, index: index);
  }

  /// init audio controller
  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    //initCompleteListener();
  }

  ///preform action whenever the audio source finish
  void initCompleteListener() {
    // Show a snackbar whenever reaching the end of an item in the playlist.
    _player.positionDiscontinuityStream.listen((discontinuity) {
      if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
        int? index = discontinuity.previousEvent.currentIndex;
        if (index == null) return;
        final sequence = _player.sequence;
        if (sequence == null) return;
      }
    });
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        int? index = _player.currentIndex;
        if (index == null) return;
        final sequence = _player.sequence;
        if (sequence == null) return;
        final source = sequence[index];
        final metadata = source.tag as Song;
        // do something whenever reaching the end of an item
      }
    });
  }

  /// Sets the volume of this player, where 1.0 is normal volume.
  Future setVolume(double volume) async {
    if (volume < 0) return;
    if (volume > 1) return;
    _player.setVolume(volume);
  }

  ///seek to previous music from the playlist
  Future<bool> seekToPrevious() async {
    if (_player.hasPrevious) {
      await _player.seekToPrevious();
      return true;
    } else {
      return false;
    }
  }

  ///stop music
  Future<void> stop() async {
    await _player.stop();
  }

  ///seek to next music from the playlist
  Future<bool> seekToNext() async {
    if (_player.hasNext) {
      await _player.seekToNext();
      return true;
    } else {
      return false;
    }
  }

  ///pause music
  Future<void> pause() async {
    await _player.pause();
  }

  ///set audio source and precache audio
  Future<void> setAudio(Song song) async {
    LockCachingAudioSource source = LockCachingAudioSource(
        Uri.parse(song.previewUrl.toString()),
        tag: song);

    try {
      // Use resolve() if you want to obtain a UriAudioSource pointing directly
      // to the cache file.
      // await _player.setAudioSource(await _audioSource.resolve());
      await _player.setAudioSource(source);
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  /// play music
  Future<void> play() async {
    return await _player.play();
  }
}
