import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/view/AlbumPage/albumPage.dart';

import '../../model/album.dart';
import '../../viewModel/viewModeCtr.dart';

//album Item
class AlbumItem extends StatefulWidget {
  final Album album;
  const AlbumItem({super.key, required this.album});

  @override
  State<AlbumItem> createState() => _AlbumItemState();
}

class _AlbumItemState extends State<AlbumItem> {
  var mode = Get.find<ViewModeCtr>().viewMode;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Get.to(AlbumPage(
              album: widget.album,
            )),
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[300]),
            child: mode == ViewMode.list
                ? Row(
                    children: [imageWidget(), mediaInfo(mode)],
                  )
                : Column(
                    children: [imageWidget(), mediaInfo(mode)],
                  )));
  }

  //show image
  Widget imageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: widget.album.artworkUrl60.toString(),
        fadeInDuration: const Duration(milliseconds: 80),
        fit: BoxFit.contain,
        errorWidget: (context, url, error) {
          return Container(
            width: 60,
            height: 60,
            padding: EdgeInsets.all(10),
            child: Icon(Icons.error),
          );
        },
        progressIndicatorBuilder: (context, url, progress) {
          return Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(10),
            child: CircularProgressIndicator(
              value:
                  progress.progress != null ? progress.progress! / 1.0 : null,
            ),
          );
        },
      ),
    );
  }

  //show album and artist name
  Widget mediaInfo(ViewMode mode) {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: mode == ViewMode.list
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Text(
              widget.album.collectionName.toString(),
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
            Text(
              widget.album.artistName.toString(),
              maxLines: 1,
              overflow: TextOverflow.fade,
            )
          ],
        ),
      ),
    ));
  }
}
