import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/services/ApiController.dart';
import 'package:itunes_music/view/SongPage/songPage.dart';
import 'package:itunes_music/view/AlbumPage/albumPage.dart';
import 'package:itunes_music/viewModel/userConfig.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../model/album.dart';
import '../../model/artist.dart';
import '../../model/song.dart';

///artist Page
class ArtistPage extends StatefulWidget {
  final Artist artist;
  const ArtistPage({super.key, required this.artist});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  Future? albumFuture;
  Future? songFuture;

  ///hold all songs for the artist
  List<Song> songs = [];

  ///hold all albums for the artist
  List<Album> albums = [];

  @override
  void initState() {
    super.initState();
    albumFuture = getAlbum();
    songFuture = getSong();
  }

  ///fetch all albums for the artist
  Future getAlbum() async {
    albums.clear();
    var vm = Get.find<UserConfig>();
    var response = await ApiController.itunesMusicApi.lookup(
        widget.artist.artistId!,
        entity: 'album',
        country: vm.searchCountry,
        lang: vm.searchLang);
    Map json = jsonDecode(response.toString().trim());
    List results = json['results'];
    for (var itm in results) {
      if (itm['wrapperType'].toString().toLowerCase() == 'collection') {
        albums.add(Album.fromJson(itm));
      }
    }
  }

  /// fetch all songs for the artist
  Future getSong() async {
    songs.clear();
    var vm = Get.find<UserConfig>();
    var response = await ApiController.itunesMusicApi.lookup(
        widget.artist.artistId!,
        entity: 'song',
        country: vm.searchCountry,
        lang: vm.searchLang);
    Map json = jsonDecode(response.toString().trim());
    List results = json['results'];
    for (var itm in results) {
      if (itm['wrapperType'].toString().toLowerCase() == 'track') {
        songs.add(Song.fromJson(itm));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //auto scroll if artist Name too long
          title: TextScroll(
            widget.artist.artistName.toString(),
            intervalSpaces: 5,
            delayBefore: const Duration(seconds: 2),
            pauseBetween: const Duration(seconds: 2),
            fadedBorder: true,
            fadeBorderSide: FadeBorderSide.right,
            fadeBorderVisibility: FadeBorderVisibility.auto,
            velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: widget.artist.artworkUrl300.toString(),
                  fadeInDuration: const Duration(milliseconds: 80),
                  width: 300,
                  height: 300,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///artist NAme
                    TextScroll(
                      widget.artist.artistName.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                      intervalSpaces: 10,
                      delayBefore: Duration(seconds: 2),
                      pauseBetween: Duration(seconds: 2),
                      fadedBorder: true,
                      fadeBorderSide: FadeBorderSide.both,
                      fadeBorderVisibility: FadeBorderVisibility.auto,
                      velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                    ),
                    Text(
                      widget.artist.primaryGenreName.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              customDivider(),
              albumSection(),
              customDivider(),
              songSection()
            ],
          ),
        ));
  }

  ///song section to show all songs for the artist
  Widget songSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'Songs',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        FutureBuilder(
          future: songFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    songs.length,
                    (index) => GestureDetector(
                          onTap: () {
                            Get.to(SongPage(song: songs[index]));
                          },
                          child: Container(
                            color:
                                index % 2 == 1 ? Colors.grey[50] : Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      songs[index].artworkUrl60.toString(),
                                  fadeInDuration:
                                      const Duration(milliseconds: 80),
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: Text(
                                  songs[index].trackName.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(msToMMSS(songs[index].trackTimeMillis!)),
                              ],
                            ),
                          ),
                        )),
              );
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }

  ///show all albums for the artist
  Widget albumSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'Albums',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FutureBuilder(
            future: albumFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      albums.length,
                      (index) => GestureDetector(
                            onTap: () {
                              Get.to(AlbumPage(album: albums[index]));
                            },
                            child: Container(
                              width: 150,
                              margin: const EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: albums[index]
                                        .artworkUrl100
                                        .toString()
                                        .replaceAll(
                                            RegExp('100x100'), '300x300'),
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                    fadeInDuration:
                                        const Duration(milliseconds: 80),
                                  ),
                                  Text(
                                    albums[index].collectionName.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),
                          )),
                );
              } else {
                return Container();
              }
            },
          ),
        )
      ],
    );
  }

  ///divider
  Widget customDivider() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 2,
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.white, Colors.black],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            children: const [
              Icon(
                Icons.star,
                size: 10,
              ),
              Icon(
                Icons.star,
                size: 20,
              ),
              Icon(
                Icons.star,
                size: 10,
              ),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 2,
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.white, Colors.black],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft)),
            ),
          ),
        ),
      ],
    );
  }

  //ms to time format MM:SS
  String msToMMSS(int ms) {
    Duration duration = Duration(milliseconds: ms);
    final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}
