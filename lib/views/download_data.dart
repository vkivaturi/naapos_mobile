import 'package:flutter/material.dart';
import 'package:naapos/data/database_helper.dart';
import 'package:naapos/utils/utils.dart';
import 'package:naapos/utils/utils_download.dart';
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

  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    startDateController.text = showDateFormat.format(selectStartDate.toLocal());
    endDateController.text = showDateFormat.format(selectEndDate.toLocal());

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

  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectStartDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectStartDate)
      setState(() {
        selectStartDate = picked;
        startDateController.text =
            showDateFormat.format(selectStartDate.toLocal());
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
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Builder(
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
                              //Validate that start date is not greater that end date
                              if (value.isEmpty) {
                                return 'Please enter a valid date';
                              } else if (selectStartDate
                                      .millisecondsSinceEpoch >
                                  selectEndDate.millisecondsSinceEpoch) {
                                return 'Start date for search should be less than end date';
                              } else {
                                return null;
                              }
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
                                      //Send email
                                      DownloadHelpers.emailItemData(
                                          dbHelper, emailController.text);

                                      HelperMethods.showMessage(
                                          context,
                                          Colors.green,
                                          "Item catalog is emailed to " +
                                              emailController.text);
                                    } else {
                                      // If the form is valid, display a Snackbar.
                                      HelperMethods.showMessage(
                                          context,
                                          Colors.deepOrange,
                                          "There are errors in your input data. Please correct them");
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.email),
                                      Text('   Email list of items',
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
                                      int startInv = int.parse(searchDateFormat
                                          .format(selectStartDate.toLocal()));
                                      int endInv = int.parse(searchDateFormat
                                          .format(selectEndDate.toLocal()));

                                      //Send email
                                      DownloadHelpers.emailInvoiceData(
                                          dbHelper,
                                          emailController.text,
                                          startInv,
                                          endInv);

                                      HelperMethods.showMessage(
                                          context,
                                          Colors.green,
                                          "Receipts list is emailed to " +
                                              emailController.text);
                                    } else {
                                      // If the form is valid, display a Snackbar.
                                      HelperMethods.showMessage(
                                          context,
                                          Colors.deepOrange,
                                          "There are errors in your input data. Please correct them");
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.email),
                                      Text('   Email list of receipts',
                                          style: TextStyle(fontSize: 25))
                                    ],
                                  )))
                        ],
                      )),
                ))));
  }
}
