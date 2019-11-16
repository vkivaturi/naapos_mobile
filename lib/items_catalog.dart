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
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;
  List<String> sendersList = [
    "Idly 1 2 3",
    "Dosa 5 6 7",
    "Nothin tea",
    "Coffeea as",
  ];
  List<String> subjectList = ["1", "2", "3", "4"];

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
    _query();

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
                            onPressed: () { print(items[position].code.toString());},
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
            RaisedButton(
              child: Text(
                'update',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _update();
              },
            ),
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

  void _editItem() {
    print('edit item');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
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

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnCode: 115,
      DatabaseHelper.columnItemDetail: 'poori',
      DatabaseHelper.columnTax: '11123',
      DatabaseHelper.columnUnitPrice: '130',
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    //final id = await dbHelper.queryRowCount();
    int id = 111;
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}
