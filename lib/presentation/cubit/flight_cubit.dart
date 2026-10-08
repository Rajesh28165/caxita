import 'package:bloc/bloc.dart';
import '../../data/datasources/local_data.dart';
import '../../data/models/flight_model.dart';
import '../../domain/repositories/flight_repo.dart';

part 'flight_state.dart';

class FlightCubit extends Cubit<FlightState> {
  final FlightRepo repo;
  FlightCubit(this.repo) : super(FlightInitial());

  Future<void> loadFlights() async {
    emit(FlightLoading());
    try {
      await repo.init();
      final airlines = await repo.getAirlines();
      final flights = await repo.getFlights();
      emit(FlightLoaded(
        flights: flights, 
        airlines: airlines
      ));
    } catch (e) {
      emit(FlightFailed(e.toString()));
    }
  }

  Future<void> applyFilter(Set<String> selectedAirlines) async {
    final current = state;
    if (current is! FlightLoaded) return;
    try {
      final flights = await repo.getFlights(
        airlines: selectedAirlines,
        sortField: current.sortField,
        ascending: current.ascending,
      );
      emit(FlightLoaded(
        flights: flights,
        airlines: current.airlines,
        selectedAirlines: selectedAirlines,
        sortField: current.sortField,
        ascending: current.ascending,
      ));
    } catch (e) {
      emit(FlightFailed(e.toString()));
    }
  }

  Future<void> applySort(
    SortField? sortField, 
    bool ascending
  ) async {
    final current = state;
    if (current is! FlightLoaded) return;
    try {
      final flights = await repo.getFlights(
        airlines: current.selectedAirlines,
        sortField: sortField,
        ascending: ascending,
      );
      emit(FlightLoaded(
        flights: flights,
        airlines: current.airlines,
        selectedAirlines: current.selectedAirlines,
        sortField: sortField,
        ascending: ascending,
      ));
    } catch (e) {
      emit(FlightFailed(e.toString()));
    }
  }
}