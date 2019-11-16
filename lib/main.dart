import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'package:naapos/items_catalog.dart';

void main() => runApp(NaaPOSApp());

class NaaPOSApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
//      home: NaaPOSHome(title: 'Create Invoice'),
      home: ManageItem(title: 'Manage Items'),
    );
  }
}

