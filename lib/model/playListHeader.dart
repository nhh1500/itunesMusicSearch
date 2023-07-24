///model for playList
class PlayListHeader {
  int? id;
  String? listName;

  PlayListHeader({this.id, required this.listName});

  static PlayListHeader fromJson(Map<String, dynamic> json) {
    return PlayListHeader(
        id: json[PlayListHeaderFields.id],
        listName: json[PlayListHeaderFields.listName]);
  }

  Map<String, dynamic> toJson() {
    return {
      PlayListHeaderFields.id: id,
      PlayListHeaderFields.listName: listName
    };
  }
}

class PlayListHeaderFields {
  static const id = '_id';
  static const listName = 'listName';
}
