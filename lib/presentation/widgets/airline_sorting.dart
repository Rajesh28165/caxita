import 'package:flight/presentation/components.dart';
import 'package:flutter/material.dart';
import '../../data/datasources/local_data.dart';

typedef SortResult = ({SortField? field, bool ascending});

class AirlineSorting extends StatefulWidget {
  final SortField? field;
  final bool ascending;

  const AirlineSorting({
    super.key, 
    this.field, 
    required this.ascending
  });

  @override
  State<AirlineSorting> createState() => _AirlineSortingState();
}

class _AirlineSortingState extends State<AirlineSorting> {
  late SortField? _field = widget.field;
  late bool _asc = widget.ascending;

  static const _labels = {
    SortField.airline: 'Airline',
    SortField.duration: 'Duration',
    SortField.price: 'Price',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            const Text(
              'Sort Flight By',
              style: TextStyle(fontWeight: FontWeight.w500)
            ),
            const Divider(),
            for (final f in SortField.values)
              ListTile(
                dense: true,
                title: Text(_labels[f]!),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  _arrow(f, true),
                  const SizedBox(width: 6),
                  _arrow(f, false),
                ]),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GeneralComponent.appButton(
                    label: 'Reset',
                    onPressed: () => Navigator.pop<SortResult>(
                      context, 
                      (field: null, ascending: true)
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GeneralComponent.appButton(
                    label: 'Done',
                    onPressed: () => Navigator.pop<SortResult>(
                      context, 
                      (field: _field, ascending: _asc)
                    ),
                  ),
                ),
              ]
            ),
          ]
        ),
      ),
    );
  }

  Widget _arrow(SortField f, bool up) {
    final selected = _field == f && _asc == up;
    return GestureDetector(
      onTap: () => setState(() {
        _field = f;
        _asc = up;
      }),
      child: CircleAvatar(
        radius: 11,
        backgroundColor: selected ? const Color(0xFFF7941D) : const Color(0xFF4A5560),
        child: Icon(
          up ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: 16, 
          color: Colors.white
        ),
      ),
    );
  }
}