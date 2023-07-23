import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/model/playListBody.dart';
import 'package:itunes_music/viewModel/playlistbdyVM.dart';

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
  List<PlayListBody> list = [];
  var plbdyvm = Get.find<PlayListbdyVM>();

  @override
  void initState() {
    super.initState();
    init = localRefresh();
  }

  Future localRefresh() async {
    list = await plbdyvm.readSong(widget.headerId, widget.songId);
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

  void onChange(bool? check) async {
    if (check!) {
      await createRecord();
      await localRefresh();
    } else {
      await deleteRecord();
      await localRefresh();
    }
  }

  Future createRecord() async {
    int availableIndex = await findAvailableIndex();
    await plbdyvm.create(PlayListBody(
        headerId: widget.headerId,
        index: availableIndex,
        songId: widget.songId));
  }

  Future deleteRecord() async {
    return await plbdyvm.delete(widget.headerId, widget.songId);
  }

  Future<int> findAvailableIndex() async {
    int availableIndex = 0;

    List<PlayListBody> playlistDetail =
        await plbdyvm.readPlayListDetail(widget.headerId);
    for (var rec in playlistDetail) {
      if (rec.index > availableIndex) {
        availableIndex = rec.index;
      }
    }
    availableIndex++;
    return availableIndex;
  }
}
