import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:phone_number_example/main.dart';
import 'package:phone_number_example/models/parse_result.dart';
import 'package:phone_number_example/models/region.dart';
import 'package:phone_number_example/region_picker.dart';
import 'package:phone_number_example/store.dart';
import 'package:phone_number_example/utils.dart';

/// TODO: Add previous hardcoded examples
// parse '17449106505' (MX)
// parse list "+48606723456", "+48774843312"
// format '+47234723432', 'BR'

class FunctionsPage extends StatefulWidget {
  final Store store;

  const FunctionsPage(this.store, {super.key});

  @override
  FunctionsPageState createState() => FunctionsPageState();
}

class FunctionsPageState extends State<FunctionsPage>
    with AutomaticKeepAliveClientMixin {
  final regionCtrl = TextEditingController();
  final numberCtrl = TextEditingController();
  final key = GlobalKey<FormState>();

  Region? region;
  ParseResult? result;

  bool get hasResult => result != null;
  String? _devicesRegionCode;

  Future<void> parse() async {
    setState(() => result = null);
    if (key.currentState!.validate()) {
      dismissKeyboard(context);
      result = await widget.store.parse(numberCtrl.text, region: region);
      log('Parse Result: $result');
      setState(() {});
    }
  }

  Future<void> format() async {
    if (key.currentState!.validate()) {
      dismissKeyboard(context);
      final formatted = await widget.store.format(numberCtrl.text, region!);
      if (formatted != null) {
        numberCtrl.text = formatted;
        setState(() {});
      }
    }
  }

  Future<void> fetchDevicesRegionCode() async {
    final code = await widget.store.carrierRegionCode();
    setState(() => _devicesRegionCode = code);
  }

  void reset() {
    key.currentState!.reset();
    regionCtrl.text = '';
    numberCtrl.text = '';
    region = null;
    result = null;
    setState(() {});
  }

  Future<void> chooseRegions() async {
    dismissKeyboard(context);

    final regions = await widget.store.getRegions();

    final route = MaterialPageRoute<Region>(
      fullscreenDialog: true,
      builder: (_) => RegionPicker(regions: regions),
    );

    if (!mounted) return;
    final selectedRegion = await Navigator.of(context).push<Region>(route);

    if (selectedRegion != null) {
      log('Region selected: $selectedRegion');
      regionCtrl.text = "${selectedRegion.name} (+${selectedRegion.prefix})";
      setState(() => region = selectedRegion);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: key,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        children: [
          TextFormField(
            controller: numberCtrl,
            autocorrect: false,
            enableSuggestions: false,
            autofocus: true,
            keyboardType: TextInputType.phone,
            validator: (v) => v?.isEmpty == true ? 'Required' : null,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              helperText: '',
            ),
          ),
          InkWell(
            onTap: chooseRegions,
            child: IgnorePointer(
              child: TextFormField(
                controller: regionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Region',
                  helperText: '',
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: validate,
                  child: const Text('Validate'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: regionCtrl.text.isEmpty ? null : format,
                  child: const Text('Format'),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: ElevatedButton(
                  onPressed: parse,
                  child: const Text('Parse'),
                ),
              ),
            ],
          ),
          OutlinedButton(
            onPressed: reset,
            child: const Text('Reset'),
          ),
          OutlinedButton(
            onPressed: fetchDevicesRegionCode,
            child: const Text('Region Code'),
          ),
          if (_devicesRegionCode != null) RegionCode(code: _devicesRegionCode!),
          const SizedBox(height: 20),
          if (hasResult)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Result(result: result!),
            ),
        ],
      ),
    );
  }

  Future<void> validate() async {
    if (key.currentState!.validate()) {
      dismissKeyboard(context);

      final isValid = await widget.store.validate(
        numberCtrl.text,
        region: region,
      );
      log('isValid : $isValid');

      if (!mounted) return;
      Utils.showSnackBar(
        context,
        "Validation Status: ${isValid ? 'Valid' : 'Invalid'}",
        prefix: Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          size: 20,
          color: isValid ? Colors.green : Colors.red,
        ),
        color: Colors.white,
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class RegionCode extends StatelessWidget {
  const RegionCode({
    super.key,
    required this.code,
  });

  final String code;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Device Region code: '),
          TextSpan(text: code, style: const TextStyle(color: Colors.blue)),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class Result extends StatelessWidget {
  final ParseResult result;

  const Result({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Result:", style: theme.textTheme.headline6),
        const SizedBox(height: 10),
        ...(result.hasError)
            ? [
                Text(
                  'Error! (code: ${result.errorCode})',
                  style: theme.textTheme.bodyText1?.copyWith(color: Colors.red),
                ),
              ]
            : [
                _ResultRow(
                  name: 'Type',
                  value: result.phoneNumber!.type.toString().split('.').last,
                ),
                _ResultRow(name: 'E164', value: result.phoneNumber!.e164),
                _ResultRow(
                  name: 'International',
                  value: result.phoneNumber!.international,
                ),
                _ResultRow(
                  name: 'National',
                  value: result.phoneNumber!.national,
                ),
                _ResultRow(
                  name: 'National number',
                  value: result.phoneNumber!.nationalNumber,
                ),
                _ResultRow(
                  name: 'Country code',
                  value: result.phoneNumber!.countryCode,
                ),
              ],
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String name;
  final String value;

  const _ResultRow({
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(child: Text(name, style: theme.textTheme.bodyText2)),
          Flexible(child: Text(value, style: theme.textTheme.bodyText1)),
        ],
      ),
    );
  }
}
