import 'package:flutter/material.dart';
import 'package:naapos/entities.dart';

class NaaPOSHome extends StatefulWidget {
  NaaPOSHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NaaPOSHomeState createState() => _NaaPOSHomeState();
}

class _NaaPOSHomeState extends State<NaaPOSHome> {
  final itemCodeController = TextEditingController();
  final qtyController = TextEditingController();

  //Initiatise invoice items list with header row
  //List<String> litems = initialiseItemList();

  double invTotalAmt = 0;

  // Bring focus back to item text field field after adding an item
  FocusNode nodeItem = FocusNode();

  //Lists of map to store items added
  List<Item> items;
  List<Item> selectedItems;

  @override
  void initState() {
    selectedItems = [];
    //   items = Item.getItems();
    items = [];
    super.initState();
  }

  onSelectedRow(bool selected, Item item) async {
    setState(() {
      if (selected) {
        selectedItems.add(item);
      } else {
        selectedItems.remove(item);
      }
    });
  }

  deleteSelected() async {
    setState(() {
      if (selectedItems.isNotEmpty) {
        List<Item> temp = [];
        temp.addAll(selectedItems);
        for (Item item in temp) {
          items.remove(item);
          selectedItems.remove(item);
        }
      }
    });
  }

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            child: Row(children: [
          Expanded(
            child: DataTable(
              columnSpacing: 0,
              columns: [
                DataColumn(
                  label: Text(
                    "ITEM DETAILS",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  numeric: false,
                ),
                DataColumn(
                  label: Text(
                    "QUANTITY",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  numeric: false,
                ),
                DataColumn(
                  label: Text(
                    "PRICE (in Rs)",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  numeric: false,
                ),
              ],
              rows: items
                  .map(
                    (item) => DataRow(
                        selected: selectedItems.contains(item),
                        onSelectChanged: (b) {
                          print("Onselect");
                          onSelectedRow(b, item);
                        },
                        cells: [
                          DataCell(
                            Text(item.code.toString() + "-" + item.itemDetail),
                          ),
                          DataCell(
                            Center(
                                child: Text(
                              item.qty,
                              textAlign: TextAlign.center,
                            )),
                          ),
                          DataCell(
                            Text(item.tax + "% + " + item.unitPrice),
                          ),
                        ]),
                  )
                  .toList(),
            ),
          )
        ])));
  }

  void increaseInvTotalAmt(int itemAmt, int itemQty, int taxPerc) {
    setState(() {
      invTotalAmt = invTotalAmt + (itemAmt * itemQty * (1 + (taxPerc / 100)));
    });
  }

  fetchInvoiceTotal() {
    return invTotalAmt;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    itemCodeController.dispose();
    qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget invoiceFooter = Container(
      padding: const EdgeInsets.all(32),
      child: Row(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: OutlineButton(
            child: Text('DELETE SELECTED', style: TextStyle(fontSize: 15)),
            onPressed: selectedItems.isEmpty
                ? null
                : () {
                    deleteSelected();
                  },
          ),
        ),
        RaisedButton(
          //padding: const EdgeInsets.all(12.0),
          textColor: Colors.white,
          color: Colors.green,

          child: Text('CREATE INVOICE', style: TextStyle(fontSize: 15)),
        ),
      ]),
    );

    Widget invoiceTotal = Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          new Text(
            "Invoice total (with tax) is : ",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.blueAccent,
            ),
          ),
          new Text(
            "" + fetchInvoiceTotal().toString(),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.blueAccent,
            ),
          )
        ],
      ),
    );

    Widget selectItem = Container(
        padding: const EdgeInsets.all(10),
        child: Row(
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
                  //padding: const EdgeInsets.all(12.0),
                  textColor: Colors.white,
                  color: Colors.green,
                  onPressed: () {
                    List<String> itemDetails =
                        fetchItemDetails(itemCodeController.text);
                    String _itemDesc = itemDetails[0];
                    String _itemPrice = itemDetails[1];
                    String _itemTaxPerc = itemDetails[2];

                    Item itemAdd = new Item();
                    itemAdd.setItem("", int.parse(itemCodeController.text), itemDetails[0],
                        qtyController.text, itemDetails[2], itemDetails[1]);
                    items.add(itemAdd);

                    increaseInvTotalAmt(int.parse(_itemPrice),
                        int.parse(qtyController.text), int.parse(_itemTaxPerc));

                    setState(() {});

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
          title: Text("Create Invoice"),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Create Invoice'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('View invoices'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Manage items'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Settings'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),

            ],
          ),
        ),
        body: Column(
          children: [
            selectItem,
//          selectedItemsList,
            invoiceTotal,
            dataBody(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[],
            ),
          ],
        ),
        persistentFooterButtons: <Widget>[invoiceFooter]);
  }
}

//Function to create the row to be included in the items view
//buildListItem(String col1, String col2, String col3, String col4, String col5,
//    String col6) {
//  String _row = col1.padRight(5, ' ') +
//      col2.padRight(15, ' ') +
//      col3.padRight(25, ' ') +
//      col4.padRight(4, ' ') +
//      col5.padRight(5, ' ') +
//      col6.padRight(5, ' ');
//  return _row;
//}

//Fetch item details based on code
List<String> fetchItemDetails(String _code) {
  //Mock code to create static items list
  //Item description, Unit price, Tax percentage

  Map<String, List<String>> itemMaster = new Map();
  itemMaster['1000'] = ['Idly (3 pcs)', '30', '5'];
  itemMaster['1100'] = ['Idly (2 pcs) vada (1 pc) combo', '25', '5'];
  itemMaster['2000'] = ['Upma', '30', '5'];
  itemMaster['2100'] = ['Pongal', '30', '5'];
  itemMaster['3000'] = ['Tea', '10', '5'];
  itemMaster['3100'] = ['Cofee', '10', '5'];
  itemMaster['4000'] = ['Dosa - plain', '30', '5'];
  itemMaster['4100'] = ['Dosa - masala', '35', '5'];
  itemMaster['4200'] = ['Dosa - onion', '40', '5'];
  itemMaster['4300'] = ['Dosa - egg', '40', '5'];

  return itemMaster[_code];
}

