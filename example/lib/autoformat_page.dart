import 'package:flutter/material.dart';
import 'package:phone_number/phone_number.dart';
import 'package:phone_number_example/main.dart';
import 'package:phone_number_example/models/region.dart';
import 'package:phone_number_example/region_picker.dart';
import 'package:phone_number_example/store.dart';

class BehaviorOption {
  final PhoneInputBehavior? behavior;
  final String text;

  const BehaviorOption(this.behavior, this.text);
}

const List<BehaviorOption> options = [
  BehaviorOption(null, 'No format'),
  BehaviorOption(PhoneInputBehavior.strict, 'Strict'),
  BehaviorOption(PhoneInputBehavior.cancellable, 'Cancellable'),
  BehaviorOption(PhoneInputBehavior.lenient, 'Lenient'),
];

class AutoformatPage extends StatefulWidget {
  final Store store;

  AutoformatPage(this.store);

  @override
  _AutoformatPageState createState() => _AutoformatPageState();
}

class _AutoformatPageState extends State<AutoformatPage> {
  final key = GlobalKey<FormState>();

  Region? region;
  BehaviorOption behavior = options[0];

  TextEditingController regionCtrl = TextEditingController();
  TextEditingController ctrl = TextEditingController();

  void update() {
    setState(() {
      if (region != null && behavior.behavior != null) {
        ctrl = PhoneNumberEditingController.fromValue(
          widget.store.plugin,
          ctrl.value,
          regionCode: region!.code,
          behavior: behavior.behavior!,
        );
      } else {
        ctrl = TextEditingController.fromValue(ctrl.value);
      }
    });
  }

  Future<void> chooseRegions() async {
    dismissKeyboard(context);

    final regions = await widget.store.getRegions();

    final route = MaterialPageRoute<Region>(
      fullscreenDialog: true,
      builder: (_) => RegionPicker(regions: regions),
    );

    final selectedRegion = await Navigator.of(context).push<Region>(route);

    if (selectedRegion != null) {
      print('Region selected: $selectedRegion');
      regionCtrl.text = "${selectedRegion.name} (+${selectedRegion.prefix})";
      region = selectedRegion;
      update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        children: [
          TextFormField(
            controller: ctrl,
            autocorrect: false,
            enableSuggestions: false,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              helperText: '',
            ),
          ),
          InkWell(
            onTap: chooseRegions,
            child: IgnorePointer(
              child: TextFormField(
                controller: regionCtrl,
                decoration: InputDecoration(
                  labelText: 'Region',
                  helperText: '',
                ),
              ),
            ),
          ),
          DropdownButton<BehaviorOption>(
            onChanged: (value) {
              behavior = value ?? options[0];
              update();
            },
            isExpanded: true,
            value: behavior,
            items: options
                .map((option) =>
                    DropdownMenuItem(value: option, child: Text(option.text)))
                .toList(),
          ),
        ],
      ),
    );
  }
}
