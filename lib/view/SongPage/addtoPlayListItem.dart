import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/model/playListBody.dart';
import 'package:itunes_music/services/DB/dbManager.dart';

///single playList allow user to select and diselect song from playList
class AddToPlayListItem extends StatefulWidget {
  final Function() refresh;
  final String listName;
  final int headerId;
  final int songId;
  const AddToPlayListItem(
      {super.key,
      required this.headerId,
      required this.songId,
      required this.refresh,
      required this.listName});

  @override
  State<AddToPlayListItem> createState() => _AddToPlayListItemState();
}

class _AddToPlayListItemState extends State<AddToPlayListItem> {
  Future? init;

  /// hold all songs in the playList
  List<PlayListBody> list = [];

  @override
  void initState() {
    super.initState();
    init = localRefresh();
  }

  Future localRefresh() async {
    list = await DBManager.playlistBody
        .read(songId: widget.songId, widget.headerId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Row(
            children: [
              Text(
                widget.listName,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Checkbox(value: list.isNotEmpty, onChanged: onChange)
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  ///checkbox event
  void onChange(bool? check) async {
    if (check!) {
      await createRecord();
      await localRefresh();
    } else {
      await deleteRecord();
      await localRefresh();
    }
  }

  ///create record if user select this song
  Future createRecord() async {
    int availableIndex = await findAvailableIndex();
    await DBManager.playlistBody.create(PlayListBody(
        headerId: widget.headerId,
        index: availableIndex,
        songId: widget.songId));
  }

  ///delete record if user diselected this song from playList
  Future deleteRecord() async {
    return await DBManager.playlistBody.delete(widget.headerId, widget.songId);
  }

  ///find available Index in database
  Future<int> findAvailableIndex() async {
    int availableIndex = 0;
    List<PlayListBody> playlistDetail =
        await DBManager.playlistBody.read(widget.headerId);
    for (var rec in playlistDetail) {
      if (rec.index > availableIndex) {
        availableIndex = rec.index;
      }
    }
    availableIndex++;
    return availableIndex;
  }
}
