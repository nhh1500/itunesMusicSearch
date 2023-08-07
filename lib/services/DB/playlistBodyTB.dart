import 'package:sqflite/sqflite.dart';

import '../../model/dbType.dart';
import '../../model/playListBody.dart';

class PlaylistBodyTB {
  final Database _database;
  final tableName = 'playListBody';

  PlaylistBodyTB(this._database);

  Future createTB(Database db) async {
    await db.execute('''
CREATE TABLE $tableName (
  ${PlayListBodyFields.id} ${DBType.id},
  ${PlayListBodyFields.headerId} ${DBType.int},
  ${PlayListBodyFields.index} ${DBType.int},
  ${PlayListBodyFields.songId} ${DBType.int}
)
''');
  }

  ///create record
  Future<void> create(PlayListBody body) async {
    await _database.insert(tableName, body.toJson());
  }

  Future<List<PlayListBody>> read(int headerId, {int? songId}) async {
    String where = songId != null
        ? '${PlayListBodyFields.headerId} = ? And ${PlayListBodyFields.songId} = ?'
        : '${PlayListBodyFields.headerId} = ?';
    List<Object> whereArgs = songId != null ? [headerId, songId] : [headerId];
    var queryResults = await _database.query(tableName,
        columns: PlayListBodyFields.values,
        where: where,
        whereArgs: whereArgs,
        orderBy: PlayListBodyFields.index);

    List<PlayListBody> listBdy = [];
    for (var item in queryResults) {
      listBdy.add(PlayListBody.fromJson(item));
    }
    return listBdy;
  }

  ///update record
  Future<void> updateRec(PlayListBody body) async {
    await _database.update(tableName, body.toJson(),
        where: '${PlayListBodyFields.id} = ?', whereArgs: [body.id]);
  }

  ///delete record
  Future<void> delete(int headerId, int songId) async {
    await _database.delete(tableName,
        where:
            '${PlayListBodyFields.headerId} = ? And ${PlayListBodyFields.songId} = ?',
        whereArgs: [headerId, songId]);
  }

  //delete all songs in playlist
  Future<void> deleteAll(int headerId) async {
    await _database.delete(tableName,
        where: '${PlayListBodyFields.headerId} = ?', whereArgs: [headerId]);
  }
}
