import 'package:flutter/material.dart';
import 'package:naapos/entities.dart';
import 'package:naapos/database_helper.dart';
import 'package:naapos/utils.dart';
import 'package:naapos/utils_invoice.dart';

class NaaPOSHome extends StatefulWidget {
  NaaPOSHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NaaPOSHomeState createState() => _NaaPOSHomeState();
}

class _NaaPOSHomeState extends State<NaaPOSHome> {
  final itemCodeController = TextEditingController();
  final qtyController = TextEditingController();

  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  double invTotalAmt = 0;
  int invQuantity = 0;
  double invTax = 0;

  // Bring focus back to item text field field after adding an item
  FocusNode nodeItem = FocusNode();

  //Lists of map to store items added
  List<Item> items;
//  List<Item> selectedItems;

  @override
  void initState() {
    items = [];
    double invTotalAmt = 0;
    int invQuantity = 0;
    double invTax = 0;

    super.initState();
  }

  //Increase invoice total amount, total tax and quantity of items
  void increaseInvTotalAmt(double transactionAmount, int itemQty, int taxPerc) {
    setState(() {
      invTotalAmt = invTotalAmt + transactionAmount;
      invTax = invTax + (transactionAmount * taxPerc / 100);
      invQuantity = invQuantity + itemQty;
    });
  }

//Decrease all summary amounts when an items is deleted from draft invoice.
  void decreaseInvTotalAmt(double transactionAmount, int itemQty, int taxPerc) {
    setState(() {
      invTotalAmt = invTotalAmt - transactionAmount;
      invTax = invTax - (transactionAmount * taxPerc / 100);
      invQuantity = invQuantity - itemQty;
    });
  }

  double calculateTransactionAmt(int itemAmt, int itemQty, int taxPerc) {
    return (itemAmt * itemQty * (1 + (taxPerc / 100)));
  }

  fetchInvoiceTotal() {
    return invTotalAmt;
  }

  fetchInvoiceQuantity() {
    return invQuantity;
  }

  fetchInvoiceTax() {
    return invTax;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    itemCodeController.dispose();
    qtyController.dispose();
    super.dispose();
  }

  //Query database for the user enter item code.
  queryForItem(String _code, String qty) async {
    final allRows = await dbHelper.queryITCode(int.parse(_code));
    print('query one row :' + _code);
    Item item;

    if (allRows == null) {
      HelperMethods.showMessage(context, Colors.red,
          "Item code is invalid. Please add it to the item catalog");
    } else if (allRows.length != 1) {
      HelperMethods.showMessage(context, Colors.red,
          "Item code has multiple items. Please correct the item catalog");
    } else {
      Map<String, Object> row = allRows.elementAt(0);

      item = new Item();
      item.code = int.parse(row["code"]);
      item.itemDetail = row["itemDetail"];
      item.tax = row["tax"];
      item.unitPrice = row["unitPrice"];
      item.qty = qty;

      double transactionAmount = calculateTransactionAmt(
          int.parse(item.unitPrice), int.parse(qty), int.parse(item.tax));
      item.transactionPrice = transactionAmount.toString();

      //Add transactions amount to the invoice total
      increaseInvTotalAmt(
          transactionAmount, int.parse(qty), int.parse(item.tax));

      items.add(item);

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
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                size: 25.0,
                color: Colors.red,
              ),
              onPressed: () {
                //Remove the item and set state so that screen refreshes with latest data
                setState(() {
                  double transactionAmount = calculateTransactionAmt(
                      int.parse(items[position].unitPrice),
                      int.parse(items[position].qty),
                      int.parse(items[position].tax));

                  decreaseInvTotalAmt(
                      transactionAmount,
                      int.parse(items[position].qty),
                      int.parse(items[position].tax));

                  items.removeAt(position);
                });
              },
            ),
          ));
        });

    Widget itemSummary = Card(
        color: Colors.lightBlueAccent,
        child: ListTile(
            title: Text(
              "Tax amount (in Rs) : " + invTax.toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Number of items     : " + invQuantity.toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              "Rs. " + invTotalAmt.toString(),
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )));

    Widget selectItem = Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration: new InputDecoration(
                    labelText: "Enter item code", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                controller: itemCodeController,
                focusNode: nodeItem,
              ),
            ),
            new Flexible(
              child: new TextField(
                decoration: new InputDecoration(
                    labelText: "Enter quantity", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                controller: qtyController,
              ),
            ),
            new Flexible(
              child: RaisedButton(
                  padding: const EdgeInsets.all(12.0),
                  textColor: Colors.white,
                  color: Colors.green,
                  onPressed: () {
                    queryForItem(itemCodeController.text, qtyController.text);

                    itemCodeController.clear();
                    qtyController.clear();
                    FocusScope.of(context).requestFocus(nodeItem);
                  },
                  child: Text('Add item', style: TextStyle(fontSize: 25))),
            )
          ],
        ));

    return Scaffold(
      appBar: AppBar(
        title: Text("Customer billing"),
        backgroundColor: Color.fromRGBO(49, 87, 110, 1.0),
      ),
      body: Column(
        children: [
          selectItem,
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          if (items.length > 0) {
            Invoice invoice = InvoiceHelpers.buildInvoice(items);
            invoice.invoiceAmount = invTotalAmt;
            invoice.invoiceQuantity = invQuantity;
            invoice.invoiceTax = invTax;

            InvoiceHelpers.insert(invoice, dbHelper, context);

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
