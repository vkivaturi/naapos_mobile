import 'package:flutter/material.dart';
import 'package:naapos/data/database_helper.dart';
import 'package:naapos/data/entities.dart';
import 'package:naapos/views/add_update_delete_item.dart';

class ItemCatalog extends StatefulWidget {
  ItemCatalog({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ItemCatalogState createState() => ItemCatalogState();
}

class ItemCatalogState extends State<ItemCatalog> {
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
    Widget itemsView = ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, position) {
          return Card(
              elevation: 2.0,
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 5.0, color: Colors.white24))),
                  child: Text(items[position].code.toString(),
                      style: TextStyle(fontSize: 20.0, color: Colors.white)),
                ),
                title: Text(items[position].itemDetail,
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
                subtitle: Text(
                    "Rs: " +
                        items[position].unitPrice +
                        " Tax rate : " +
                        items[position].tax +
                        "%",
                    style: TextStyle(fontSize: 15.0, color: Colors.white)),
                trailing: IconButton(
                  icon: Icon(Icons.keyboard_arrow_right,
                      color: Colors.white, size: 30.0),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return ManageItem(incomingItem: items[position],);
                    }));
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
                    itemsView
                  ],
                ),
              ))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ManageItem(incomingItem : null);
          }));

        },
      ),
    );
  }

  //Dialog box for edit or delete items based on user input

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
    item.code = row["code"];
    item.itemDetail = row["itemDetail"];
    item.tax = row["tax"];
    item.unitPrice = row["unitPrice"];
    items.add(item);
  }
}
