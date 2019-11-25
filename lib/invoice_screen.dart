import 'package:flutter/material.dart';
import 'package:naapos/database_helper.dart';
import 'package:naapos/entities.dart';
import 'package:naapos/utils_invoice.dart';
import 'package:intl/intl.dart';

class ManageInvoice extends StatefulWidget {
  ManageInvoice({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ManageInvoiceState createState() => ManageInvoiceState();
}

class ManageInvoiceState extends State<ManageInvoice> {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;
  //Lists of map to store invoices
  List<Invoice> invoices;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  DateTime selectStartDate = DateTime.now();
  DateTime selectEndDate = DateTime.now();

  final showDateFormat = new DateFormat('dd-MMM-yyyy');
  final searchDateFormat = new DateFormat('yyyyMMdd');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    startDateController.dispose();
    endDateController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    invoices = [];

    startDateController.text = showDateFormat.format(selectStartDate.toLocal());
    endDateController.text = showDateFormat.format(selectEndDate.toLocal());

    super.initState();
    //Load items initially for the current date
    _queryIVInvoiceRange(
        int.parse(searchDateFormat
            .format(selectStartDate.toLocal()) + "000000"),
        int.parse(searchDateFormat
            .format(selectEndDate.toLocal()) + "235959"));

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

  // homepage layout
  @override
  Widget build(BuildContext context) {
    Widget searchInvoice = Container(
        padding: const EdgeInsets.all(2),
        child: Row(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: new TextFormField(
                  validator: (String value) {
                    //Validate that start date is not greater that end date
                    if (value.isEmpty) {
                      return 'Please enter a valid date';
                    } else if (selectStartDate.millisecondsSinceEpoch >
                        selectEndDate.millisecondsSinceEpoch) {
                      return 'Start date for search should be less than end date';
                    } else {
                      return null;
                    }
                  },
                  onTap: () => _selectStartDate(context),
                  decoration: new InputDecoration(
                      labelText: "Receipts start date",
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  controller: startDateController,
                )),
            SizedBox(width: 10.0,),
            Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: new TextFormField(
                  validator: (String value) {
                    //Validate that start date is not greater that end date
                    if (value.isEmpty) {
                      return 'Please enter a valid date';
                    } else if (selectStartDate.millisecondsSinceEpoch >
                        selectEndDate.millisecondsSinceEpoch) {
                      return 'Start date for search should be less than end date';
                    } else {
                      return null;
                    }
                  },
                  onTap: () => _selectEndDate(context),
                  decoration: new InputDecoration(
                      labelText: "Receipts start date",
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  controller: endDateController,
                )),
            new Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: 60.0,
              child: RaisedButton(
                //padding: const EdgeInsets.all(12.0),
                textColor: Colors.white,
                color: Colors.black,
                onPressed: () {
                  //Convert start and end date to yyyyMMddHHmmss format and search
                    _queryIVInvoiceRange(
                        int.parse(searchDateFormat
                            .format(selectStartDate.toLocal()) + "000000"),
                        int.parse(searchDateFormat
                            .format(selectEndDate.toLocal()) + "235959"));
                },
                child: Icon(
                  Icons.search,
                  size: 40.0,
                  color: Colors.blue,
                ),
              ), //Text('Add item', style: TextStyle(fontSize: 25))),
            )
          ],
        ));

    Widget ItemsView = ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: invoices.length,
        itemBuilder: (context, position) {
          return Card(
              //color: Colors.grey,
              elevation: 2.0,
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  width: 120.0,
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 5.0, color: Colors.white24))),
                  child: Text(
                      "Rs. " + invoices[position].invoiceAmount.toString(),
                      style: TextStyle(fontSize: 20.0, color: Colors.white)),
                ),
                title: Text(invoices[position].invoiceNumber.toString(),
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
                subtitle: Text(invoices[position].invoiceDateTime,
                    style: TextStyle(fontSize: 15.0, color: Colors.white)),
                trailing: IconButton(
                  icon: Icon(Icons.keyboard_arrow_right,
                      color: Colors.white, size: 30.0),
                  onPressed: () {
                    _viewInvoiceDialog(position);
                  },
                ),
              ));
        });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage invoices',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25.0, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    searchInvoice,
                    Divider(
                      height: 2.0,
                      color: Colors.grey,
                    ),
                    ItemsView
                  ],
                ),
              ))),
    );
  }

  //View the selected invoice
  _viewInvoiceDialog(int position) {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Transactions in invoice " +
                  invoices[position].invoiceNumber.toString()),
              content: new Column(
                children: <Widget>[
                  new TextField(
                    decoration: new InputDecoration(
                        labelText: "Unit price", border: OutlineInputBorder()),
                  ),
                  new Row(children: <Widget>[
                    Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            size: 40.0,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                        new Text('Create item'),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.check_circle,
                            size: 40.0,
                            color: Colors.deepPurple,
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                        new Text('Update item'),
                      ],
                    ),
                  ]),
                ],
              ),
            ));
  }

  void _queryIVAll() async {
    final allRows = await dbHelper.queryIVAllRows();
    invoices = [];
    allRows.forEach((row) => _addInvoiceToList(row));

    //Refresh screen with invoices list since this function is an async one
    setState(() {});
  }

  void _queryIVInvoiceRange(int startInv, int endInv) async {
    //startInv = 20191120125350;
    //endInv = 20191120125350;

    final allRows = await dbHelper.queryIVInvoiceRange(startInv, endInv);
    invoices = [];
    allRows.forEach((row) => _addInvoiceToList(row));

    //Refresh screen with invoices list since this function is an async one
    setState(() {});
  }

  void _addInvoiceToList(Map<String, Object> row) {
    Invoice invoice = new Invoice();

//    invoice.transactionsCSV = row["transactions"];
    invoice.invoiceQuantity = int.parse(row["invoiceQuantity"]);
    invoice.invoiceTax = double.parse(row["invoiceTax"]);
    invoice.invoiceAmount = double.parse(row["invoiceAmount"]);
    invoice.invoiceNumber = row["invoiceNumber"];
    invoice.operatorId = row["operatorId"];
    invoice.storeId = row["storeId"];
    invoice.invoiceDateTime = row["invoiceDateTime"];

    print(invoice.toString());

    invoices.add(invoice);
  }
}
