import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../core/constants/app_constants.dart';
import '../../core/database/app_database.dart';
import '../models/flight_model.dart';

enum SortField { airline, duration, price }

class LocalData {
  static const _orderColumn = {
    SortField.airline: 'airline_name',
    SortField.duration: 'duration_minutes',
    SortField.price: 'total_price',
  };

  Future<bool> hasData() async {
    final db = await AppDatabase.instance.db;
    final c = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.table}')
    );
    return (c ?? 0) > 0;
  }

  Future<void> saveTrips(List<Map<String, dynamic>> trips) async {
    final db = await AppDatabase.instance.db;
    final batch = db.batch();
    for (final t in trips) {
      final info = t['FlightJourneys'][0]['FlightItems'][0]['FlightInfo'];
      final d = t['TripDuration'];
      batch.insert(
        AppConstants.table,
        {
          'trip_key': t['FlightTripKey'],
          'airline_name': info['Name']['en'],
          'airline_code': info['Code'],
          'total_price': double.parse(t['FareDetails']['Total']),
          'currency': t['FareDetails']['Currency'],
          'duration_minutes': (d['Days'] * 24 * 60) + (d['Hours'] * 60) + d['Minutes'],
          'raw_json': jsonEncode(t),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<FlightTrip>> getTrips({
    Set<String> airlines = const {},
    SortField? sortField,
    bool ascending = true,
  }) async {
    final db = await AppDatabase.instance.db;
    final where = airlines.isEmpty
      ? null
      : 'airline_name IN (${List.filled(airlines.length, '?').join(',')})';
    final rows = await db.query(
      AppConstants.table,
      where: where,
      whereArgs: airlines.isEmpty ? null : airlines.toList(),
      orderBy: sortField == null
        ? null
        : '${_orderColumn[sortField]} ${ascending ? 'ASC' : 'DESC'}',
    );
    return rows.map(
      (r) => FlightTrip.fromJson(jsonDecode(r['raw_json'] as String))
    ).toList();
  }

  Future<List<String>> getAirlines() async {
    final db = await AppDatabase.instance.db;
    final rows = await db.rawQuery(
      'SELECT DISTINCT airline_name FROM ${AppConstants.table} ORDER BY airline_name'
    );
    return rows.map((r) => r['airline_name'] as String).toList();
  }
}