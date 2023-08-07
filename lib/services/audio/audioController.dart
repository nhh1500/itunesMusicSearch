import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:itunes_music/services/audio/audioHandler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';

import '../../model/positionData.dart';
import '../../model/song.dart';

class AudioController extends GetxController {
  ///main controller
  late final AudioPlayerHandler _audioHandler;

  ///current song that is playing
  Song? get currentSource => mediaItemToSong(_audioHandler.currentSource);

  ///equalizer controller
  AndroidEqualizer get equalizer => _audioHandler.equalizer;

  /// loudnessEnhancer controller
  AndroidLoudnessEnhancer get loudnessEnhancer =>
      _audioHandler.loudnessEnhancer;

  ///position data contains buffer, current position, and total duration information
  Stream<PositionData> get positionDataStream =>
      _audioHandler.positionDataStream;

  ///player status
  Stream<PlaybackState> get playerStateStream => _audioHandler.playbackState;

  Stream<QueueState> get queueStateStream => _audioHandler.queueState;

  Stream<MediaItem?> get mediaItem => _audioHandler.mediaItem;

  Future init() async {
    _audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandlerImpl(),
      config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.itunes.search.channel.audio',
          androidNotificationChannelName: 'Audio playback',
          androidNotificationOngoing: false,
          androidStopForegroundOnPause: true),
    );
  }

  ///set playlist
  Future setPlayList(List<Song> songList) async {
    await _audioHandler.updateQueue(songList.map(songToMediaItem).toList());
    await _audioHandler.setAudio();
  }

  /// play music
  Future play() => _audioHandler.play();

  ///pause music
  Future pause() => _audioHandler.pause();

  ///stop music
  Future stop() => _audioHandler.stop();

  ///seek to previous music from the playlist
  Future<bool> seekToPrevious() async {
    if (_audioHandler.currentQueueState!.hasPrevious) {
      await _audioHandler.skipToPrevious();
      return true;
    } else {
      return false;
    }
  }

  ///seek to next music from the playlist
  Future<bool> seekToNext() async {
    if (_audioHandler.currentQueueState!.hasNext) {
      await _audioHandler.skipToNext();
      return true;
    } else {
      return false;
    }
  }

  Future seek(Duration newPosition, {int? index}) async {
    if (index != null) {
      await _audioHandler.skipToQueueItem(index);
    }
    await _audioHandler.seek(newPosition);
  }

  Future seekToItem(int index) async {
    await _audioHandler.skipToQueueItem(index);
  }

  /// Sets the volume of this player, where 1.0 is normal volume.
  Future setVolume(double volume) async {
    if (volume < 0) return;
    if (volume > 1) return;
    await _audioHandler.setVolume(volume);
  }

  MediaItem songToMediaItem(Song song) {
    return MediaItem(
        id: song.previewUrl.toString(),
        title: song.trackName!,
        album: song.collectionName,
        artUri: Uri.parse(song.artworkUrl100!),
        artist: song.artistName,
        genre: song.primaryGenreName,
        playable: true,
        extras: song.toJson());
  }

  Song? mediaItemToSong(MediaItem? item) {
    if (item != null) {
      return Song.fromJson(item.extras!);
    } else {
      return null;
    }
  }
}
