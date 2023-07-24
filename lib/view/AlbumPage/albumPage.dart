import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/services/ApiController.dart';
import 'package:itunes_music/view/SongPage/songPage.dart';
import 'package:itunes_music/viewModel/userConfig.dart';
import 'package:just_audio/just_audio.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../model/album.dart';
import '../../model/song.dart';

///album Page
class AlbumPage extends StatefulWidget {
  final Album album;
  const AlbumPage({super.key, required this.album});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  ///hold all songs for this album
  List<Song> songs = [];
  Future? future;

  @override
  void initState() {
    super.initState();
    future = init();
  }

  Future init() async {
    await getAlbumDetail();
  }

  ///fetch all songs from album
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
    return Scaffold(
        appBar: AppBar(
          //album name
          title: TextScroll(
            widget.album.collectionName.toString(),
            intervalSpaces: 5,
            delayBefore: const Duration(seconds: 2),
            pauseBetween: const Duration(seconds: 2),
            fadedBorder: true,
            fadeBorderSide: FadeBorderSide.right,
            fadeBorderVisibility: FadeBorderVisibility.auto,
            velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: body());
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
            child: Column(
                children: List.generate(
                    songs.length, (index) => songTile(songs[index], index))),
          );
        } else {
          return Container();
        }
      },
    );
  }

  ///album info
  Widget header() {
    return SizedBox(
      height: 150,
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: widget.album.artworkUrl100.toString(),
            fadeInDuration: const Duration(milliseconds: 80),
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

  ///play button
  Widget controlButton() {
    return Positioned(
        right: 10,
        bottom: 5,
        child: GestureDetector(
          onTap: () => Get.to(SongPage(
            songs: songs,
            listIndex: 0,
          )),
          child: CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ));
  }

  ///show album name, artist name, genre, release date
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

  ///song widget
  Widget songTile(Song song, int index) {
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
              Get.to(SongPage(
                songs: songs,
                listIndex: index,
              ));
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
                    ),
                  ),
                  Text(
                    song.trackName.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    mmss,
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
