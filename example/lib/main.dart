import 'package:flutter/material.dart';
import 'package:phone_number_example/home.dart';

void main() => runApp(const App());

void dismissKeyboard(BuildContext context) => FocusScope.of(context).unfocus();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Helvetica Neue'),
      home: Home(),
    );
  }
}
