import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/model/playListHeader.dart';
import 'package:itunes_music/view/playList/playListDetail.dart';
import 'package:itunes_music/viewModel/playListHeaderVM.dart';

import '../../viewModel/playlistbdyVM.dart';

class PlayListPage extends StatefulWidget {
  const PlayListPage({super.key});

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  //playlist view model
  PlayListHeaderVM vm = Get.find<PlayListHeaderVM>();
  //all playlists
  List playlist = [];
  Future? future;
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  void initState() {
    super.initState();
    future = refresh();
  }

  //read all playlists in database and refresh
  Future refresh() async {
    playlist = await vm.readAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            //add new playlist
            IconButton(onPressed: _showMyDialog, icon: const Icon(Icons.add))
          ],
        ),
        body: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return body();
              } else {
                return const SizedBox();
              }
            }));
  }

  Widget body() {
    if (playlist.isNotEmpty) {
      return SingleChildScrollView(
          child: Column(
        children: List.generate(
          playlist.length,
          (index) => listItem(playlist[index]),
        ),
      ));
    } else {
      return emptyPlayList();
    }
  }

  //show playlist name
  Widget listItem(PlayListHeader header) {
    return ListTile(
      onTap: () async {
        var vm = Get.find<PlayListbdyVM>();
        await vm.readPlayListDetail(header.id!);
        Get.to(PlayListDetailPage(
          listName: header.listName.toString(),
          playListHeaderId: header.id ?? 0,
        ));
      },
      title: Text(header.listName.toString()),
    );
  }

  //empty playlists
  Widget emptyPlayList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Playlist'.tr,
            style: TextStyle(fontSize: 32),
          ),
          ElevatedButton(
              onPressed: _showMyDialog,
              child: Text(
                'Create Playlist'.tr,
                style: TextStyle(fontSize: 28),
              ))
        ],
      ),
    );
  }

  //dialog to create new playlist
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        textController.clear();
        return AlertDialog(
          title: Text('Create Playlist'.tr),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Playlist Name'.tr),
                TextField(
                  controller: textController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Create'.tr),
              onPressed: () async {
                if (textController.text == '') return;
                //add playlist name to database
                var plh = PlayListHeader(listName: textController.text);
                await vm.create(plh);
                await refresh();
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
