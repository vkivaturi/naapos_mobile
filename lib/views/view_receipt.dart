import 'package:flutter/material.dart';
import 'package:naapos/data/entities.dart';
import 'package:naapos/data/database_helper.dart';
import 'package:naapos/utils/utils.dart';
import 'package:naapos/utils/utils_invoice.dart';

class ViewReceipt extends StatefulWidget {
  ViewReceipt({Key key, this.title, @required this.incomingReceipt})
      : super(key: key);

  final String title;
  final Invoice incomingReceipt;

  @override
  _ViewReceiptState createState() => _ViewReceiptState();
}

class _ViewReceiptState extends State<ViewReceipt> {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  double invTotalAmt = 0;
  int invQuantity = 0;
  double invTax = 0;

  //Lists of map to store items added
  List<Item> items;

  //Below code is to accept receiptNumber from calling widget
  Invoice receipt;

  _ViewReceiptState({this.receipt});

  @override
  void initState() {
    super.initState();

    items = [];
    //Initialise receipt number to incoming receipt number, if available
    receipt = widget.incomingReceipt;

    queryForReceipt(receipt.invoiceNumber);
  }

  //Query database for the user enter item code.
  queryForReceipt(int receiptNumber) async {
    final allRows = await dbHelper.queryTRTransaction(receiptNumber);

    Item item;

    if (allRows == null) {
      HelperMethods.showMessage(
          context, Colors.red, "Receipt number is invalid");
    } else {
      for (var row in allRows) {
        item = new Item();

        item.code = row[DatabaseHelper.columnITCode];
        item.itemDetail = row[DatabaseHelper.columnITItemDetail];
        item.tax = row[DatabaseHelper.columnITTax];
        item.unitPrice = row[DatabaseHelper.columnITUnitPrice];
        item.qty = row[DatabaseHelper.columnIVinvoiceQuantity];

        items.add(item);
      }

      //Refresh the list
      setState(() {});
    }
  }

  //This is the main build method
  @override
  Widget build(BuildContext context) {
    Widget ItemsView = ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, position) {
          return Card(
              elevation: 2.0,
              child: ListTile(
                title: Text(items[position].code.toString() +
                    "    " +
                    items[position].itemDetail +
                    "    Rs. " +
                    items[position].unitPrice),
                subtitle: Text("Tax rate : " +
                    items[position].tax +
                    "%" +
                    "    Quantity : " +
                    items[position].qty),
              ));
        });

    Widget itemSummary = Card(
        color: Colors.black,
        child: ListTile(
            title: Text(
              "Tax amount (in Rs) : " + receipt.invoiceTax.toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Number of items     : " + receipt.invoiceQuantity.toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              "Rs. " + receipt.invoiceAmount.toString(),
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Receipt " + receipt.invoiceNumber.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        //backgroundColor: Color.fromRGBO(49, 87, 110, 1.0),
      ),
      body: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Column(
                children: [
                  Divider(
                    height: 2.0,
                    color: Colors.grey,
                  ),
                  itemSummary,
                  Divider(
                    height: 2.0,
                    color: Colors.grey,
                  ),
                  ItemsView,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[],
                  ),
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          if (items.length > 0) {
            Invoice invoice = InvoiceHelpers.buildInvoice(
                items, invTotalAmt, invQuantity, invTax);

            InvoiceHelpers.insert(invoice, items, dbHelper, context);

            //TODO - Resetting values without checking for success of database operation
            setState(() {
              items = [];
            });
          } else {
            HelperMethods.showMessage(context, Colors.deepOrange,
                "Please add at least 1 item to create invoice");
          }
        },
      ),
    );
  }
}
