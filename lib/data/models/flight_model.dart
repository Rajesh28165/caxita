import 'package:equatable/equatable.dart';

class FlightSegment extends Equatable {
  final String depCode, arrCode, airlineName, airlineCode, flightNumber;
  final DateTime depTime, arrTime;
  final Duration duration;

  const FlightSegment({
    required this.depCode,
    required this.arrCode,
    required this.airlineName,
    required this.airlineCode,
    required this.flightNumber,
    required this.depTime,
    required this.arrTime,
    required this.duration,
  });

  factory FlightSegment.fromJson(Map<String, dynamic> j) {
    final info = j['FlightInfo'];
    final d = j['DurationPerLeg'];
    return FlightSegment(
      depCode: j['Departure']['AirportCode'],
      arrCode: j['Arrival']['AirportCode'],
      airlineName: info['Name']['en'],
      airlineCode: info['Code'],
      flightNumber: info['Number'].toString(),
      depTime: DateTime.parse(j['Departure']['DateTime']),
      arrTime: DateTime.parse(j['Arrival']['DateTime']),
      duration: Duration(
        days: d['Days'], 
        hours: d['Hours'], 
        minutes: d['Minutes']
      ),
    );
  }

  @override
  List<Object?> get props => [depCode, arrCode, depTime, flightNumber];
}

class FlightJourney extends Equatable {
  final Duration duration;
  final int stops;
  final List<FlightSegment> segments;

  const FlightJourney({
    required this.duration, 
    required this.stops, 
    required this.segments
  });

  FlightSegment get first => segments.first;
  FlightSegment get last => segments.last;

  factory FlightJourney.fromJson(Map<String, dynamic> j) {
    final t = j['JourneyTime'];
    return FlightJourney(
      duration: Duration(
        days: t['Days'], 
        hours: t['Hours'], 
        minutes: t['Minutes']
      ),
      stops: j['TotalStops'],
      segments: (j['FlightItems'] as List).map(
        (e) => FlightSegment.fromJson(e)
      ).toList(),
    );
  }

  @override
  List<Object?> get props => [segments];
}

class FlightTrip extends Equatable {
  final String key, currency;
  final double total;
  final Duration duration;
  final List<FlightJourney> journeys;

  const FlightTrip({
    required this.key,
    required this.currency,
    required this.total,
    required this.duration,
    required this.journeys,
  });

  String get airlineName => journeys.first.first.airlineName;
  String get airlineCode => journeys.first.first.airlineCode;

  factory FlightTrip.fromJson(Map<String, dynamic> j) {
    final fare = j['FareDetails'];
    final t = j['TripDuration'];
    return FlightTrip(
      key: j['FlightTripKey'],
      currency: fare['Currency'],
      total: double.parse(fare['Total']),
      duration: Duration(
        days: t['Days'], 
        hours: t['Hours'], 
        minutes: t['Minutes']
      ),
      journeys: (j['FlightJourneys'] as List).map(
        (e) => FlightJourney.fromJson(e)
      ).toList(),
    );
  }

  @override
  List<Object?> get props => [key];
}