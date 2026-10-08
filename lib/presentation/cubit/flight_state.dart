part of 'flight_cubit.dart';

abstract class FlightState {}

class FlightInitial extends FlightState {}

class FlightLoading extends FlightState {}

class FlightLoaded extends FlightState {
  final List<FlightTrip> flights;
  final List<String> airlines;
  final Set<String> selectedAirlines;
  final SortField? sortField;
  final bool ascending;

  FlightLoaded({
    required this.flights,
    required this.airlines,
    this.selectedAirlines = const {},
    this.sortField,
    this.ascending = true,
  });
}

class FlightFailed extends FlightState {
  final String message;
  FlightFailed(this.message);
}