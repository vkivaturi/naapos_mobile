import 'package:flutter/material.dart';
import 'package:naapos/entities.dart';
import 'package:naapos/database_helper.dart';
import 'package:naapos/utils.dart';
import 'package:naapos/utils_invoice.dart';
import 'package:intl/intl.dart';

class DownloadData extends StatefulWidget {
  DownloadData({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DownloadDataState createState() => _DownloadDataState();
}

class _DownloadDataState extends State<DownloadData> {
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  DateTime selectStartDate = DateTime.now();
  DateTime selectEndDate = DateTime.now();

  final showDateFormat = new DateFormat('dd-MMM-yyyy');
  final searchDateFormat = new DateFormat('yyyyMMdd');


  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectStartDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectStartDate)
      setState(() {
        selectStartDate = picked;
        startDateController.text = showDateFormat.format(selectStartDate.toLocal());
      });
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectEndDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectEndDate)
      setState(() {
        selectEndDate = picked;
        endDateController.text = showDateFormat.format(selectEndDate.toLocal());
      });
  }

  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    startDateController.dispose();
    endDateController.dispose();
    emailController.dispose();

    super.dispose();
  }

  void _emailData(Item item) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnITCode: item.code,
      DatabaseHelper.columnITItemDetail: item.itemDetail,
      DatabaseHelper.columnITTax: item.tax,
      DatabaseHelper.columnITUnitPrice: item.unitPrice,
    };
    print(row.toString());
    final id = await dbHelper.insertIT(row);
    print('inserted row id: $id');
  }

  //This is the main build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Download items and receipts",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.0, color: Colors.white),
          ),
          //backgroundColor: Color.fromRGBO(49, 87, 110, 1.0),
        ),
        body: Builder(
          //Added this builder only to make snackbar work
          builder: (context) => Form(
              key: _formKey,
              child: Column(
                children: [
                  Divider(
                    height: 2.0,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  new TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid email address';
                      } else
                        return null;
                    },
                    decoration: new InputDecoration(
                        labelText: "Email address",
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  new TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid date';
                      } else
                        return null;
                    },
                    onTap: () => _selectStartDate(context),
                    decoration: new InputDecoration(
                        labelText:
                            "Receipts start date (not required for item catalog)",
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                    controller: startDateController,
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  new TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid date';
                      } else
                        return null;
                    },
                    onTap: () => _selectEndDate(context),
                    decoration: new InputDecoration(
                        labelText:
                            "Receipts end date (not required for item catalog)",
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                    controller: endDateController,
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          padding: const EdgeInsets.all(12.0),
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              HelperMethods.showMessage(context, Colors.green,
                                  "Item is created successfully");
                            } else {
                              // If the form is valid, display a Snackbar.
                              HelperMethods.showMessage(
                                  context,
                                  Colors.deepOrange,
                                  "There are errors in your input data. Please fix them");
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.email),
                              Text('   Email items catalog',
                                  style: TextStyle(fontSize: 25))
                            ],
                          ))),
                  SizedBox(
                    height: 35.0,
                  ),
                  ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          padding: const EdgeInsets.all(12.0),
                          textColor: Colors.white,
                          color: Colors.pink,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              HelperMethods.showMessage(context, Colors.green,
                                  "Item is created successfully");
                            } else {
                              // If the form is valid, display a Snackbar.
                              HelperMethods.showMessage(
                                  context,
                                  Colors.deepOrange,
                                  "There are errors in your input data. Please fix them");
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.email),
                              Text('   Email seleced receipts',
                                  style: TextStyle(fontSize: 25))
                            ],
                          )))
                ],
              )),
        ));
  }
}
