import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:itunes_music/model/artist.dart';
import 'package:itunes_music/model/playListBody.dart';
import 'package:itunes_music/model/playListHeader.dart';
import 'package:itunes_music/services/ApiController.dart';
import 'package:itunes_music/utility/sharedPrefs.dart';
import 'package:itunes_music/view/ArtistPage/artistPage.dart';
import 'package:itunes_music/view/SongPage/addtoPlayListWidget.dart';
import 'package:itunes_music/viewModel/audioPlayer.dart';
import 'package:itunes_music/viewModel/playListHeaderVM.dart';
import 'package:itunes_music/viewModel/playlistbdyVM.dart';
import 'package:itunes_music/viewModel/userConfig.dart';
import 'package:just_audio/just_audio.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../model/song.dart';
import '../AudioPlayView/equalizerControls.dart';
import '../AudioPlayView/loudnessEnhancerControl.dart';
import '../AudioPlayView/seekBar.dart';

class SongPage extends StatefulWidget {
  final Song song;
  const SongPage({super.key, required this.song});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> with WidgetsBindingObserver {
  late AudioPlayerVM player;
  late UserConfig userConfig;

  @override
  void initState() {
    super.initState();
    player = Get.find<AudioPlayerVM>();
    userConfig = Get.find<UserConfig>();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    _init();
  }

  Future<void> _init() async {
    await player.init();
    await player.setAudio(widget.song);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      await player.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: TextScroll(
                widget.song.trackName.toString(),
                intervalSpaces: 5,
                delayBefore: Duration(seconds: 2),
                pauseBetween: Duration(seconds: 2),
                fadedBorder: true,
                fadeBorderSide: FadeBorderSide.right,
                fadeBorderVisibility: FadeBorderVisibility.auto,
                velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
              ),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.share)),
                IconButton(onPressed: () {}, icon: Icon(Icons.info_outline))
              ],
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
                    IconButton(
                        onPressed: _showPlayList,
                        icon: const Icon(Icons.list_rounded)),
                    userConfig.equalizer
                        ? IconButton(
                            onPressed: _showEqualizer,
                            icon: const Icon(Icons.equalizer))
                        : const SizedBox(),
                    userConfig.loudnessEnhancer
                        ? IconButton(
                            onPressed: _showLoudnessEnhancer,
                            icon: Icon(Icons.volume_up))
                        : const SizedBox()
                  ],
                ),
                LayoutBuilder(
                  builder: (p0, p1) {
                    return Container(
                      padding: const EdgeInsets.only(
                          top: 10, left: 30, right: 30, bottom: 30),
                      height: p1.maxWidth,
                      width: p1.maxWidth,
                      child: Image.network(
                        widget.song.artworkUrl100
                            .toString()
                            .replaceAll(RegExp('100x100'), '300x300'),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
                Expanded(
                    child: Container(
                  //color: Colors.purple[100],
                  child: Center(
                    child: Column(
                      children: [
                        TextScroll(
                          widget.song.trackName.toString(),
                          style: TextStyle(fontSize: 30),
                          intervalSpaces: 10,
                          fadedBorder: true,
                          fadeBorderSide: FadeBorderSide.both,
                          fadeBorderVisibility: FadeBorderVisibility.auto,
                          velocity:
                              const Velocity(pixelsPerSecond: Offset(50, 0)),
                        ),
                        GestureDetector(
                          onTap: () async {
                            var vm = Get.find<UserConfig>();
                            var response = await ApiController.itunesMusicApi
                                .lookup(widget.song.artistId!,
                                    entity: 'allArtist',
                                    country: vm.searchCountry,
                                    lang: vm.searchLang);
                            Map json = jsonDecode(response.toString().trim());
                            List results = json['results'];
                            Get.to(ArtistPage(
                                artist: Artist.fromJson(results[0])));
                          },
                          child: TextScroll(
                            widget.song.artistName.toString(),
                            style: TextStyle(fontSize: 18),
                            intervalSpaces: 10,
                            fadedBorder: true,
                            fadeBorderSide: FadeBorderSide.both,
                            fadeBorderVisibility: FadeBorderVisibility.auto,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(50, 0)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: TextScroll(
                            widget.song.collectionName.toString(),
                            intervalSpaces: 10,
                            fadedBorder: true,
                            fadeBorderSide: FadeBorderSide.both,
                            fadeBorderVisibility: FadeBorderVisibility.auto,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(50, 0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                StreamBuilder<PositionData>(
                  stream: player.positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: player.seek,
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                buttonPanel()
              ],
            )),
        onWillPop: () async {
          await player.stop();
          return true;
        });
  }

  Widget buttonPanel() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            child: Icon(Icons.loop),
          ),
          GestureDetector(child: previousButton()),
          StreamBuilder<PlayerState>(
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
          ),
          GestureDetector(
            child: forwardButton(),
          ),
          GestureDetector(
            child: Icon(
              Icons.volume_down,
              size: 30,
            ),
          )
        ],
      ),
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

  Future<void> _showPlayList() async {
    if (mounted) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add to playlist'),
            content: AddToPlayListWidget(songId: widget.song.trackId!),
          );
        },
      );
    }
  }
}
