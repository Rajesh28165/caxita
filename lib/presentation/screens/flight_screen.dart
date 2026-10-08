import 'dart:math' as math;

import 'package:flight/presentation/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../core/extensions/build_context_extension.dart';
import '../cubit/flight_cubit.dart';
import '../widgets/airline_filter.dart';
import '../widgets/airline_sorting.dart';
import '../widgets/flight_card.dart';

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});
  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FlightCubit>().loadFlights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: BlocBuilder<FlightCubit, FlightState>(
        builder: (context, state) {
          return Column(
            children: [
              _Header(count: state is FlightLoaded ? state.flights.length : 0),
              Expanded(
                child: Stack(
                  children: [
                    _body(context, state),
                    if (state is FlightLoaded)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: _SortFilterBar(state: state)
                        ),
                      ),
                  ]
                ),
              ),
            ]
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, FlightState state) {
    if (state is FlightLoaded) {
      if (state.flights.isEmpty) return GeneralComponent.emptyView();
      return ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 90),
        itemCount: state.flights.length,
        itemBuilder: (_, i) => FlightCard(trip: state.flights[i]),
      );
    }
    if (state is FlightFailed) {
      return GeneralComponent.errorView(
        message: state.message,
        onRetry: () => context.read<FlightCubit>().loadFlights(),
      );
    }
    return GeneralComponent.loading();
  }
}

class _Header extends StatelessWidget {
  final int count;

  const _Header({required this.count});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('d MMMM').format(DateTime.now());

    return Container(
      color: const Color(0xFF1565A8),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 8),
              const BackButton(color: Colors.white),
              const Spacer(),
              const Text(
                'DXB',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8),
              Transform.rotate(
                angle: math.pi / 2,
                child: const Icon(
                  Icons.flight,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'KWI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.edit_note,
                color: Colors.white,
              ),

              const SizedBox(width: 16),
            ],
          ),

          Text(
            '$today  |  $count Flights',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SortFilterBar extends StatelessWidget {
  final FlightLoaded state;
  const _SortFilterBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FlightCubit>();
    return Material(
      color: const Color(0xFFF7941D),
      borderRadius: BorderRadius.circular(8),
      elevation: 4,
      child: Row(
        mainAxisSize: MainAxisSize.min, 
        children: [
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(Icons.swap_vert, size: 18),
            label: const Text('Sort'),
            onPressed: () async {
              final r = await context.showAppSheet<SortResult>(
                AirlineSorting(
                  field: state.sortField, 
                  ascending: state.ascending
                )
              );
              if (r != null) cubit.applySort(r.field, r.ascending);
            },
          ),
          Container(
            width: 1, 
            height: 20, 
            color: Colors.white54
          ),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(Icons.tune, size: 18),
            label: const Text('Filter'),
            onPressed: () async {
              final r = await context.showAppSheet<Set<String>>(
                AirlineFilter(
                  airlines: state.airlines, 
                  selected: state.selectedAirlines
                )
              );
              if (r != null) cubit.applyFilter(r);
            },
          ),
        ]
      ),
    );
  }
}