import '../../data/datasources/local_data.dart';
import '../../data/models/flight_model.dart';

abstract class FlightRepo {
  Future<void> init(); // fetches from API only if DB is empty
  Future<List<FlightTrip>> getFlights({
    Set<String> airlines,
    SortField? sortField,
    bool ascending,
  });
  Future<List<String>> getAirlines();
}