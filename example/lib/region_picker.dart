import 'package:flutter/material.dart';
import 'package:phone_number_example/models/region.dart';

class RegionPicker extends StatefulWidget {
  final List<Region> regions;
  final Function(Region)? onSelectedRegion;

  const RegionPicker({
    Key? key,
    required this.regions,
    this.onSelectedRegion,
  }) : super(key: key);

  @override
  _RegionPickerState createState() => _RegionPickerState();
}

class _RegionPickerState extends State<RegionPicker> {
  late List<Region> _regions;

  @override
  void initState() {
    _regions = widget.regions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (text) {
            setState(() {
              _regions = widget.regions
                  .where((element) =>
                      element.code.contains(text.toUpperCase()) ||
                      element.prefix.toString().contains(text))
                  .toList(growable: false);
            });
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            hintText: 'Search for country code...',
            border: UnderlineInputBorder(),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemBuilder: (c, i) {
              final region = _regions[i];
              return ListTile(
                onTap: () => widget.onSelectedRegion?.call(region),
                title: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('${region.code} (+${region.prefix})'),
                ),
              );
            },
            separatorBuilder: (c, i) => Divider(height: 0),
            itemCount: _regions.length,
          ),
        ),
      ],
    );
  }
}
