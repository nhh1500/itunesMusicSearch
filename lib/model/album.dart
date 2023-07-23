import 'MediaObject.dart';

/// model for album
/// fields refer to itunes music api
/// hold an album’s name, artist, list of tracks, artwork, release date, and recording information, etc...
class Album extends MediaObject {
  String? collectionType;
  int? artistId;
  int? collectionId;
  String? artistName;
  String? collectionName;
  String? collectionCensoredName;
  String? artistViewUrl;
  String? collectionViewUrl;
  String? artworkUrl60;
  String? artworkUrl100;
  double? collectionPrice;
  String? collectionExplicitness;
  int? trackCount;
  String? copyright;
  String? country;
  String? currency;
  DateTime? releaseDate;
  String? primaryGenreName;

  Album.fromJson(Map<String, dynamic> json) {
    wrapperType = json['wrapperType'];
    collectionType = json['collectionType'];
    artistId = json['artistId'];
    collectionId = json['collectionId'];
    artistName = json['artistName'];
    collectionName = json['collectionName'];
    collectionCensoredName = json['collectionCensoredName'];
    artistViewUrl = json['artistViewUrl'];
    collectionViewUrl = json['collectionViewUrl'];
    artworkUrl60 = json['artworkUrl60'];
    artworkUrl100 = json['artworkUrl100'];
    collectionPrice = json['collectionPrice'];
    collectionExplicitness = json['collectionExplicitness'];
    trackCount = json['trackCount'];
    copyright = json['copyright'];
    country = json['country'];
    currency = json['currency'];
    releaseDate = DateTime.tryParse(json['releaseDate']);
    primaryGenreName = json['primaryGenreName'];
  }
}
