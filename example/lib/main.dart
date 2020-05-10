import 'package:flutter/material.dart';
import 'package:phone_number_example/home_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Helvetica Neue'),
      home: HomePage(),
    );
  }
}
