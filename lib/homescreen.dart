import 'package:flutter/material.dart';
import 'package:naapos/entities.dart';
import 'package:naapos/database_helper.dart';
import 'package:naapos/utils.dart';

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
    //selectedItems = [];
    //   items = Item.getItems();
    items = [];
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
      HelperMethods.showMessage(context, Colors.red, "Item code is invalid. Please add it to the item catalog");
      //print("Item code is invalid. Please add it to the item catalog first");
    } else if (allRows.length != 1) {
      HelperMethods.showMessage(context, Colors.red, "Item code has multiple items. Please correct the item catalog");

//      print(
//          "Item code has multiple items. Please correct the item catalog first");
    } else {
      print("1 row returned");
      Map<String, Object> row = allRows.elementAt(0);
      item = new Item();
      item.code = int.parse(row["code"]);
      item.itemDetail = row["itemDetail"];
      item.tax = row["tax"];
      item.unitPrice = row["unitPrice"];
      item.qty = qty;
//      items.add(item);

      double transactionAmount = calculateTransactionAmt(
          int.parse(item.unitPrice),
          int.parse(qty),
          int.parse(item.tax));

      //Add transactiona amount to the invoice total
      increaseInvTotalAmt(
          transactionAmount, int.parse(qty), int.parse(item.tax));

      items.add(item);

      //Refresh the list
      setState(() {});

    }
    //Refresh screen with items list since this function is an async one
//    setState(() {});
    //return item;


  }

  //Fetch item details based on code
//  List<String> fetchItemDetails(String _code) {
//    //Mock code to create static items list
//    //Item description, Unit price, Tax percentage
//
//    Map<String, List<String>> itemMaster = new Map();
//    itemMaster['1000'] = ['Idly (3 pcs)', '30', '5'];
//    itemMaster['1100'] = ['Idly vada combo', '25', '5'];
//    itemMaster['2000'] = ['Upma', '30', '5'];
//    itemMaster['2100'] = ['Pongal', '30', '5'];
//    itemMaster['3000'] = ['Tea', '10', '5'];
//    itemMaster['3100'] = ['Cofee', '10', '5'];
//    itemMaster['4000'] = ['Dosa - plain', '30', '5'];
//    itemMaster['4100'] = ['Dosa - masala', '35', '5'];
//    itemMaster['4200'] = ['Dosa - onion', '40', '5'];
//    itemMaster['4300'] = ['Dosa - egg', '40', '5'];
//
//    return itemMaster[_code];
//  }

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
                "    Quantity : "
                +
                items[position].qty
            ),
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
              "Tax amount (in Rs) : " + fetchInvoiceTax().toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Number of items     : " + fetchInvoiceQuantity().toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              "Rs. " + fetchInvoiceTotal().toString(),
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
//                    List<String> itemDetails =
//                        fetchItemDetails(itemCodeController.text);
//                    String _itemDesc = itemDetails[0];
//                    String _itemPrice = itemDetails[1];
//                    String _itemTaxPerc = itemDetails[2];
//
//                    double transactionAmount = calculateTransactionAmt(
//                        int.parse(_itemPrice),
//                        int.parse(qtyController.text),
//                        int.parse(_itemTaxPerc));
//
//                    Item itemAdd = new Item();
//                    itemAdd.setItem(
//                        "",
//                        int.parse(itemCodeController.text),
//                        itemDetails[0],
//                        qtyController.text,
//                        itemDetails[2],
//                        itemDetails[1],
//                        transactionAmount.toString());
//                    double transactionAmount = calculateTransactionAmt(
//                        int.parse(itemAdd.unitPrice),
//                        int.parse(qtyController.text),
//                        int.parse(itemAdd.tax));
//
//                    items.add(itemAdd);
//
//                    //Add transactiona amount to the invoice total
//                    increaseInvTotalAmt(transactionAmount,
//                        int.parse(qtyController.text), int.parse(itemAdd.tax));

//                    setState(() {});

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
          HelperMethods.showMessage(context, Colors.blue, "Save invoice feature is not yet implemented");
        },
      ),
    );
  }
}
