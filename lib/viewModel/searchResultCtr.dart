import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/viewModel/searchModeCtr.dart';
import 'package:itunes_music/viewModel/userConfig.dart';

import '../model/MediaObject.dart';
import '../model/album.dart';
import '../model/artist.dart';
import '../model/song.dart';
import '../services/Api/ApiController.dart';

///search results view model
///once API complete it will notify resultPage Widget to update
class SearchResultCtr extends GetxController {
  final TextEditingController _controller = TextEditingController();
  final List<MediaObject> _result = [];

  TextEditingController get controller => _controller;
  List<MediaObject> get result => _result;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void notify() {
    update();
  }

  Future search(String text) async {
    var userConfig = Get.find<UserConfig>();
    var searchMode = Get.find<SearchModelCtr>().mode;
    var response;
    //call api to search either song, artist, or album
    switch (searchMode) {
      case 'Song':
        response = await ApiController.itunesMusicApi.search(
          entity: 'song',
          text,
          country: userConfig.searchCountry,
          lang: userConfig.searchLang,
        );
        break;
      case 'Artist':
        response = await ApiController.itunesMusicApi.search(text,
            entity: 'allArtist',
            attribute: 'allArtistTerm',
            country: userConfig.searchCountry,
            lang: userConfig.searchLang);
        break;
      case 'Album':
        response = await ApiController.itunesMusicApi.search(text,
            entity: 'album',
            country: userConfig.searchCountry,
            lang: userConfig.searchLang);
        break;
      default:
        break;
    }
    await extractJson(response);
    //fetch artist image Url
    if (searchMode == 'Artist') {
      await Future.wait(List.generate(_result.length, (index) {
        Artist artist = _result[index] as Artist;
        return ApiController.itunesMusicApi
            .getArtistImageUrl(artist.artistId!)
            .then((value) => artist.artworkUrl300 = value);
      }));
    }
    // notify widget that is using SearchResultCtr GetBuilder to refresh
    update();
  }

  ///extract json data
  Future extractJson(dynamic response) async {
    try {
      Map json = jsonDecode(response.toString().trim());
      List results = json['results'];
      _result.clear();
      for (var itm in results) {
        switch (itm['wrapperType'].toString().toLowerCase()) {
          case 'track':
            _result.add(Song.fromJson(itm));
            break;
          case 'collection':
            _result.add(Album.fromJson(itm));
            break;
          case 'artist':
            _result.add(Artist.fromJson(itm));
            break;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
