import 'dart:async';

import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:io';

class CSDB {
  static final String databaseName = "csbookdb.db";
  static final CSDB _instance = CSDB._();
  static Database _database;

  CSDB._();

  factory CSDB() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }

    _database = await init();

    return _database;
  }

  Future<Database> init() async {
    String directory = await getDatabasesPath();
    String dbPath = join(directory, databaseName);
    var database = openDatabase(dbPath,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);

    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
    CREATE TABLE Instances(
      id INTEGER PRIMARY KEY,
      songId INTEGER,
      songText TEXT,
      capo TEXT,
      rithm TEXT,
      tone TEXT,
      parish INTEGER)
  ''');

    db.execute('''
    CREATE TABLE Songs(
      id INTEGER PRIMARY KEY,
      title TEXT,
      subtitle TEXT,
      author TEXT,
      type TEXT,
      time TEXT,
      youtubeId TEXT,
      instances TEXT,
      cached INTEGER)
  ''');

    print("Databases created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
    db.execute("DROP TABLE Songs;");
    db.execute("DROP TABLE Instances;");

    this._onCreate(db, 0);
  }

  /*
   * Instance Related Functions
   */
  Future<int> addInstance(Instance instance) async {
    var client = await db;
    return client.insert('Instances', instance.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Instance> fetchInstance(int id) async {
    Database client = await db;
    List<Map<String, dynamic>> instances = await client.rawQuery(
        'select * from Instances i join Songs s on(i.songId = s.id) where i.id=' +
            id.toString());
    if (instances.length > 0) {
      return Instance.fromDb(Song.fromDb(instances[0]), instances[0]);
    } else
      return null;
  }

  Future<int> updateInstance(Instance instance) async {
    var client = await db;
    return client.update('Instances', instance.toMapForDb(),
        where: 'id = ?',
        whereArgs: [instance.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeInstance(int id) async {
    var client = await db;
    return client.delete('Instances', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> saveOrUpdateInstance(Instance instance) async {
    await this.saveOrUpdateSong(instance.song);
    int updateResult = await updateInstance(instance);
    return (updateResult > 0) ? updateResult : await addInstance(instance);
  }

  /*
   * Song Related Functions
   */
  Future<int> addSong(Song song) async {
    var client = await db;
    return client.insert('Songs', song.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Song> fetchSong(int id) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
        client.query('Songs', where: 'id = ?', whereArgs: [id]);
    var maps = await futureMaps;

    if (maps.length != 0) {
      return Song.fromDb(maps.first);
    }

    return null;
  }

  Future<int> updateSong(Song song) async {
    var client = await db;
    return client.update('Songs', song.toMapForDb(),
        where: 'id = ?',
        whereArgs: [song.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeSong(int id) async {
    var client = await db;
    return client.delete('Songs', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Song>> fetchAllSongs() async {
    var client = await db;
    List<Map<String, dynamic>> maps = await client.query('Songs');
    return maps.map((i) => new Song.fromJson(i)).toList();
  }

  Future<int> saveOrUpdateSong(Song song) async {
    int updateResult = await updateSong(song);
    return (updateResult > 0) ? updateResult : await addSong(song);
  }

  Future<int> saveOrUpdateAll(List<Song> songs) async {
    int retVal = 0;
    for (Song s in songs) {
      retVal += await saveOrUpdateSong(s);
    }
    return retVal;
  }
}
