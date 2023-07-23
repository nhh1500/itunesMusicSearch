import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/model/dbType.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:itunes_music/model/playListHeader.dart';

import '../model/playListBody.dart';

class PlayListbdyVM extends GetxController {
  final tableName = 'playListBody';
  List<PlayListBody> _playListBody = [];
  List<PlayListBody> get playListBody => _playListBody;
  Database? _database;

  Future init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, tableName);
    _database = await openDatabase(path, version: 1, onCreate: _createTB);
  }

  Future _createTB(Database db, int version) async {
    await db.execute('''
CREATE TABLE $tableName (
  ${PlayListBodyFields.id} ${DBType.id},
  ${PlayListBodyFields.headerId} ${DBType.int},
  ${PlayListBodyFields.index} ${DBType.int},
  ${PlayListBodyFields.songId} ${DBType.int}
)
''');
  }

  Future<void> create(PlayListBody body) async {
    await _database!.insert(tableName, body.toJson());
  }

  Future<List<PlayListBody>> readPlayListDetail(int headerId) async {
    final maps = await _database!.query(tableName,
        columns: PlayListBodyFields.values,
        where: '${PlayListBodyFields.headerId} = ?',
        whereArgs: [headerId]);
    List<PlayListBody> listBdy = [];
    for (var item in maps) {
      listBdy.add(PlayListBody.fromJson(item));
    }
    return listBdy;
  }

  Future<List<PlayListBody>> readSong(int headerId, int songId) async {
    final maps = await _database!.query(tableName,
        columns: PlayListBodyFields.values,
        where:
            '${PlayListBodyFields.headerId} = ? And ${PlayListBodyFields.songId} = ?',
        whereArgs: [headerId, songId],
        orderBy: PlayListBodyFields.index);
    List<PlayListBody> listBdy = [];
    for (var item in maps) {
      listBdy.add(PlayListBody.fromJson(item));
    }
    return listBdy;
  }

  Future<List<PlayListBody>> readAll() async {
    final result = await _database!.query(tableName);
    return result.map((e) => PlayListBody.fromJson(e)).toList();
  }

  Future<void> updateRec(PlayListBody body) async {
    await _database!.update(tableName, body.toJson(),
        where: '${PlayListBodyFields.id} = ?', whereArgs: [body.id]);
  }

  Future<void> delete(int headerId, int songId) async {
    await _database!.delete(tableName,
        where:
            '${PlayListBodyFields.headerId} = ? And ${PlayListBodyFields.songId} = ?',
        whereArgs: [headerId, songId]);
  }

  Future close() async {
    return await _database!.close();
  }
}
