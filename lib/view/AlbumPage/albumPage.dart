import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/services/ApiController.dart';
import 'package:itunes_music/viewModel/userConfig.dart';
import 'package:just_audio/just_audio.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../model/album.dart';
import '../../model/song.dart';
import '../../viewModel/audioPlayer.dart';

class AlbumPage extends StatefulWidget {
  final Album album;
  const AlbumPage({super.key, required this.album});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> with WidgetsBindingObserver {
  late AudioPlayerVM player;
  List<Song> songs = [];
  Future? future;

  @override
  void initState() {
    super.initState();
    player = Get.find<AudioPlayerVM>();
    WidgetsBinding.instance.addObserver(this);
    future = init();
  }

  Future init() async {
    await player.init();
    await getAlbumDetail();
    await player.setPlayList(songs);
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

  Future getAlbumDetail() async {
    songs.clear();
    var vm = Get.find<UserConfig>();
    var response = await ApiController.itunesMusicApi.lookup(
        widget.album.collectionId!,
        entity: 'song',
        country: vm.searchCountry,
        lang: vm.searchLang);
    Map json = jsonDecode(response.toString().trim());
    List results = json['results'];
    for (var itm in results) {
      if (itm['wrapperType'].toString().toLowerCase() == 'track') {
        songs.add(Song.fromJson(itm));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: TextScroll(
                widget.album.collectionName.toString(),
                intervalSpaces: 5,
                delayBefore: Duration(seconds: 2),
                pauseBetween: Duration(seconds: 2),
                fadedBorder: true,
                fadeBorderSide: FadeBorderSide.right,
                fadeBorderVisibility: FadeBorderVisibility.auto,
                velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
              ),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: body()),
        onWillPop: () async {
          await player.stop();
          return true;
        });
  }

  Widget body() {
    return Column(
      children: [header(), Expanded(child: songList())],
    );
  }

  Widget songList() {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
            child: StreamBuilder<SequenceState?>(
              stream: player.sequenceStateStream,
              builder: (context, snapshot) {
                final currentIndex = snapshot.data?.currentIndex;
                return Column(
                    children: List.generate(
                        songs.length,
                        (index) =>
                            songTile(songs[index], index, currentIndex ?? 0)));
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget header() {
    return SizedBox(
      height: 150,
      child: Row(
        children: [
          Image.network(
            widget.album.artworkUrl100.toString(),
            fit: BoxFit.cover,
            width: 150,
            height: 150,
          ),
          Expanded(
              child: Stack(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  albumInfo()
                ],
              ),
              controlButton()
            ],
          )),
        ],
      ),
    );
  }

  Widget controlButton() {
    return Positioned(
        right: 10,
        bottom: 5,
        child: StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
              );
            } else if (playing != true) {
              return GestureDetector(
                onTap: () => player.play(),
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return GestureDetector(
                onTap: () => player.pause(),
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.pause,
                    color: Colors.white,
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () => player.seek(Duration.zero, index: 0),
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.replay,
                    color: Colors.white,
                  ),
                ),
              );
            }
          },
        ));
  }

  Widget albumInfo() {
    return Expanded(
        child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.album.collectionName!,
            maxLines: 2,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                overflow: TextOverflow.ellipsis),
          ),
          Text(
            widget.album.artistName!,
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.w500, fontSize: 18),
          ),
          Text(
            '${widget.album.primaryGenreName!} - ${widget.album.releaseDate!.year}',
            style: TextStyle(color: Colors.grey[500]),
          )
        ],
      ),
    ));
  }

  Widget songTile(Song song, int index, int currentIndex) {
    Duration duration = Duration(milliseconds: song.trackTimeMillis!);
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
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () async {
              await player.seek(Duration.zero, index: index);
              await player.play();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              color: index % 2 == 0 ? Colors.grey[50] : Colors.white,
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(
                      '${index + 1}',
                      style: index == currentIndex
                          ? TextStyle(color: Colors.blue)
                          : null,
                    ),
                  ),
                  Text(
                    song.trackName.toString(),
                    style: index == currentIndex
                        ? TextStyle(color: Colors.blue)
                        : null,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    mmss,
                    style: index == currentIndex
                        ? TextStyle(color: Colors.blue)
                        : null,
                  )
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
