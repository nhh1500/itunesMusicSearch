///model for playList Item
class PlayListBody {
  int? id;
  int headerId;
  int index;
  int songId;
  PlayListBody(
      {this.id,
      required this.headerId,
      required this.index,
      required this.songId});

  static PlayListBody fromJson(Map<String, dynamic> json) {
    return PlayListBody(
        id: json[PlayListBodyFields.id],
        headerId: json[PlayListBodyFields.headerId],
        index: json[PlayListBodyFields.index],
        songId: json[PlayListBodyFields.songId]);
  }

  Map<String, dynamic> toJson() {
    return {
      PlayListBodyFields.id: id,
      PlayListBodyFields.headerId: headerId,
      PlayListBodyFields.index: index,
      PlayListBodyFields.songId: songId
    };
  }
}

class PlayListBodyFields {
  static final List<String> values = [id, headerId, index, songId];
  static const id = '_id';
  static const headerId = 'headerId';
  static const index = 'listIndex';
  static const songId = 'songId';
}
