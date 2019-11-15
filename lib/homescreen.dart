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
  List<String> litems = initialiseItemList();
  double invTotalAmt = 0;

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
    Widget createInvoice = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                new TextField(
                  decoration: new InputDecoration(labelText: "Enter item code"),
                  keyboardType: TextInputType.number,
                  controller: itemCodeController,
                ),
                new TextField(
                  decoration: new InputDecoration(labelText: "Enter quantity"),
                  keyboardType: TextInputType.number,
                  controller: qtyController,
                ),
                RaisedButton(
                    onPressed: () {

                      List<String> itemDetails = fetchItemDetails(itemCodeController.text);
                      String _itemDesc = itemDetails[0];
                      String _itemPrice = itemDetails[1];
                      String _itemTaxPerc = itemDetails[2];

                      litems.add(
                        buildListItem(
                            litems.length.toString(),
                            itemCodeController.text,
                            _itemDesc,
                            qtyController.text,
                            _itemTaxPerc,
                            _itemPrice),
                      );

                      increaseInvTotalAmt(
                          int.parse(_itemPrice),
                          int.parse(qtyController.text),
                          int.parse(_itemTaxPerc));

                      setState(() {});

                      itemCodeController.clear();
                      qtyController.clear();
                    },
                    child: Text('Add item', style: TextStyle(fontSize: 25))),
                new ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: litems.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return new Text(litems[Index]);
                    })
              ],
            ),
          ),
          /*3*/
        ],
      ),
    );

    Widget invoiceTotal = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [new Text("rows1 " + fetchInvoiceTotal().toString())],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [createInvoice],
      ),
      bottomNavigationBar: invoiceTotal,
    );
  }
}

//Initialise list on app load
List<String> initialiseItemList() {
  List<String> itemsList = [];
  itemsList.add(buildListItem(" ", " ", " ", " ", " ", " "));
  itemsList.add(
      buildListItem("#", "CODE", "ITEM DETAILS", "QTY", "TAX", "UNIT PRICE"));
  itemsList.add(buildListItem(" ", " ", " ", " ", " ", " "));

  return (itemsList);
}

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
