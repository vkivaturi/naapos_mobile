import 'package:flutter/material.dart';
import 'package:naapos/database_helper.dart';
import 'package:naapos/entities.dart';
import 'package:naapos/utils_invoice.dart';

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
  final invoiceDateController = TextEditingController();

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
    Widget searchInvoice = Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 60.0,
              child: new TextField(
                decoration: new InputDecoration(
                    hintText: "Enter invoice date",
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.datetime,
                controller: invoiceDateController,
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 60.0,
              child: RaisedButton(
                  //padding: const EdgeInsets.all(12.0),
                  textColor: Colors.white,
                  color: Colors.black,
                  onPressed: () {
                    _queryIVInvoiceRange(
                        int.parse(invoiceDateController.text + "000000"),
                        int.parse(invoiceDateController.text + "235959"));
                  },
                  child: Icon(Icons
                      .search, size: 40.0, color: Colors.blue,), ), //Text('Add item', style: TextStyle(fontSize: 25))),
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
                subtitle: Text(invoices[position].invoiceDateTime, style: TextStyle(fontSize: 15.0, color: Colors.white)),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.email),
        onPressed: () {
          //String emailBody = InvoiceHelpers.convertInvoicesListToCSV(invoices);
          String emailBody = "Email body test";
          print("Email Body @@@@ " + emailBody);
//          InvoiceHelpers.emailInvoice(emailBody, "aa");
        },
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
