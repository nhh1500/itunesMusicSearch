import 'MediaObject.dart';

/// information about a particular song, including the artist who created it and the album on which it appeared.
class Song extends MediaObject {
  ///The kind of content returned by the search request.
  String? kind;

  int? artistId;
  int? collectionId;
  int? trackId;

  ///The name of the artist returned by the search request.
  String? artistName;

  ///	The name of the album, TV season, audiobook, and so on returned by the search request.
  String? collectionName;

  ///The name of the track, song, video, TV episode, and so on returned by the search request.
  String? trackName;
  String? collectionCensoredName;
  String? trackCensoredName;
  String? artistViewUrl;
  String? collectionViewUrl;
  String? trackViewUrl;

  ///A URL referencing the 30-second preview file for the content associated with the returned media type.
  String? previewUrl;

  ///A URL for the artwork associated with the returned media type, sized to 100×100 pixels or 60×60 pixels.
  String? artworkUrl30;

  ///A URL for the artwork associated with the returned media type, sized to 100×100 pixels or 60×60 pixels.
  String? artworkUrl60;

  ///A URL for the artwork associated with the returned media type, sized to 100×100 pixels or 60×60 pixels.
  String? artworkUrl100;
  double? collectionPrice;
  double? trackPrice;
  DateTime? releaseDate;
  String? collectionExplicitness;
  String? trackExplicitness;
  int? discCount;
  int? discNumber;
  int? trackCount;
  int? trackNumber;

  ///The returned track’s time in milliseconds.
  int? trackTimeMillis;
  String? country;
  String? currency;
  String? primaryGenreName;
  bool? isStreamable;

  Song.fromJson(Map<String, dynamic> json) {
    wrapperType = json['wrapperType'];
    kind = json['kind'];
    artistId = json['artistId'];
    collectionId = json['collectionId'];
    trackId = json['trackId'];
    artistName = json['artistName'];
    collectionName = json['collectionName'];
    trackName = json['trackName'];
    collectionCensoredName = json['collectionCensoredName'];
    trackCensoredName = json['trackCensoredName'];
    artistViewUrl = json['artistViewUrl'];
    collectionViewUrl = json['collectionViewUrl'];
    trackViewUrl = json['trackViewUrl'];
    previewUrl = json['previewUrl'];
    artworkUrl30 = json['artworkUrl30'];
    artworkUrl60 = json['artworkUrl60'];
    artworkUrl100 = json['artworkUrl100'];
    collectionPrice = json['collectionPrice'];
    trackPrice = json['trackPrice'];
    releaseDate = DateTime.tryParse(json['releaseDate']);
    collectionExplicitness = json['collectionExplicitness'];
    trackExplicitness = json['trackExplicitness'];
    discCount = json['discCount'];
    discNumber = json['discNumber'];
    trackCount = json['trackCount'];
    trackNumber = json['trackNumber'];
    trackTimeMillis = json['trackTimeMillis'];
    country = json['country'];
    currency = json['currency'];
    primaryGenreName = json['primaryGenreName'];
    isStreamable = json['isStreamable'];
  }
}
