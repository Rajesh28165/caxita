import 'flight_repo.dart';
import '../../data/datasources/local_data.dart';
import '../../data/datasources/remote_data.dart';
import '../../data/models/flight_model.dart';

class FlightRepoImpl implements FlightRepo {
  final RemoteData remote;
  final LocalData local;
  FlightRepoImpl(this.remote, this.local);

  @override
  Future<void> init() async {
    if (await local.hasData()) return;
    final trips = await remote.fetchTrips();
    await local.saveTrips(trips);
  }

  @override
  Future<List<FlightTrip>> getFlights({
    Set<String> airlines = const {},
    SortField? sortField,
    bool ascending = true,
  }) => local.getTrips(
    airlines: airlines, 
    sortField: sortField, 
    ascending: ascending
  );

  @override
  Future<List<String>> getAirlines() => local.getAirlines();
}