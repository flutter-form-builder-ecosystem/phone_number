import 'package:flutter/material.dart';
import 'package:phone_number/phone_number.dart';
import 'package:phone_number_example/autoformat_page.dart';
import 'package:phone_number_example/functions_page.dart';
import 'package:phone_number_example/main.dart';
import 'package:phone_number_example/store.dart';

const List<Tab> tabs = [
  Tab(text: 'Functions'),
  Tab(text: 'Auto-format'),
];

class Home extends StatelessWidget {
  final store = Store(PhoneNumberUtil());

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => dismissKeyboard(context),
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Phone Number'),
            bottom: const TabBar(tabs: tabs),
          ),
          body: TabBarView(
            children: [
              FunctionsPage(store),
              AutoformatPage(store),
            ],
          ),
        ),
      ),
    );
  }
}
