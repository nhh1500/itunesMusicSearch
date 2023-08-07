import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:itunes_music/main.dart';
import 'package:itunes_music/model/artist.dart';
import 'package:itunes_music/model/playListBody.dart';
import 'package:itunes_music/model/playListHeader.dart';
import 'package:itunes_music/services/Api/ApiController.dart';
import 'package:itunes_music/utility/sharedPrefs.dart';
import 'package:itunes_music/utility/toastMessage.dart';
import 'package:itunes_music/view/ArtistPage/artistPage.dart';
import 'package:itunes_music/view/SongPage/addtoPlayListWidget.dart';
import 'package:itunes_music/viewModel/audioPlayer.dart';
import 'package:itunes_music/viewModel/userConfig.dart';
import 'package:just_audio/just_audio.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../model/positionData.dart';
import '../../model/song.dart';
import '../../services/audio/audioController.dart';
import '../../services/audio/audioHandler.dart';
import '../AudioPlayView/equalizerControls.dart';
import '../AudioPlayView/loudnessEnhancerControl.dart';

/// a page to play music whether a song or playlists
/// also support equalizer and loudness enhancer
class SongPage extends StatefulWidget {
  final List<Song>? songs;
  final int? listIndex;
  final Song? song;
  const SongPage({super.key, this.song, this.songs, this.listIndex});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> with WidgetsBindingObserver {
  ///audio controller
  //AudioPlayerVM player = Get.find<AudioPlayerVM>();
  AudioController player = Get.find<AudioController>();

  /// user config containes info whether the user want to autoplay
  UserConfig userConfig = Get.find<UserConfig>();

  @override
  void initState() {
    super.initState();
    //observe app life cycle
    //WidgetsBinding.instance.addObserver(this);
    // change mobile system bar color
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  ///init audio source
  Future<void> _init() async {
    if (widget.songs == null && widget.song == null) {
      throw 'Error';
    }
    //await player.init();
    if (widget.songs != null) {
      await player.setPlayList(widget.songs!);
      await player.seek(Duration.zero, index: widget.listIndex);
    } else {
      await player.setPlayList([widget.song!]);
    }
    if (userConfig.autoPlay) {
      await player.play();
    }
  }

  @override
  void dispose() {
    super.dispose();
    //WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      //await player.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              //streambuilder extract current audio source metadata and auto refresh whenever the source changed
              title: StreamBuilder<MediaItem?>(
                stream: player.mediaItem,
                builder: (context, snapshot) {
                  final mediaItem = snapshot.data;
                  if (mediaItem == null) return const SizedBox();
                  final metadata = Song.fromJson(mediaItem.extras!);
                  //scroll text if title length too long
                  return TextScroll(
                    metadata.trackName.toString(),
                    intervalSpaces: 5,
                    delayBefore: const Duration(seconds: 2),
                    pauseBetween: const Duration(seconds: 2),
                    fadedBorder: true,
                    fadeBorderSide: FadeBorderSide.right,
                    fadeBorderVisibility: FadeBorderVisibility.auto,
                    velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                  );
                },
              ),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                IconButton(
                    onPressed: () {
                      showAudioInfo();
                    },
                    icon: const Icon(Icons.info_outline))
              ],
            ),
            body: Column(
              children: [
                topButtonBar(),
                imageWidget(),
                songInfoWidget(),
                seekBarWidget(),
                const SizedBox(
                  height: 10,
                ),
                buttonPanel()
              ],
            )),
        onWillPop: () async {
          //stop song if user exits this page
          //await player.stop();
          return true;
        });
  }

  Widget topButtonBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
        IconButton(
            onPressed: _showAddPlayList, icon: const Icon(Icons.playlist_add)),
        //show equalizer button if sharePreference set to true
        userConfig.equalizer
            ? IconButton(
                onPressed: _showEqualizer, icon: const Icon(Icons.equalizer))
            : const SizedBox(),
        //show loudnessEnhancer button if sharePreference set to true
        userConfig.loudnessEnhancer
            ? IconButton(
                onPressed: _showLoudnessEnhancer,
                icon: const Icon(Icons.volume_up))
            : const SizedBox()
      ],
    );
  }

  Widget seekBarWidget() {
    //streambuilder extract current audio position and auto refresh seekbar whenever value updated
    return StreamBuilder<PositionData>(
      stream: player.positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ProgressBar(
            progress: positionData?.position ?? Duration.zero,
            buffered: positionData?.bufferedPosition ?? Duration.zero,
            total: positionData?.duration ?? Duration.zero,
            onSeek: (duration) {
              player.seek(duration);
            },
          ),
        );
      },
    );
  }

  //song image
  Widget imageWidget() {
    //streambuilder extract current audio metadata and auto refresh image whenever value updated
    return StreamBuilder<MediaItem?>(
      stream: player.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        if (mediaItem == null) return const SizedBox();
        final metadata = Song.fromJson(mediaItem.extras!);
        return LayoutBuilder(
          builder: (p0, p1) {
            return Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(
                        top: 10, left: 30, right: 30, bottom: 30),
                    height: p1.maxWidth,
                    width: p1.maxWidth,
                    child: CachedNetworkImage(
                      fadeInDuration: const Duration(milliseconds: 80),
                      imageUrl: metadata.artworkUrl100.toString().replaceAll(
                            RegExp('100x100'),
                            '300x300',
                          ),
                      fit: BoxFit.cover,
                    )),
              ],
            );
          },
        );
      },
    );
  }

  Widget songInfoWidget() {
    return Expanded(
        child: Center(
            //streambuilder extract current audio metadata and auto refresh widget whenever value updated
            child: StreamBuilder<MediaItem?>(
      stream: player.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        if (mediaItem == null) return const SizedBox();
        final metadata = Song.fromJson(mediaItem.extras!);
        return Column(
          children: [
            //text scroll if text is too long
            //song name
            TextScroll(
              metadata.trackName.toString(),
              style: const TextStyle(fontSize: 30),
              intervalSpaces: 10,
              fadedBorder: true,
              fadeBorderSide: FadeBorderSide.both,
              fadeBorderVisibility: FadeBorderVisibility.auto,
              velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
            ),
            //artist
            GestureDetector(
              //ontap go to artist profile page
              onTap: () async {
                var vm = Get.find<UserConfig>();
                var response = await ApiController.itunesMusicApi.lookup(
                    metadata.artistId!,
                    entity: 'allArtist',
                    country: vm.searchCountry,
                    lang: vm.searchLang);
                Map json = jsonDecode(response.toString().trim());
                List results = json['results'];
                Get.to(ArtistPage(artist: Artist.fromJson(results[0])));
              },
              child: TextScroll(
                metadata.artistName.toString(),
                style: const TextStyle(fontSize: 18),
                intervalSpaces: 10,
                fadedBorder: true,
                fadeBorderSide: FadeBorderSide.both,
                fadeBorderVisibility: FadeBorderVisibility.auto,
                velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
              ),
            ),
            //album
            GestureDetector(
              onTap: () {},
              child: TextScroll(
                metadata.collectionName.toString(),
                intervalSpaces: 10,
                fadedBorder: true,
                fadeBorderSide: FadeBorderSide.both,
                fadeBorderVisibility: FadeBorderVisibility.auto,
                velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
              ),
            ),
          ],
        );
      },
    )));
  }

  ///control buttons
  Widget buttonPanel() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //loop
          GestureDetector(
            child: const Icon(Icons.loop),
          ),
          //previous music
          GestureDetector(
              onTap: () async {
                bool success = await player.seekToPrevious();
                if (!success) {
                  ToastMessage.displayFloast('No previous song'.tr);
                }
              },
              child: previousButton()),
          //play or pause music
          playbuttonWidget(),
          //next music
          GestureDetector(
            onTap: () async {
              bool success = await player.seekToNext();
              if (!success) {
                ToastMessage.displayFloast('No next song'.tr);
              }
            },
            child: forwardButton(),
          ),
          //volume control
          GestureDetector(
            child: Icon(
              Icons.volume_down,
              size: 30,
            ),
          ),
          //show playlist if user enter this page from playlist or album page, otherwise should only show one song
          GestureDetector(
            onTap: showPlayList,
            child: const Icon(Icons.playlist_play),
          )
        ],
      ),
    );
  }

  /// play button
  Widget playbuttonWidget() {
    //change icon widget according to player state
    return StreamBuilder<PlaybackState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return GestureDetector(
            child: pauseButton(),
          );
        } else if (playing != true) {
          return GestureDetector(
            onTap: player.play,
            child: playButton(),
          );
        } else if (processingState != ProcessingState.completed) {
          return GestureDetector(
            onTap: player.pause,
            child: pauseButton(),
          );
        } else {
          return GestureDetector(
            onTap: () => player.seek(Duration.zero),
            child: replayButton(),
          );
        }
      },
    );
  }

  Widget previousButton() {
    return playerControlBtn(Icons.fast_rewind);
  }

  Widget forwardButton() {
    return playerControlBtn(Icons.fast_forward);
  }

  Widget playButton() {
    return playerControlBtn(Icons.play_arrow);
  }

  Widget pauseButton() {
    return playerControlBtn(Icons.pause);
  }

  Widget replayButton() {
    return playerControlBtn(Icons.replay);
  }

  // button decoration
  Widget playerControlBtn(IconData icon) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(side: BorderSide(color: Colors.black)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          size: 40,
        ),
      ),
    );
  }

  ///show equalizer
  Future<void> _showEqualizer() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Equalizer'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<bool>(
                  stream: player.equalizer.enabledStream,
                  builder: (context, snapshot) {
                    final enabled = snapshot.data ?? false;
                    return SwitchListTile(
                      title: const Text('Enable'),
                      value: enabled,
                      onChanged: player.equalizer.setEnabled,
                    );
                  },
                ),
                EqualizerControls(equalizer: player.equalizer),
              ],
            ),
          ),
        );
      },
    );
  }

  ///show loudness enhancer
  Future<void> _showLoudnessEnhancer() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('LoudnessEnhancer'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<bool>(
                  stream: player.loudnessEnhancer.enabledStream,
                  builder: (context, snapshot) {
                    final enabled = snapshot.data ?? false;
                    return SwitchListTile(
                      title: const Text('Enable'),
                      value: enabled,
                      onChanged: player.loudnessEnhancer.setEnabled,
                    );
                  },
                ),
                LoudnessEnhancerControls(
                    loudnessEnhancer: player.loudnessEnhancer),
              ],
            ),
          ),
        );
      },
    );
  }

  ///show playlist
  Future<void> _showAddPlayList() async {
    if (mounted) {
      Song? currentSource = player.currentSource;
      if (currentSource == null) {
        return;
      }
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add to playlist'),
            content: AddToPlayListWidget(songId: currentSource.trackId!),
          );
        },
      );
    }
  }

  //songTile in playlist, provide information about track Name, track Length, and current playing audio
  Widget songTile(Song song, int index, int currentIndex) {
    String mmss = durationToMMSS(Duration(milliseconds: song.trackTimeMillis!));
    return GestureDetector(
      onTap: () async {
        await player.seek(Duration.zero, index: index);
        await player.play();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        color: index % 2 == 0 ? Colors.grey[50] : Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 30,
              // set text to blue if audio is current playing this song
              child: Text(
                '${index + 1}',
                style: index == currentIndex
                    ? const TextStyle(color: Colors.blue)
                    : null,
              ),
            ),
            // set text to blue if audio is current playing this song
            Text(
              song.trackName.toString(),
              style: index == currentIndex
                  ? const TextStyle(color: Colors.blue)
                  : null,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            // set text to blue if audio is current playing this song
            Text(
              mmss,
              style: index == currentIndex
                  ? const TextStyle(color: Colors.blue)
                  : null,
            )
          ],
        ),
      ),
    );
  }

  /// convert duration to time format MM:SS
  String durationToMMSS(Duration duration) {
    final hh = (duration.inHours).toString();
    String mm = (duration.inMinutes % 60).toString();
    final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');
    String mmss = '';
    if (hh == '0') {
      mmss = '$mm:$ss';
    } else {
      mm = mm.padLeft(2, '0');
      mmss = '$hh:$mm:$ss';
    }
    return mmss;
  }

  ///show playList
  void showPlayList() {
    showModalBottomSheet(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: StreamBuilder<QueueState?>(
                stream: player.queueStateStream,
                builder: (context, snapshot) {
                  final queueState = snapshot.data ?? QueueState.empty;
                  final currentIndex = queueState.queueIndex;
                  if (widget.songs != null) {
                    return Column(
                        children: List.generate(
                            widget.songs!.length,
                            (index) => songTile(widget.songs![index], index,
                                currentIndex ?? 0)));
                  } else {
                    return songTile(widget.song!, 0, currentIndex ?? 0);
                  }
                },
              ),
            ));
      },
    );
  }

  void showAudioInfo() {
    showModalBottomSheet(
      backgroundColor: Colors.white.withOpacity(0.95),
      context: navigatorKey.currentContext!,
      builder: (context) {
        var currentSong = player.currentSource;
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
              child: keyValueWidget({
                'kind': '${currentSong?.kind}',
                'ArtistId': '${currentSong?.artistId}',
                'collectionId': '${currentSong?.collectionId}',
                'trackId': '${currentSong?.trackId}',
                'artistName': '${currentSong?.artistName}',
                'collectionName': '${currentSong?.collectionName}',
                'TrackName': '${currentSong?.trackName}',
                'collectionCensoredName':
                    '${currentSong?.collectionCensoredName}',
                'trackCensoredName': '${currentSong?.trackCensoredName}',
                'artistViewUrl': '${currentSong?.artistViewUrl}',
                'collectionViewUrl': '${currentSong?.collectionViewUrl}',
                'trackViewUrl': '${currentSong?.trackViewUrl}',
                'previewUrl': '${currentSong?.previewUrl}',
                'artworkUrl30': '${currentSong?.artworkUrl30}',
                'artworkUrl60': '${currentSong?.artworkUrl60}',
                'artworkUrl100': '${currentSong?.artworkUrl100}',
                'collectionPrice': '${currentSong?.collectionPrice}',
                'trackPrice': '${currentSong?.trackPrice}',
                'releaseDate': currentSong?.releaseDate,
                'collectionExplicitness':
                    '${currentSong?.collectionExplicitness}',
                'trackExplicitness': '${currentSong?.trackExplicitness}',
                'discCount': '${currentSong?.discCount}',
                'discNumber': '${currentSong?.discNumber}',
                'trackNumber': '${currentSong?.trackNumber}',
                'trackTimeMillis': '${currentSong?.trackTimeMillis}',
                'country': '${currentSong?.country}',
                'currency': '${currentSong?.currency}',
                'primaryGenreName': '${currentSong?.primaryGenreName}',
                'isStreamable': '${currentSong?.isStreamable}',
              }),
            ));
      },
    );
  }

  Widget keyValueWidget(Map<String, dynamic> info) {
    return SelectionArea(
        child: Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(info.length, (index) {
          dynamic value = info.values.elementAt(index);
          if (value is DateTime) {
            value = DateFormat('yyyy-MM-dd – kk:mm')
                .format((info.values.elementAt(index) as DateTime));
          }
          return Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 140,
                  child: Text(info.keys.elementAt(index)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Container(
                  child: Text(
                    value.toString(),
                  ),
                ))
              ],
            ),
          );
        }),
      ),
    ));
  }
}
