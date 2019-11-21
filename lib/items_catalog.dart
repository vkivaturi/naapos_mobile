import 'package:flutter/material.dart';
import 'package:naapos/database_helper.dart';
import 'package:naapos/entities.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ManageItem extends StatefulWidget {
  ManageItem({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ManageItemState createState() => ManageItemState();
}

class ManageItemState extends State<ManageItem> {
  final itemCodeController = TextEditingController();
  final itemDetailController = TextEditingController();
  final itemTaxController = TextEditingController();
  final itemUnitPriceController = TextEditingController();

  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;
  //Lists of map to store items added
  List<Item> items;

  @override
  void initState() {
    items = [];
    super.initState();

    //Load all items initially
    _queryAll();
  }

  // homepage layout
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
                    " == " +
                    items[position].itemDetail +
                    " == Rs. " +
                    items[position].unitPrice),
                subtitle: Text("Tax rate : " + items[position].tax + "%"),
                trailing: IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 25.0,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    _editItemCustomDialog(position);
                  },
                ),
              ));
        });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage items',
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
                    Divider(
                      height: 2.0,
                      color: Colors.grey,
                    ),
                    ItemsView
                  ],
                ),
              ))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //_editItemDialog(-1);
          _editItemCustomDialog(-1);
        },
      ),
    );
  }

  _editItemCustomDialog(int position) {
    //Use the same dialog box for creation of new item or update/delete of existing item.
    bool isNewItem = position == -1 ? true : false;
    String headerText = isNewItem
        ? "Create new item"
        : "Update / delete item code " + items[position].code.toString();

    if (isNewItem) {
      headerText = "Create new item";

      itemCodeController.text = '';
      itemDetailController.text = '';
      itemTaxController.text = '';
      itemUnitPriceController.text = '';
    } else {
      headerText =
          "Update / delete item code " + items[position].code.toString();

      //Since this is the update scenario, prefill text boxes with item values
      itemCodeController.text = items[position].code.toString();
      itemDetailController.text = items[position].itemDetail;
      itemTaxController.text = items[position].tax;
      itemUnitPriceController.text = items[position].unitPrice;
    }

    return Alert(
        context: context,
        title: headerText,
        content: Column(
          children: <Widget>[
            Visibility(
                visible: isNewItem,
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.adjust),
                    labelText: 'Item code (number only)',
                  ),
                  keyboardType: TextInputType.number,
                  controller: itemCodeController,
                )),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.adjust),
                labelText: 'Item description',
              ),
              keyboardType: TextInputType.text,
              controller: itemDetailController,
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.adjust),
                labelText: 'Tax % (number only)',
              ),
              keyboardType: TextInputType.number,
              controller: itemTaxController,
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.adjust),
                labelText: 'Unit price (number only)',
              ),
              keyboardType: TextInputType.number,
              controller: itemUnitPriceController,
            ),
          ],
        ),
        buttons: [
          DialogButton(
//            onPressed: () => Navigator.pop(context),
            child: Visibility(
                visible: isNewItem,
                child: Text(
                  "CREATE ITEM",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
            onPressed: () {
              Item uItem = new Item();

              uItem.unitPrice = itemUnitPriceController.text;
              uItem.tax = itemTaxController.text;
              uItem.itemDetail = itemDetailController.text;
              //Fetch code value from user entered data. Item code is read-only in update and delete cases.
              uItem.code = int.parse(itemCodeController.text);

              _insert(uItem);

              setState(() {
                //items[position] = uItem;
                _queryAll();
              });

              Navigator.of(context, rootNavigator: true).pop();
            },
          ),          DialogButton(
//            onPressed: () => Navigator.pop(context),
            child: Visibility(
                visible: !isNewItem,
                child: Text(
                  "UPDATE ITEM",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
            onPressed: () {
              Item uItem = new Item();

              uItem.unitPrice = itemUnitPriceController.text;
              uItem.tax = itemTaxController.text;
              uItem.itemDetail = itemDetailController.text;
              uItem.code =
                  int.parse(items[position].code.toString());

              _update(uItem);

              setState(() {
                //items[position] = uItem;
                _queryAll();
              });

              Navigator.of(context, rootNavigator: true)
                  .pop();

            },
          ),          DialogButton(
//            onPressed: () => Navigator.pop(context),
            child: Visibility(
                visible: isNewItem,
                child: Text(
                  "CREATE ITEM",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
            onPressed: () {
              Item uItem = new Item();

              uItem.unitPrice = itemUnitPriceController.text;
              uItem.tax = itemTaxController.text;
              uItem.itemDetail = itemDetailController.text;
              //Fetch code value from user entered data. Item code is read-only in update and delete cases.
              uItem.code = int.parse(itemCodeController.text);

              _insert(uItem);

              setState(() {
                //items[position] = uItem;
                _queryAll();
              });

              Navigator.of(context, rootNavigator: true).pop();
            },
          )


        ]).show();
  }

  //Dialog box for edit or delete items based on user input
  _editItemDialog(int position) {
    //Use the same dialog box for creation of new item or update/delete of existing item.
    bool isNewItem = position == -1 ? true : false;
    String headerText = isNewItem
        ? "Create new item"
        : "Update / delete item code " + items[position].code.toString();

    if (isNewItem) {
      headerText = "Create new item";

      itemCodeController.text = '';
      itemDetailController.text = '';
      itemTaxController.text = '';
      itemUnitPriceController.text = '';
    } else {
      headerText =
          "Update / delete item code " + items[position].code.toString();

      //Since this is the update scenario, prefill text boxes with item values
      itemCodeController.text = items[position].code.toString();
      itemDetailController.text = items[position].itemDetail;
      itemTaxController.text = items[position].tax;
      itemUnitPriceController.text = items[position].unitPrice;
    }

    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(headerText),
              content: new Column(
                children: <Widget>[
                  Visibility(
                    visible: isNewItem,
                    child: new TextField(
                      decoration: new InputDecoration(
                          labelText: "Item code (numbers only)",
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      controller: itemCodeController,
                    ),
                  ),
                  new TextField(
                    decoration: new InputDecoration(
                        labelText: "Item details",
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                    controller: itemDetailController,
                  ),
                  new TextField(
                    decoration: new InputDecoration(
                        labelText: "Tax", border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    controller: itemTaxController,
                  ),
                  new TextField(
                    decoration: new InputDecoration(
                        labelText: "Unit price", border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    controller: itemUnitPriceController,
                  ),
                  new Row(children: <Widget>[
                    Visibility(
                      visible: isNewItem,
                      child: new Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              size: 40.0,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              Item uItem = new Item();

                              uItem.unitPrice = itemUnitPriceController.text;
                              uItem.tax = itemTaxController.text;
                              uItem.itemDetail = itemDetailController.text;
                              //Fetch code value from user entered data. Item code is read-only in update and delete cases.
                              uItem.code = int.parse(itemCodeController.text);

                              _insert(uItem);

                              setState(() {
                                //items[position] = uItem;
                                _queryAll();
                              });

                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                          new Text('Create item'),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: !isNewItem,
                        child: new Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.check_circle,
                                size: 40.0,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () {
                                Item uItem = new Item();

                                uItem.unitPrice = itemUnitPriceController.text;
                                uItem.tax = itemTaxController.text;
                                uItem.itemDetail = itemDetailController.text;
                                uItem.code =
                                    int.parse(items[position].code.toString());

                                _update(uItem);

                                setState(() {
                                  //items[position] = uItem;
                                  _queryAll();
                                });

                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                            new Text('Update item'),
                          ],
                        )),
                    Visibility(
                        visible: !isNewItem,
                        child: new Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 40.0,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _delete(items[position].code);

                                setState(() {
                                  //items.remove(position);
                                  _queryAll();
                                });

                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                            new Text('Delete item'),
                          ],
                        ))
                  ]),
                ],
              ),
            ));
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryITAllRows();
    print('query all rows:');
    items = [];
    allRows.forEach((row) => _addItemToList(row));

    //Refresh screen with items list since this function is an async one
    setState(() {});
  }

  void _addItemToList(Map<String, Object> row) {
    Item item = new Item();
    item.code = int.parse(row["code"]);
    item.itemDetail = row["itemDetail"];
    item.tax = row["tax"];
    item.unitPrice = row["unitPrice"];
    items.add(item);
  }

  void _update(Item item) async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnITCode: item.code,
      DatabaseHelper.columnITItemDetail: item.itemDetail,
      DatabaseHelper.columnITTax: item.tax,
      DatabaseHelper.columnITUnitPrice: item.unitPrice,
    };

    final rowsAffected = await dbHelper.updateIT(row);
//    print('updated $rowsAffected row(s)');
  }

  void _insert(Item item) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnITCode: item.code,
      DatabaseHelper.columnITItemDetail: item.itemDetail,
      DatabaseHelper.columnITTax: item.tax,
      DatabaseHelper.columnITUnitPrice: item.unitPrice,
    };
    print(row.toString());
    final id = await dbHelper.insertIT(row);
    print('inserted row id: $id');
  }

  void _delete(int id) async {
    final rowsDeleted = await dbHelper.deleteIT(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}
