import 'package:flutter/material.dart';
import 'package:naapos/database_helper.dart';
import 'package:naapos/entities.dart';

class ManageItem extends StatefulWidget {
  ManageItem({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ManageItemState createState() => ManageItemState();
}

class ManageItemState extends State<ManageItem> {
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
  }

  // homepage layout
  @override
  Widget build(BuildContext context) {
    _queryAll();

    Widget abc = ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, position) {
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                      child: Text(
                        //sendersList[position],
                        "[" +
                            items[position].code.toString() +
                            "] " +
                            items[position].itemDetail,
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                      child: Text(
                        //subjectList[position],
                        "Tax rate : " + items[position].tax + "%",
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Rs " + items[position].unitPrice,
                        style: TextStyle(color: Colors.black),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 25.0,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              _editItemDialog(position);
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              height: 2.0,
              color: Colors.grey,
            )
          ],
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage items'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            abc,
            RaisedButton(
              child: Text(
                'insert',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _insert();
              },
            ),
//            RaisedButton(
//              child: Text(
//                'update',
//                style: TextStyle(fontSize: 20),
//              ),
//              onPressed: () {
//                _update();
//              },
//            ),
            RaisedButton(
              child: Text(
                'delete',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _delete();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Button onPressed methods

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnCode: 115,
      DatabaseHelper.columnItemDetail: 'Dosa 1123',
      DatabaseHelper.columnTax: '23',
      DatabaseHelper.columnUnitPrice: '30',
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  //Dialog box for edit or delete items based on user input
  _editItemDialog(int position) {
    itemDetailController.text = items[position].itemDetail;
    itemTaxController.text = items[position].tax;
    itemUnitPriceController.text = items[position].unitPrice;

    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Update / delete item code " +
                  items[position].code.toString()),
              content: new Column(
                children: <Widget>[
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
                    new Column(
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
                              items[position] = uItem;
                            });

                            Navigator.of(context, rootNavigator: true).pop();

                            //_editItem(position);
                          },
                        ),
                        new Text('Update item'),
                      ],
                    ),
                    new Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            size: 40.0,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            //_editItem(position);
                          },
                        ),
                        new Text('Delete item'),
                      ],
                    )
                  ]),
                ],
              ),
            ));
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    items = [];
    allRows.forEach((row) => _addItemToList(row));
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
      DatabaseHelper.columnCode: item.code,
      DatabaseHelper.columnItemDetail: item.itemDetail,
      DatabaseHelper.columnTax: item.tax,
      DatabaseHelper.columnUnitPrice: item.unitPrice,
    };
    final rowsAffected = await dbHelper.update(row);
//    print('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    //final id = await dbHelper.queryRowCount();
    int id = 111;
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}
