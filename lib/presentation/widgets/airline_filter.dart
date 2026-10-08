import 'package:flight/presentation/components.dart';
import 'package:flutter/material.dart';

class AirlineFilter extends StatefulWidget {
  final List<String> airlines;
  final Set<String> selected;

  const AirlineFilter({
    super.key, 
    required this.airlines, 
    required this.selected
  });

  @override
  State<AirlineFilter> createState() => _AirlineFilterState();
}

class _AirlineFilterState extends State<AirlineFilter> {
  late final Set<String> _sel = {...widget.selected};

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .8),
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
              'Filter Your Search',
              style: TextStyle(fontWeight: FontWeight.w500)
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Airlines',
                  style: TextStyle(
                    color: Color(0xFF1565A8), 
                    fontWeight: FontWeight.w600
                  )
                ),
                TextButton(
                  onPressed: () => setState(_sel.clear),
                  child: const Text('Clear')
                ),
              ],
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final a in widget.airlines)
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Text(a, style: const TextStyle(fontSize: 12)),
                      value: _sel.contains(a),
                      onChanged: (v) => setState(() => v == true ? _sel.add(a) : _sel.remove(a)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GeneralComponent.appButton(
                    label: 'Reset',
                    onPressed: () => Navigator.pop(context, <String>{})
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GeneralComponent.appButton(
                    label: 'Done', 
                    onPressed: () => Navigator.pop(context, _sel)
                  ),
                ),
              ]
            ),
          ]
        ),
      ),
    );
  }
}