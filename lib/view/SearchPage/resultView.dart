import 'package:flutter/material.dart';
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
class ResultView extends StatelessWidget {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchResultCtr>(
      builder: (controller) {
        if (controller.result.isEmpty) {
          return Center(
            child: Text('No items match your search'.tr),
          );
        }
        var modeCtr = Get.find<ViewModeCtr>();
        return modeCtr.viewMode == ViewMode.list
            ? listviewMode(controller.result)
            : gridviewMode(controller.result);
      },
    );
  }

  Widget listviewMode(List<MediaObject> results) {
    return ListView.builder(
      cacheExtent: 15,
      itemCount: results.length,
      itemBuilder: (context, index) {
        var mediaObject = results[index];
        //animation when switch to gridview or listview
        if (results.first is Artist) {
          return returnItem(mediaObject);
        } else {
          return Hero(
              tag: index,
              createRectTween: (begin, end) =>
                  CustomTransitions(a: begin!, b: end!),
              child: Material(
                type: MaterialType.transparency,
                child: returnItem(mediaObject),
              ));
        }
      },
    );
  }

  Widget gridviewMode(List<MediaObject> results) {
    return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: results.first is Artist ? 1.1 : 1.3,
        children: List.generate(results.length, (index) {
          var mediaObject = results[index];
          //animation when switch to gridview or listview
          if (results.first is Artist) {
            return returnItem(mediaObject);
          } else {
            return Hero(
                tag: index,
                createRectTween: (begin, end) =>
                    CustomTransitions(a: begin!, b: end!),
                child: Material(
                  type: MaterialType.transparency,
                  child: returnItem(mediaObject),
                ));
          }
        }));
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
