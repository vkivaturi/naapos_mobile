import 'package:flutter/material.dart';

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
                  label: Text("ITEM DETAILS"),
                  numeric: false,
                  tooltip: "Item details",
                ),
                DataColumn(
                  label: Text("QUANTITY"),
                  numeric: false,
                  tooltip: "Item quantity",
                ),
                DataColumn(
                  label: Text("PRICE (in Rs)"),
                  numeric: false,
                  tooltip: "Tax % and Unit price",
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
//                          DataCell(
//                            Text(item.slNo),
//                            onTap: () {
//                              print('Selected ${item.slNo}');
//                            },
//                          ),
//                          DataCell(
//                            Text(item.code),
//                          ),
                          DataCell(
                            Text(item.code + "-" + item.itemDetail),
                          ),
                          DataCell(
                            Text(item.qty),
                          ),
//                          DataCell(
//                            Text(item.tax),
//                          ),
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
//    Widget createInvoice = Container(
//      padding: const EdgeInsets.all(32),
//      child: Row(
//        children: [
//          Expanded(
//            /*1*/
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: [
//                /*2*/
//                new TextField(
//                  decoration: new InputDecoration(
//                      labelText: "Enter item code",
//                      border: OutlineInputBorder()),
//                  keyboardType: TextInputType.number,
//                  controller: itemCodeController,
//                  focusNode: nodeItem,
//                ),
//                new TextField(
//                  decoration: new InputDecoration(
//                      labelText: "Enter quantity",
//                      border: OutlineInputBorder()),
//                  keyboardType: TextInputType.number,
//                  controller: qtyController,
//                ),
//                RaisedButton(
//                    onPressed: () {
//                      List<String> itemDetails =
//                          fetchItemDetails(itemCodeController.text);
//                      String _itemDesc = itemDetails[0];
//                      String _itemPrice = itemDetails[1];
//                      String _itemTaxPerc = itemDetails[2];
//
//                      litems.add(
//                        buildListItem(
//                            litems.length.toString(),
//                            itemCodeController.text,
//                            _itemDesc,
//                            qtyController.text,
//                            _itemTaxPerc,
//                            _itemPrice),
//                      );
//
//                      increaseInvTotalAmt(
//                          int.parse(_itemPrice),
//                          int.parse(qtyController.text),
//                          int.parse(_itemTaxPerc));
//
//                      setState(() {});
//
//                      itemCodeController.clear();
//                      qtyController.clear();
//                      FocusScope.of(context).requestFocus(nodeItem);
//                    },
//                    child: Text('Add item', style: TextStyle(fontSize: 25))),
//                new ListView.builder(
//                    scrollDirection: Axis.vertical,
//                    shrinkWrap: true,
//                    itemCount: litems.length,
//                    itemBuilder: (BuildContext ctxt, int Index) {
//                      return new Text(litems[Index]);
//                    })
//              ],
//            ),
//          ),
//          /*3*/
//        ],
//      ),
//    );

    Widget invoiceFooter = Container(
      padding: const EdgeInsets.all(32),
      child: Row(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: OutlineButton(
            child: Text('SELECTED ${selectedItems.length}'),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: OutlineButton(
            child: Text('DELETE SELECTED'),
            onPressed: selectedItems.isEmpty
                ? null
                : () {
                    deleteSelected();
                  },
          ),
        ),
      ]),
    );

    Widget invoiceTotal = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          new Text("rows1 " + fetchInvoiceTotal().toString()),
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
                    itemAdd.setItem("", itemCodeController.text, itemDetails[0],
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

//    Widget selectedItemsList = Container(
//        padding: const EdgeInsets.all(5),
//        child: Row(children: <Widget>[
//          new Flexible(
//              child: new ListView.builder(
//                  scrollDirection: Axis.vertical,
//                  shrinkWrap: true,
//                  itemCount: litems.length,
//                  itemBuilder: (BuildContext ctxt, int Index) {
//                    return new Text(litems[Index]);
//                  })),
//        ]));

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
              children: <Widget>[
//                Padding(
//                  padding: EdgeInsets.all(20.0),
//                  child: OutlineButton(
//                    child: Text('SELECTED ${selectedItems.length}'),
//                    onPressed: () {},
//                  ),
//                ),
//                Padding(
//                  padding: EdgeInsets.all(20.0),
//                  child: OutlineButton(
//                    child: Text('DELETE SELECTED'),
//                    onPressed: selectedItems.isEmpty
//                        ? null
//                        : () {
//                            deleteSelected();
//                          },
//                  ),
//                ),
              ],
            ),
          ],
        ),
//      bottomNavigationBar: invoiceTotal,
        persistentFooterButtons: <Widget>[invoiceFooter]);
  }
}

//Initialise list on app load
//List<String> initialiseItemList() {
//  List<String> itemsList = [];
//  itemsList.add(buildListItem(" ", " ", " ", " ", " ", " "));
//  itemsList.add(
//      buildListItem("#", "CODE", "ITEM DETAILS", "QTY", "TAX", "UNIT PRICE"));
//  itemsList.add(buildListItem(" ", " ", " ", " ", " ", " "));
//
//  return (itemsList);
//}

//Function to create the row to be included in the items view
buildListItem(String col1, String col2, String col3, String col4, String col5,
    String col6) {
  String _row = col1.padRight(5, ' ') +
      col2.padRight(15, ' ') +
      col3.padRight(25, ' ') +
      col4.padRight(4, ' ') +
      col5.padRight(5, ' ') +
      col6.padRight(5, ' ');
  return _row;
}

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

class Item {
  String slNo;
  String code;
  String itemDetail;
  String qty;
  String tax;
  String unitPrice;

  Item(
      {this.slNo,
      this.code,
      this.itemDetail,
      this.qty,
      this.tax,
      this.unitPrice});

  void setItem(String slNo, String code, String itemDetail, String qty,
      String tax, String unitPrice) {
    this.slNo = slNo;
    this.code = code;
    this.itemDetail = itemDetail;
    this.qty = qty;
    this.tax = tax;
    this.unitPrice = unitPrice;
  }

  static List<Item> getItems() {
    return <Item>[
      Item(
          slNo: "1",
          code: "100000",
          itemDetail: "Idly (3 pcs)",
          qty: "5",
          tax: "5",
          unitPrice: "3500"),
      Item(
          slNo: "1",
          code: "2000",
          itemDetail: "Idly (4 pcs)",
          qty: "4",
          tax: "1",
          unitPrice: "45"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
      Item(
          slNo: "1",
          code: "3000",
          itemDetail: "Idly (9 pcs)",
          qty: "3",
          tax: "2",
          unitPrice: "55"),
    ];
  }
}
