import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/model/artist.dart';
import 'package:itunes_music/view/ArtistPage/artistPage.dart';

import '../../services/apihandler.dart';
import '../../viewModel/viewModeCtr.dart';

class ArtistItem extends StatefulWidget {
  final Artist artist;
  const ArtistItem({super.key, required this.artist});

  @override
  State<ArtistItem> createState() => _ArtistItemState();
}

class _ArtistItemState extends State<ArtistItem> {
  Future<bool>? future;
  var mode = Get.find<ViewModeCtr>().viewMode;

  @override
  void initState() {
    super.initState();
    future = getArtistDetail();
  }

  //fetch artist info
  Future<bool> getArtistDetail() async {
    //extract artist image URL from HTML page
    var response = await ApiHandler.getAPI(
        'https://music.apple.com/de/artist/${widget.artist.artistId.toString()}');
    RegExp regEx = RegExp("<meta property=\"og:image\" content=\"(.*png)\"");
    RegExpMatch? match = regEx.firstMatch(response);
    if (match != null) {
      String rawImageUrl = match.group(1) ?? '';
      //convert size 100x100 image to 300x300
      String imageUrl = rawImageUrl.replaceAll(
          RegExp(r'[\d]+x[\d]+(cw)+'), '${300}x${300}cc');
      widget.artist.artworkUrl300 = imageUrl;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Get.to(ArtistPage(
              artist: widget.artist,
            )),
        child: mode == ViewMode.list
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[300]),
                child: Row(
                  children: [imageWidget(), mediaInfo(mode)],
                ))
            : Container(
                child: Column(
                  children: [gridImage(), mediaInfo(mode)],
                ),
              ));
  }

  //show artist image in gridview mode
  Widget gridImage() {
    return ClipOval(
      child: LayoutBuilder(
        builder: (p0, p1) => FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CachedNetworkImage(
                imageUrl: widget.artist.artworkUrl300.toString(),
                fadeInDuration: const Duration(milliseconds: 80),
                width: p1.maxWidth / 2,
                height: p1.maxWidth / 2,
              );
            } else {
              return SizedBox(
                height: p1.maxWidth / 2,
                width: p1.maxWidth / 2,
                child: const CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  //show artist image in listview mode
  Widget imageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CachedNetworkImage(
              imageUrl: widget.artist.artworkUrl300.toString(),
              fadeInDuration: const Duration(milliseconds: 80),
              height: 60,
              width: 60,
              fit: BoxFit.contain,
              errorWidget: (context, url, error) {
                return Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.error),
                );
              },
              progressIndicatorBuilder: (context, url, progress) {
                return Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                    value: progress.progress != null
                        ? progress.progress! / 1.0
                        : null,
                  ),
                );
              },
            );
          } else {
            return Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  //show artist name and artistType
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
              widget.artist.artistName.toString(),
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
            Text(
              '${widget.artist.artistType.toString()} - ${widget.artist.primaryGenreName}',
              maxLines: 1,
              overflow: TextOverflow.fade,
            )
          ],
        ),
      ),
    ));
  }
}
