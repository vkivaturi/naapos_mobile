import 'package:flutter/material.dart';
import 'package:naapos/data/entities.dart';
import 'package:naapos/data/database_helper.dart';
import 'package:naapos/utils/utils.dart';
import 'package:naapos/utils/utils_download.dart';

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

  //Set email id from shared preferences
  String emailIdPreference;
  Future getEmailFromPreferences() async {
    emailIdPreference =
    await HelperMethods.getUserPreferences(Constants.emailId);
  }

  @override
  void initState() {
    super.initState();

    getEmailFromPreferences();

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

        item.code = row[DatabaseHelper.columnCode];
        item.itemDetail = row[DatabaseHelper.columnItemDetail];
        item.tax = row[DatabaseHelper.columnTax];
        item.unitPrice = row[DatabaseHelper.columnUnitPrice];
        item.qty = row[DatabaseHelper.columnInvoiceQuantity];

        items.add(item);
      }

      //Refresh the list
      setState(() {});
    }
  }

  //Delete selected receipt and all corresponding transactions
  void _delete(int id) async {
    final rowsDeleted = await dbHelper.deleteIV(id);
//    print('deleted $rowsDeleted row(s): row $id');

    final rowsTransactionsDeleted = await dbHelper.deleteTR(id);
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
            style: TextStyle(fontSize: 20.0, color: Colors.pink),
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
                  ],
                ))),
        floatingActionButton: Builder(
          //Added this builder only to make snackbar work
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: IconButton(
                  onPressed: () {
                    //Send email
                    DownloadHelpers.emailInvoiceData(dbHelper, emailIdPreference,
                        receipt.invoiceNumber, receipt.invoiceNumber);

                    HelperMethods.showMessage(context, Colors.green,
                        "Receipts list is emailed to " + emailIdPreference);
                  },
                  icon: Icon(
                    Icons.email,
                    size: 40.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              Container(
                child: IconButton(
                  color: Colors.black,
                  onPressed: () {
                    _delete(receipt.invoiceNumber);

                    //Go back to the receipt list page
                    Navigator.of(context, rootNavigator: true).pop();

                    HelperMethods.showMessage(
                        context, Colors.green, "Receipts is deleted");
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 40.0,
                    color: Colors.red,
                  ),
                ), //Text('Add item', style: TextStyle(fontSize: 25))),
              )
            ],
          ),
        ));
  }
}
