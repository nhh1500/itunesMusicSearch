import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/model/playListBody.dart';
import 'package:itunes_music/model/song.dart';
import 'package:itunes_music/services/ApiController.dart';
import 'package:itunes_music/view/SearchPage/songItem.dart';
import 'package:itunes_music/viewModel/playlistbdyVM.dart';
import 'package:itunes_music/viewModel/userConfig.dart';

class PlayListDetailPage extends StatefulWidget {
  final String listName;
  final int playListHeaderId;
  const PlayListDetailPage(
      {super.key, required this.playListHeaderId, required this.listName});

  @override
  State<PlayListDetailPage> createState() => _PlayListDetailPageState();
}

class _PlayListDetailPageState extends State<PlayListDetailPage> {
  UserConfig userConfig = Get.find<UserConfig>();
  PlayListbdyVM vm = Get.find<PlayListbdyVM>();
  Future? future;
  List<PlayListBody> playlist = [];
  List<Song> songs = [];

  @override
  void initState() {
    super.initState();
    future = refresh();
  }

  Future refresh() async {
    playlist = await vm.readPlayListDetail(widget.playListHeaderId);
    songs = await fetchAllSong();
    setState(() {});
  }

  List<int> joinId() {
    List<int> ids = [];
    for (var item in playlist) {
      ids.add(item.songId);
    }
    return ids;
  }

  Future<List<Song>> fetchAllSong() async {
    songs.clear();
    var response = await ApiController.itunesMusicApi.lookupMutliple(joinId(),
        entity: 'song',
        country: userConfig.searchCountry,
        lang: userConfig.searchLang);
    Map json = jsonDecode(response.toString().trim());
    List results = json['results'];
    for (var itm in results) {
      if (itm['wrapperType'].toString().toLowerCase() == 'track') {
        songs.add(Song.fromJson(itm));
      }
    }
    return songs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.listName),
        ),
        body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return body();
            } else {
              return const SizedBox();
            }
          },
        ));
  }

  Widget body() {
    if (playlist.isNotEmpty) {
      return SingleChildScrollView(
          child: Column(
              children: List.generate(
                  songs.length, (index) => playListItem(songs[index]))));
    } else {
      return emptyPlayList();
    }
  }

  Widget playListItem(Song song) {
    return SongItem(song: song);
  }

  Widget emptyPlayList() {
    return const Center(
      child: Text('Empty'),
    );
  }
}
