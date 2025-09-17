import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/team.dart';

class FavoritesDatabase {
  static final FavoritesDatabase _instance = FavoritesDatabase._internal();
  factory FavoritesDatabase() => _instance;
  FavoritesDatabase._internal();

  Database? _db;

  Future<Database> get db async {
    _db ??= await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'favorites.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE favorites(
          id INTEGER PRIMARY KEY,
          name TEXT,
          logo TEXT,
          city TEXT,
          latitude REAL,
          longitude REAL
        )
        ''');
      },
    );
  }

  Future<void> addTeam(Team team) async {
    final dbClient = await db;
    await dbClient.insert('favorites', team.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeTeam(int id) async {
    final dbClient = await db;
    await dbClient.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Team>> fetchAll() async {
    final dbClient = await db;
    final maps = await dbClient.query('favorites');
    return maps.map((e) => Team(
      id: e['id'] as int,
      name: e['name'] as String,
      logo: e['logo'] as String,
      city: e['city'] as String,
      latitude: e['latitude'] as double,
      longitude: e['longitude'] as double,
    )).toList();
  }
}
