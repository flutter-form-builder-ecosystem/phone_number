import 'package:flutter/material.dart';
import 'package:phone_number/phone_number.dart';
import 'package:phone_number_example/models/parse_result.dart';
import 'package:phone_number_example/models/region.dart';
import 'package:phone_number_example/region_picker.dart';
import 'package:phone_number_example/store.dart';

/// TODO: Add previous hardcoded examples
// parse '17449106505' (MX)
// parse list "+48606723456", "+48774843312"
// format '+47234723432', 'BR'

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final regionCtrl = TextEditingController();
  final numberCtrl = TextEditingController();
  final store = Store(PhoneNumberUtil());
  final key = GlobalKey<FormState>();

  Region? region;
  ParseResult? result;

  bool get hasResult => result != null;

  Future<void> parse() async {
    setState(() => result = null);
    if (key.currentState!.validate()) {
      dismissKeyboard();
      result = await store.parse(numberCtrl.text, region: region);
      print('Parse Result: $result');
      setState(() {});
    }
  }

  Future<void> format() async {
    if (key.currentState!.validate()) {
      dismissKeyboard();
      final formatted = await store.format(numberCtrl.text, region!);
      if (formatted != null) {
        numberCtrl.text = formatted;
        setState(() {});
      }
    }
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
    dismissKeyboard();
    final regions = await store.getRegions();
    await showModalBottomSheet<Region>(
      context: context,
      builder: (context) => RegionPicker(
        regions: regions,
        onSelectedRegion: (r) {
          print('Region selected: $r');
          regionCtrl.text = "${r.code} (+${r.prefix})";
          setState(() => region = r);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void dismissKeyboard() => FocusScope.of(context).unfocus();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dismissKeyboard,
      child: Scaffold(
        appBar: AppBar(title: Text('Phone Number')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: numberCtrl,
                    autocorrect: false,
                    enableSuggestions: false,
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
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
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          child: Text('Validate'),
                          onPressed: regionCtrl.text.isEmpty ? null : validate,
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          child: Text('Format'),
                          onPressed: regionCtrl.text.isEmpty ? null : format,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          child: Text('Parse'),
                          onPressed: parse,
                        ),
                      ),
                    ],
                  ),
                  OutlinedButton(
                    child: Text('Reset'),
                    onPressed: reset,
                  ),
                  SizedBox(height: 20),
                  if (hasResult)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Result(result: result!),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> validate() async {
    final isValid = await store.validate(numberCtrl.text, region!);
    print('isValid : ' + isValid.toString());
  }
}

class Result extends StatelessWidget {
  final ParseResult result;

  const Result({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Result:", style: theme.textTheme.headline6),
        SizedBox(height: 10),
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
    Key? key,
    required this.name,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(child: Text('$name', style: theme.textTheme.bodyText2)),
          Flexible(child: Text(value, style: theme.textTheme.bodyText1)),
        ],
      ),
    );
  }
}
