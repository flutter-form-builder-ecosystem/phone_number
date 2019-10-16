import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_number/phone_number.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final parsed = await PhoneNumber.parse("49988151701", region: "BR");

      platformVersion = """   
      
type: ${parsed['type']}
e164: ${parsed['e164']} 
international: ${parsed['international']}
national: ${parsed['national']}
country code: ${parsed['country_code']}
national number: ${parsed['national_number']}
      """;

      final formatted = await PhoneNumber.format('+47234723432', 'BR');
      platformVersion += """
      
partially: ${formatted['formatted']}
      """;

      final parsedValues =
          await PhoneNumber.parseList(["+48606723456", "+48774843312"]);

      parsedValues.forEach((number, parsed) {
        if (parsed != null) {
          platformVersion += """
          
type: ${parsed['type']}
e164: ${parsed['e164']}
international: ${parsed['international']}
national: ${parsed['national']}
country code: ${parsed['country_code']}
national number: ${parsed['national_number']}
          """;
        } else {
          platformVersion += """
          
number not recognized: $number
          """;
        }
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
            child: SingleChildScrollView(
          child: Text(
            _platformVersion,
            textAlign: TextAlign.left,
          ),
        )),
      ),
    );
  }
}
