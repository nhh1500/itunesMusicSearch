import 'MediaObject.dart';

///model for Artist
/// fields refer to itunes music api
/// hold information about an artist, including the content they created and references to them in playlists and radio stations.
class Artist extends MediaObject {
  String? artistType;
  String? artistName;
  String? artistLinkUrl;
  String? artworkUrl300;
  int? artistId;
  String? primaryGenreName;
  int? primaryGenreId;

  Artist.fromJson(Map<String, dynamic> json) {
    wrapperType = json['wrapperType'];
    artistType = json['artistType'];
    artistName = json['artistName'];
    artistLinkUrl = json['artistLinkUrl'];
    artistId = json['artistId'];
    primaryGenreName = json['primaryGenreName'];
    primaryGenreId = json['primaryGenreId'];
  }
}
