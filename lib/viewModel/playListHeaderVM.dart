import 'package:get/get.dart';
import 'package:itunes_music/model/dbType.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:itunes_music/model/playListHeader.dart';

class PlayListHeaderVM extends GetxController {
  final tableName = 'playListHeader';
  List<PlayListHeader> _playListHeader = [];
  List<PlayListHeader> get playLisyHeader => _playListHeader;
  Database? _database;

  Future init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, tableName);
    _database = await openDatabase(path, version: 1, onCreate: _createTB);
  }

  Future _createTB(Database db, int version) async {
    await db.execute('''
CREATE TABLE $tableName (
  ${PlayListHeaderFields.id} ${DBType.id},
  ${PlayListHeaderFields.listName} ${DBType.string}
)
''');
  }

  Future<void> create(PlayListHeader header) async {
    await _database!.insert(tableName, header.toJson());
  }

  Future<List<PlayListHeader>> readAll() async {
    final result = await _database!.query(tableName);
    var list = result.map((e) => PlayListHeader.fromJson(e)).toList();
    return list;
  }

  Future<void> updateRec(PlayListHeader header) async {
    await _database!.update(tableName, header.toJson(),
        where: '${PlayListHeaderFields.id} = ?', whereArgs: [header.id]);
  }

  Future<void> delete(PlayListHeader header) async {
    await _database!.delete(tableName,
        where: '${PlayListHeaderFields.id} = "?', whereArgs: [header.id]);
  }

  Future close() async {
    return await _database!.close();
  }
}
