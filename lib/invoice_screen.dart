import 'package:flutter/material.dart';
import 'package:naapos/database_helper.dart';
import 'package:naapos/entities.dart';

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

  @override
  void initState() {
    invoices = [];
    super.initState();

    //Load all items initially
    _queryIVAll();
  }

  // homepage layout
  @override
  Widget build(BuildContext context) {
    Widget ItemsView = ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: invoices.length,
        itemBuilder: (context, position) {
          return Card(
              child: ListTile(
            title: Text(invoices[position].invoiceNumber.toString() +
                "    " +
                "    Rs. " +
                invoices[position].invoiceAmount.toString()),
            subtitle: Text(invoices[position].invoiceDateTime),
            trailing: IconButton(
              icon: Icon(
                Icons.receipt,
                size: 25.0,
                color: Colors.purple,
              ),
              onPressed: () {
                _viewInvoiceDialog(position);
              },
            ),
          ));
        });

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage invoices'),
        backgroundColor: Color.fromRGBO(49, 87, 110, 1.0),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Divider(
              height: 2.0,
              color: Colors.grey,
            ),
            ItemsView
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.email),
        onPressed: () {},
      ),
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
                  new Text(invoices[position].transactionsCSV),
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

  void _addInvoiceToList(Map<String, Object> row) {
    Invoice invoice = new Invoice();
    invoice.transactionsCSV = row["transactions"];
    invoice.invoiceQuantity = int.parse(row["invoiceQuantity"]);
    invoice.invoiceTax = double.parse(row["invoiceTax"]);
    invoice.invoiceAmount = double.parse(row["invoiceAmount"]);
    invoice.invoiceNumber = row["invoiceNumber"];
    invoice.operatorId = row["operatorId"];
    invoice.storeId = row["storeId"];
    invoice.invoiceDateTime = row["invoiceDateTime"];

    invoices.add(invoice);
  }
}
