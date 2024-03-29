import 'package:flutter/material.dart';
import 'package:naapos/data/entities.dart';
import 'package:csv/csv.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static String appName = "Point of Sale";
  static String operatorId = "operatorId";
  static String storeId = "storeId";
  static String emailId = "emailId";

  //Colors for theme
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Color(0xff5563ff);
  static Color darkAccent = Color(0xff5563ff);
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color ratingBG = Colors.yellow[600];

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        title: TextStyle(
          color: lightBG,
          fontSize: 24.0,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        title: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

class HelperMethods {
  //Show message at bottom of the page
  static void showMessage(BuildContext context, Color color, String message) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: color,
      content: Text(
        message,
        style: TextStyle(fontSize: 20.0, color: Colors.white),
      ),
    );
    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  //Convert items into a csv string. This is useful while downloading catalog data
  static String convertItemsListToCSV(List<Item> items) {
    List<List<dynamic>> rows = List<List<dynamic>>();

    for (var item in items) {
      List<dynamic> row = List();

      row.add(item.code);
      row.add(item.itemDetail);
      row.add(item.tax);
      row.add(item.unitPrice);

      rows.add(row);
    }

    return ListToCsvConverter(fieldDelimiter: ",").convert(rows);
  }

  //Convert invoices into a csv string. This is useful while downloading catalog data
  static String convertInvoicesListToCSV(List<Invoice> invoices) {
    List<List<dynamic>> rows = List<List<dynamic>>();

    for (var invoice in invoices) {
      List<dynamic> row = List();
      row.add(invoice.invoiceNumber);
      row.add(invoice.invoiceAmount);
      row.add(invoice.invoiceQuantity);
      row.add(invoice.invoiceTax);
      row.add(invoice.storeId);
      row.add(invoice.operatorId);
      row.add(invoice.invoiceDateTime);

      rows.add(row);
    }

    return ListToCsvConverter(fieldDelimiter: ",").convert(rows);
  }

  //Utility to send email
  static void emailData(String emailBody, String emailId, String emailSubject) async {
    final Email email = Email(
      body: emailBody,
      subject: emailSubject,
      recipients: [emailId],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
  }

  //Save user preferences to app
  static saveUserPreferences(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  //Save user preferences to app
  static Future<String> getUserPreferences(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

}
