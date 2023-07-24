import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:itunes_music/model/MediaObject.dart';
import 'package:itunes_music/model/album.dart';
import 'package:itunes_music/model/artist.dart';
import 'package:itunes_music/viewModel/searchModeCtr.dart';
import 'package:itunes_music/viewModel/searchResultCtr.dart';
import 'package:itunes_music/model/song.dart';
import 'package:itunes_music/services/ApiController.dart';
import 'package:itunes_music/viewModel/userConfig.dart';

///search bar in searchPage
class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final TextEditingController _controler = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controler,
      onSubmitted: (value) async {
        var response;
        //show loading widget during api call
        EasyLoading.show(status: 'Loading');
        var vm = Get.find<UserConfig>();
        //call api to search either song, artist, or album
        switch (Get.find<SearchModelCtr>().mode) {
          case 'Song':
            response = await ApiController.itunesMusicApi.search(
              value,
              country: vm.searchCountry,
              lang: vm.searchLang,
            );
            break;
          case 'Artist':
            response = await ApiController.itunesMusicApi.search(value,
                entity: 'allArtist',
                attribute: 'allArtistTerm',
                country: vm.searchCountry,
                lang: vm.searchLang);
            break;
          case 'Album':
            response = await ApiController.itunesMusicApi.search(value,
                entity: 'album',
                country: vm.searchCountry,
                lang: vm.searchLang);
            break;
          default:
            break;
        }
        //dimiss loading widget when api return
        EasyLoading.dismiss();
        //extract json Data
        updateResultView(response);
      },
      decoration: InputDecoration(
          hintText: 'Search'.tr,
          contentPadding: const EdgeInsets.all(0),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
              onPressed: () {
                _controler.clear();
              },
              icon: const Icon(Icons.clear))),
    );
  }

  ///extract json data
  void updateResultView(dynamic response) {
    try {
      Map json = jsonDecode(response.toString().trim());
      List results = json['results'];
      var getxCtr = Get.find<SearchResultCtr>();
      List<MediaObject> ctrList = getxCtr.result;
      ctrList.clear();
      for (var itm in results) {
        switch (itm['wrapperType'].toString().toLowerCase()) {
          case 'track':
            ctrList.add(Song.fromJson(itm));
            break;
          case 'collection':
            ctrList.add(Album.fromJson(itm));
            break;
          case 'artist':
            ctrList.add(Artist.fromJson(itm));
            break;
        }
      }
      // notify widget that is using SearchResultCtr GetBuilder to refresh
      getxCtr.update();
    } catch (e) {
      print(e.toString());
    }
  }
}
