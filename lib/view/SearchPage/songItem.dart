import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/model/song.dart';
import 'package:itunes_music/viewModel/viewModeCtr.dart';
import 'package:itunes_music/view/SongPage/songPage.dart';

///song Item widget show in resultView
class SongItem extends StatelessWidget {
  final Song song;
  const SongItem({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    var mode = Get.find<ViewModeCtr>().viewMode;
    return GestureDetector(
        onTap: () => Get.to(SongPage(
              song: song,
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
        imageUrl: song.artworkUrl60.toString(),
        fadeInDuration: const Duration(milliseconds: 80),
        progressIndicatorBuilder: (context, url, progress) {
          return Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(10),
            child: CircularProgressIndicator(
                value: progress.progress != null
                    ? progress.progress! / 1.0
                    : null),
          );
        },
        fit: BoxFit.contain,
        errorWidget: (context, url, error) => Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.error),
        ),
      ),
    );
  }

  //show artist and song name
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
              song.trackName.toString(),
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
            Text(
              song.artistName.toString(),
              maxLines: 1,
              overflow: TextOverflow.fade,
            )
          ],
        ),
      ),
    ));
  }
}
