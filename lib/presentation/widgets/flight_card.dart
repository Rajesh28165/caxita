import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/flight_model.dart';

class FlightCard extends StatelessWidget {
  final FlightTrip trip;

  const FlightCard({
    super.key, 
    required this.trip
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                for (final j in trip.journeys) _JourneyRow(journey: j),
              ]
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Non Refundable',
                  style: TextStyle(
                    color: Colors.red, 
                    fontSize: 10
                  )
                ),
                Text(
                  '${trip.currency} ${trip.total.toStringAsFixed(3)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16
                  )
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}

class _JourneyRow extends StatelessWidget {
  final FlightJourney journey;

  const _JourneyRow({required this.journey});

  String _fmt(Duration d) => '${d.inHours}h ${d.inMinutes.remainder(60)}m';

  @override
  Widget build(BuildContext context) {
    final f = journey.first, l = journey.last;
    final time = DateFormat('HH:mm');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: SvgPicture.network(
              AppConstants.airlineLogo(f.airlineCode),
              height: 22,
              placeholderBuilder: (_) => Text(f.airlineCode),
            ),
          ),
          const SizedBox(width: 8),
          _Endpoint(
            label: 'Departure',
            time: time.format(f.depTime),
            code: f.depCode,
            end: CrossAxisAlignment.start
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  _fmt(journey.duration),
                  style: const TextStyle(
                    fontSize: 9, 
                    color: Colors.grey
                  )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.circle, 
                        size: 6, 
                        color: Color(0xFFF7941D)
                      ),
                      Expanded(
                        child: Row(
                          children: List.generate(
                            20,
                            (index) => Expanded(
                              child: Container(
                                height: 1,
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: math.pi / 2,
                        child: const Icon(
                          Icons.flight,
                          color: Color(0xFFF7941D),
                          size: 14,
                        ),
                      ),
                    ]
                  ),
                ),
                Text(
                  journey.stops == 0 ? 'Non-stop' : '${journey.stops} stop(s)',
                  style: const TextStyle(
                    fontSize: 9, 
                    color: Colors.grey
                  )
                ),
              ]
            ),
          ),
          _Endpoint(
            label: 'Arrival',
            time: time.format(l.arrTime),
            code: l.arrCode,
            end: CrossAxisAlignment.end
          ),
        ]
      ),
    );
  }
}

class _Endpoint extends StatelessWidget {
  final String label, time, code;
  final CrossAxisAlignment end;

  const _Endpoint({
    required this.label,
    required this.time,
    required this.code,
    required this.end
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: end,
    children: [
      Text(
        label, 
        style: const TextStyle(
          fontSize: 9, 
          color: Colors.grey
        )
      ),
      Text(
        time,
        style: const TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 14
        )
      ),
      Text(
        code, 
        style: const TextStyle(fontSize: 10)
      ),
    ],
  );
}