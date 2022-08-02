import 'package:flutter/material.dart';

import 'models/region.dart';

class RegionPicker extends StatefulWidget {
  final List<Region> regions;

  const RegionPicker({
    super.key,
    required this.regions,
  });

  @override
  RegionPickerState createState() => RegionPickerState();
}

class RegionPickerState extends State<RegionPicker> {
  late List<Region> _regions;
  final _ctrl = TextEditingController();

  @override
  void initState() {
    _regions = widget.regions;
    _ctrl.addListener(() {
      setState(() => _regions = _filtered(_ctrl.text));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available regions")),
      body: Scrollbar(
        child: Column(
          children: [
            TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                hintText: 'Search...',
                border: const UnderlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _ctrl.clear,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _regions.length,
                separatorBuilder: (_, i) => const Divider(height: 0),
                itemBuilder: (context, i) {
                  final region = _regions[i];
                  return InkWell(
                    onTap: () => Navigator.of(context).pop(region),
                    child: _RegionListTile(region: region),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Region> _filtered(String input) {
    return widget.regions.where(
      (elt) {
        return elt.code.toUpperCase().contains(input.toUpperCase()) ||
            elt.prefix.toString().contains(input) ||
            elt.name.toLowerCase().startsWith(input.toLowerCase());
      },
    ).toList(growable: false);
  }
}

class _RegionListTile extends StatelessWidget {
  const _RegionListTile({
    required Region region,
  }) : _region = region;

  final Region _region;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.standard,
      title: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              _region.code,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(_region.name),
          const Spacer(),
          Text(
            '+${_region.prefix}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
