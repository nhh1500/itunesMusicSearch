import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:itunes_music/model/MediaObject.dart';
import 'package:itunes_music/model/album.dart';
import 'package:itunes_music/model/artist.dart';
import 'package:itunes_music/viewModel/searchResultCtr.dart';
import 'package:itunes_music/viewModel/viewModeCtr.dart';
import 'package:itunes_music/view/SearchPage/albumItem.dart';
import 'package:itunes_music/view/SearchPage/artistItem.dart';
import 'package:itunes_music/view/SearchPage/songItem.dart';

import '../../model/song.dart';
import '../../utility/customTransition.dart';

//resultview shows all results from itunes music api
class ResultView extends StatefulWidget {
  const ResultView({super.key});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchResultCtr>(
      builder: (controller) {
        var modeCtr = Get.find<ViewModeCtr>();
        if (controller.result.isEmpty) {
          return Center(
            child: Text('No items match your search'.tr),
          );
        }
        return modeCtr.viewMode == ViewMode.list
            ? ListView.builder(
                cacheExtent: 15,
                itemCount: controller.result.length,
                itemBuilder: (context, index) {
                  var mediaObject = controller.result[index];
                  //animation when switch to gridview or listview
                  return Hero(
                      tag: index,
                      createRectTween: (Rect? begin, Rect? end) {
                        return CustomTransitions(a: begin!, b: end!);
                      },
                      child: Material(
                        type: MaterialType.transparency,
                        child: returnItem(mediaObject),
                      ));
                },
              )
            : GridView.count(
                crossAxisCount: 2,
                childAspectRatio: modeCtr.viewMode == ViewMode.grid ? 1.1 : 1.3,
                children: List.generate(controller.result.length, (index) {
                  var mediaObject = controller.result[index];
                  //animation when switch to gridview or listview
                  return Hero(
                      tag: index,
                      createRectTween: (Rect? begin, Rect? end) {
                        return CustomTransitions(a: begin!, b: end!);
                      },
                      child: Material(
                        type: MaterialType.transparency,
                        child: returnItem(mediaObject),
                      ));
                }));
      },
    );
  }

  ///show item based on wrapperType
  Widget returnItem(MediaObject mediaObject) {
    if (mediaObject is Song) {
      return SongItem(
        song: mediaObject,
      );
    } else if (mediaObject is Album) {
      return AlbumItem(
        album: mediaObject,
      );
    } else if (mediaObject is Artist) {
      return ArtistItem(
        artist: mediaObject,
      );
    } else {
      return const SizedBox();
    }
  }
}
