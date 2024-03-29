import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/create_receipt.dart';
import 'package:naapos/screens/manage_item.dart';
import 'package:naapos/navigation.dart';
import 'package:naapos/utils/utils.dart';


void main() => runApp(NaaPOSApp());

class NaaPOSApp extends StatefulWidget {
  @override
  _NaaPOSApp createState() => _NaaPOSApp();
}

class _NaaPOSApp extends State<NaaPOSApp> {
  bool isDark = true;

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
