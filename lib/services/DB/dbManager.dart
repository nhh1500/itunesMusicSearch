import 'package:itunes_music/services/DB/playlistHeaderTB.dart';
import 'package:itunes_music/services/DB/playlistBodyTB.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBManager {
  static Database? _database;
  static late PlaylistHeaderTB playlistHeader;
  static late PlaylistBodyTB playlistBody;

  ///init database
  static Future init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'itunesMusicSearch.db');
    _database = await openDatabase(path,
        version: 1, onCreate: _createDB, onConfigure: _configure);
  }

  static _configure(Database db) {
    playlistHeader = PlaylistHeaderTB(db);
    playlistBody = PlaylistBodyTB(db);
  }

  ///create dataTable if table is not exist, otherwise do nothing
  static Future _createDB(Database db, int version) async {
    await playlistHeader.createTB(db);
    await playlistBody.createTB(db);
  }

  /// close database
  static Future close() async {
    return await _database!.close();
  }
}
