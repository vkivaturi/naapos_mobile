import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'homescreen.dart';
import 'package:naapos/items_catalog.dart';
import 'package:naapos/landingscreen.dart';
import 'package:naapos/utils.dart';


void main() => runApp(NaaPOSApp());

//class NaaPOSApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//
//      title: 'NaaPOS - Handhelp POS for small businesses',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
////      home: NaaPOSHome(title: 'Add to cart'),
////      home: ManageItem(title: 'Manage Items'),
//      home: MainScreen(),
//    );
//  }
//}

class NaaPOSApp extends StatefulWidget {
  @override
  _NaaPOSApp createState() => _NaaPOSApp();
}

class _NaaPOSApp extends State<NaaPOSApp> {
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: isDark ? Constants.darkPrimary : Constants.lightPrimary,
      statusBarIconBrightness: isDark?Brightness.light:Brightness.dark,
    ));
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: isDark ? Constants.darkTheme : Constants.lightTheme,
      home: MainScreen(),
    );
  }
}
