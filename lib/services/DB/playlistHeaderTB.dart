import 'package:itunes_music/services/DB/playlistBodyTB.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/dbType.dart';
import '../../model/playListHeader.dart';

class PlaylistHeaderTB {
  Database? _database;
  final tableName = 'playListHeader';

  PlaylistHeaderTB(this._database);

  Future createTB(Database db) async {
    await db.execute('''
CREATE TABLE $tableName (
  ${PlayListHeaderFields.id} ${DBType.id},
  ${PlayListHeaderFields.listName} ${DBType.string}
)
''');
  }

  ///create record
  Future<void> create(PlayListHeader header) async {
    await _database!.insert(tableName, header.toJson());
  }

  ///read all record
  Future<List<PlayListHeader>> readAll() async {
    final result = await _database!.query(tableName);
    var list = result.map((e) => PlayListHeader.fromJson(e)).toList();
    return list;
  }

  ///update record
  Future<void> updateRec(PlayListHeader header) async {
    await _database!.update(tableName, header.toJson(),
        where: '${PlayListHeaderFields.id} = ?', whereArgs: [header.id]);
  }

  ///delete record
  Future<void> delete(PlayListHeader header) async {
    var pb = PlaylistBodyTB(_database!);
    await pb.deleteAll(header.id!);
    await _database!.delete(tableName,
        where: '${PlayListHeaderFields.id} = ?', whereArgs: [header.id]);
  }
}
