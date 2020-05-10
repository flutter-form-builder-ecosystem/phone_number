import 'package:flutter/material.dart';
import 'package:phone_number_example/models/region.dart';

class RegionPicker extends StatelessWidget {
  final List<Region> regions;
  final Function(Region) onSelectedRegion;

  const RegionPicker({
    Key key,
    @required this.regions,
    this.onSelectedRegion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (c, i) {
        final region = regions[i];
        return InkWell(
          onTap: () => onSelectedRegion(region),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('${region.code}'),
          ),
        );
      },
      separatorBuilder: (c, i) => Divider(height: 0),
      itemCount: regions.length,
    );
  }
}
