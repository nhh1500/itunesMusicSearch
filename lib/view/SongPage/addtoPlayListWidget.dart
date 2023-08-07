import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/services/DB/dbManager.dart';
import '../../model/playListHeader.dart';
import 'addtoPlayListItem.dart';

/// playList widget allow user to add song to playList
class AddToPlayListWidget extends StatefulWidget {
  final int songId;
  const AddToPlayListWidget({super.key, required this.songId});

  @override
  State<AddToPlayListWidget> createState() => _AddToPlayListWidgetState();
}

class _AddToPlayListWidgetState extends State<AddToPlayListWidget> {
  Future? init;
  List<PlayListHeader> playlists = [];

  Future refresh() async {
    //read all playList from database and refresh widget
    playlists = await DBManager.playlistHeader.readAll();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init = refresh();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
            child: playlists.isEmpty ? const Text('No List') : listPlaylist(),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  //show all playLists
  Widget listPlaylist() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(playlists.length, (index) {
          return AddToPlayListItem(
            listName: playlists[index].listName.toString(),
            headerId: playlists[index].id!,
            songId: widget.songId,
            refresh: refresh,
          );
        }));
  }
}
