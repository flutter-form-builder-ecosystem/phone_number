import 'package:flutter/material.dart';
import 'package:phone_number/phone_number.dart';
import 'package:phone_number_example/models/parse_result.dart';
import 'package:phone_number_example/models/region.dart';
import 'package:phone_number_example/region_picker.dart';
import 'package:phone_number_example/store.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final regionCtrl = TextEditingController();
  final numberCtrl = TextEditingController();
  final store = Store(PhoneNumber());
  final key = GlobalKey<FormState>();

  Region region;
  ParseResult result;

  bool get hasResult => result != null;

  Future<void> parse() async {
    setState(() => result = null);
    if (key.currentState.validate()) {
      dismissKeyboard();
      result = await store.parse(numberCtrl.text, region: region);
      setState(() {});
    }
  }

  void reset() {
    key.currentState.reset();
    regionCtrl.text = '';
    numberCtrl.text = '';
    region = null;
    result = null;
    setState(() {});
  }

  void chooseRegions() async {
    dismissKeyboard();
    final regions = await store.getRegions();
    await showModalBottomSheet<Region>(
      context: context,
      builder: (context) => RegionPicker(
        regions: regions,
        onSelectedRegion: (r) {
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
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
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
                          labelText: 'Region (optional)',
                          helperText: '',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlineButton(
                            child: Text('Reset'), onPressed: reset),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                          child: RaisedButton(
                              child: Text('Parse'), onPressed: parse)),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (hasResult)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Result(result: result),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Result extends StatelessWidget {
  final ParseResult result;

  const Result({Key key, this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Result:", style: theme.textTheme.title),
        ...(result.hasError)
            ? [
                Text(
                  'Error! (code: ${result.errorCode})',
                  style: theme.textTheme.body2.copyWith(color: Colors.red),
                ),
              ]
            : [
                _ResultRow(name: 'Type', value: result.type),
                _ResultRow(name: 'E164', value: result.e164),
                _ResultRow(name: 'International', value: result.international),
                _ResultRow(name: 'National', value: result.national),
                _ResultRow(name: 'Country code', value: result.countryCode),
              ],
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String name;
  final String value;

  const _ResultRow({Key key, this.name, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(child: Text('$name', style: theme.textTheme.body1)),
          Flexible(child: Text(value, style: theme.textTheme.body2)),
        ],
      ),
    );
  }
}
