import 'package:get/get.dart';
import 'package:itunes_music/model/dbType.dart';
import 'package:itunes_music/model/playListBody.dart';
import 'package:itunes_music/viewModel/playlistbdyVM.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:itunes_music/model/playListHeader.dart';

///  to control playListheader database
class PlayListHeaderVM extends GetxController {
  final tableName = 'playListHeader';
  List<PlayListHeader> _playListHeader = [];
  List<PlayListHeader> get playLisyHeader => _playListHeader;
  Database? _database;

  ///init database
  Future init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, tableName);
    _database = await openDatabase(path, version: 1, onCreate: _createTB);
  }

  ///create dataTable if table is not exist, otherwise do nothing
  Future _createTB(Database db, int version) async {
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
    await Get.find<PlayListbdyVM>().deleteAll(header.id!);
    await _database!.delete(tableName,
        where: '${PlayListHeaderFields.id} = ?', whereArgs: [header.id]);
  }

  /// close database
  Future close() async {
    return await _database!.close();
  }
}
