import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../constants/app_constants.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();
  Database? _db;

  Future<Database> get db async => _db ??= await _open();

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), AppConstants.dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute(
          '''
            CREATE TABLE ${AppConstants.table} (
              trip_key TEXT PRIMARY KEY,
              airline_name TEXT NOT NULL,
              airline_code TEXT NOT NULL,
              total_price REAL NOT NULL,
              currency TEXT NOT NULL,
              duration_minutes INTEGER NOT NULL,
              raw_json TEXT NOT NULL
            )
          '''
        );
        await db.execute('CREATE INDEX idx_airline ON ${AppConstants.table}(airline_name)');
      }
    );
  }
}