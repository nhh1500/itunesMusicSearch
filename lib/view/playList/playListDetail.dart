import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/model/playListBody.dart';
import 'package:itunes_music/model/song.dart';
import 'package:itunes_music/services/Api/ApiController.dart';
import 'package:itunes_music/services/DB/dbManager.dart';
import 'package:itunes_music/view/SearchPage/songItem.dart';
import 'package:itunes_music/view/SongPage/songPage.dart';
import 'package:itunes_music/viewModel/userConfig.dart';

///playlist detail
///show all songs in this playlist
class PlayListDetailPage extends StatefulWidget {
  final String listName;
  final int playListHeaderId;
  const PlayListDetailPage(
      {super.key, required this.playListHeaderId, required this.listName});

  @override
  State<PlayListDetailPage> createState() => _PlayListDetailPageState();
}

class _PlayListDetailPageState extends State<PlayListDetailPage> {
  ///user config view model
  UserConfig userConfig = Get.find<UserConfig>();
  Future? future;

  ///all songs
  List<PlayListBody> playlist = [];

  ///all songs
  List<Song> songs = [];

  @override
  void initState() {
    super.initState();
    future = refresh();
  }

  Future refresh() async {
    playlist = await DBManager.playlistBody.read(widget.playListHeaderId);
    songs = await fetchAllSong();
    setState(() {});
  }

  ///prepare list of song Ids to fetch data
  List<int> joinId() {
    List<int> ids = [];
    for (var item in playlist) {
      ids.add(item.songId);
    }
    return ids;
  }

  ///fetch all songs in this playlist
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
      ),
      // play playlist
      floatingActionButton: GestureDetector(
        onTap: () => Get.to(SongPage(
          songs: songs,
          listIndex: 0,
        )),
        child: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red,
            child: Icon(
              size: 40,
              Icons.play_arrow,
              color: Colors.white,
            )),
      ),
    );
  }

  //list of songs
  Widget body() {
    if (playlist.isNotEmpty) {
      return ReorderableListView.builder(
          shrinkWrap: true,
          buildDefaultDragHandles: false,
          itemBuilder: (context, index) {
            return Row(
              key: Key('$index'),
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: GestureDetector(
                  onLongPress: () async {
                    await _showOption(playlist[index]);
                  },
                  child: SongItem(song: songs[index]),
                )),
                ReorderableDragStartListener(
                    index: index,
                    child: const Icon(
                      Icons.drag_handle,
                      color: Color.fromARGB(255, 155, 155, 155),
                    ))
              ],
            );
          },
          itemCount: songs.length,
          onReorder: onReorder);
    } else {
      return emptyPlayList();
    }
  }

  //empty playList
  Widget emptyPlayList() {
    return const Center(
      child: Text('Empty'),
    );
  }

  //reorder Index
  Future onReorder(int oldIndex, int newIndex) async {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      var row = playlist.removeAt(oldIndex);
      playlist.insert(newIndex, row);

      var row2 = songs.removeAt(oldIndex);
      songs.insert(newIndex, row2);
    });
    await updateIndex(min(oldIndex, newIndex));
  }

  //update Index
  Future updateIndex(int minIndex) async {
    for (int i = minIndex; i < playlist.length; i++) {
      playlist[i].index = i;
      await DBManager.playlistBody.updateRec(playlist[i]);
    }
  }

  //show option to rename or delete
  Future<void> _showOption(PlayListBody body) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                onTap: () async {
                  await DBManager.playlistBody
                      .delete(body.headerId, body.songId);
                  Get.back();
                  refresh();
                },
                title: Text('Delete'.tr),
              )
            ],
          ),
        );
      },
    );
  }
}
