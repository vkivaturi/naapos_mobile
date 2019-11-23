import 'package:flutter/material.dart';
import 'package:naapos/entities.dart';
import 'package:naapos/database_helper.dart';
import 'package:naapos/utils.dart';
import 'package:naapos/utils_invoice.dart';

class AddItem extends StatefulWidget {
  AddItem({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final itemCodeController = TextEditingController();
  final itemDetailController = TextEditingController();
  final itemTaxController = TextEditingController();
  final itemUnitPriceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  // Bring focus back to item text field field after adding an item
  FocusNode nodeItem = FocusNode();

  Item item;

  @override
  void initState() {
    item = new Item();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    itemCodeController.dispose();
    itemDetailController.dispose();
    itemTaxController.dispose();
    itemUnitPriceController.dispose();

    super.dispose();
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

  //This is the main build method
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add item to catalog",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.0, color: Colors.white),
          ),
          //backgroundColor: Color.fromRGBO(49, 87, 110, 1.0),
        ),
        body: Builder(
          //Added this builder only to make snackbar work
          builder: (context) => Form(
              key: _formKey,
              child: Column(
                children: [
                  Divider(
                    height: 2.0,
                    color: Colors.grey,
                  ),
                  new TextFormField(
                    validator: (String value) {
                      var checkInt = int.tryParse(value);
                      if (value.isEmpty || checkInt == null) {
                        return 'Please enter a valid number for item code';
                      } else
                        return null;
                    },
                    decoration: new InputDecoration(
                        labelText: "Item code (number only)",
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    controller: itemCodeController,
                    focusNode: nodeItem,
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  new TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter valid item detail';
                      } else
                        return null;
                    },
                    decoration: new InputDecoration(
                        labelText: "Item description",
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                    controller: itemDetailController,
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  new TextFormField(
                    validator: (value) {
                      var checkInt = int.tryParse(value);
                      if (value.isEmpty || checkInt == null) {
                        return 'Please enter a valid number for tax, without the % symbol';
                      } else
                        return null;
                    },
                    decoration: new InputDecoration(
                        labelText: "Tax % (number only)",
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    controller: itemTaxController,
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  new TextFormField(
                    validator: (value) {
                      var checkInt = int.tryParse(value);
                      var checkDouble = double.tryParse(value);
                      //Amount should not be empty and it has to be atleast an integer or a double
                      if (value.isEmpty ||
                          (checkInt == null && checkDouble == null)) {
                        return 'Please enter a valid number for item unit price';
                      } else
                        return null;
                    },
                    decoration: new InputDecoration(
                        labelText: "Unit price", border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                    controller: itemUnitPriceController,
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          padding: const EdgeInsets.all(12.0),
                          textColor: Colors.white,
                          color: Colors.green,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              item.code = int.parse(itemCodeController.text);
                              item.itemDetail = itemDetailController.text;
                              item.tax = itemTaxController.text;
                              item.unitPrice = itemUnitPriceController.text;

                              _insert(item);

                              itemCodeController.clear();
                              itemDetailController.clear();
                              itemTaxController.clear();
                              itemUnitPriceController.clear();

                              FocusScope.of(context).requestFocus(nodeItem);

                              HelperMethods.showMessage(
                                  context,
                                  Colors.green,
                                  "Item is created successfully");
                            } else {
                              // If the form is valid, display a Snackbar.
                              HelperMethods.showMessage(
                                  context,
                                  Colors.deepOrange,
                                  "There are errors in your input data. Please fix them");
                            }
                          },
                          child:
                              Text('Add item', style: TextStyle(fontSize: 25))))
                ],
              )),
        ));
  }
}
