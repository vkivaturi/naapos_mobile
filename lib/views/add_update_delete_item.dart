import 'package:flutter/material.dart';
import 'package:naapos/data/entities.dart';
import 'package:naapos/data/database_helper.dart';
import 'package:naapos/utils/utils.dart';

class ManageItem extends StatefulWidget {
  //Item will be null when this widget is called in add item scenario. Othewise it will be not null
  final Item incomingItem;

  final String title;

  ManageItem({Key key, this.title, @required this.incomingItem})
      : super(key: key);

  @override
  _ManageItemState createState() => _ManageItemState();
}

class _ManageItemState extends State<ManageItem> {
  final itemCodeController = TextEditingController();
  final itemDetailController = TextEditingController();
  final itemTaxController = TextEditingController();
  final itemUnitPriceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String appBarTitle = "";

  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  Item item;
  bool isAdd = false;

  _ManageItemState({this.item});

  @override
  void initState() {
//    item = new Item();
    super.initState();

    //Initialise item to incoming item, if available
    item = widget.incomingItem;

    //Item will not be null if the this screen is called for update or delete of the item.
    // In which case, prefill the values.
    if (item != null) {
      isAdd = false;
      appBarTitle = "Edit item";

      itemCodeController.text = item.code.toString();
      itemDetailController.text = item.itemDetail;
      itemTaxController.text = item.tax.toString();
      itemUnitPriceController.text = item.unitPrice.toString();
    } else {
      appBarTitle = "Add item to catalog";
      item = new Item();
      isAdd = true;
    }
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
      DatabaseHelper.columnCode: item.code,
      DatabaseHelper.columnItemDetail: item.itemDetail,
      DatabaseHelper.columnTax: item.tax,
      DatabaseHelper.columnUnitPrice: item.unitPrice,
    };
    final id = await dbHelper.insertIT(row);
//    print('inserted row id: $id');
  }

  void _update(Item item) async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnCode: item.code,
      DatabaseHelper.columnItemDetail: item.itemDetail,
      DatabaseHelper.columnTax: item.tax,
      DatabaseHelper.columnUnitPrice: item.unitPrice,
    };
    final rowsAffected = await dbHelper.updateIT(row);
//    print('updated $rowsAffected row(s): row $row');
  }

  void _delete(int id) async {
    final rowsDeleted = await dbHelper.deleteIT(id);
//    print('deleted $rowsDeleted row(s): row $id');
  }

  //This is the main build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.0, color: Colors.pink),
          ),
          //backgroundColor: Color.fromRGBO(49, 87, 110, 1.0),
        ),
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Builder(
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

                            //Item code field is enabled for edit only in cases of add
                            enabled: isAdd,
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
                                labelText: "Unit price",
                                border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            controller: itemUnitPriceController,
                          ),
                          SizedBox(
                            height: 35.0,
                          ),
                          Visibility(
                              visible: isAdd,
                              child: ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: RaisedButton(
                                      padding: const EdgeInsets.all(12.0),
                                      textColor: Colors.white,
                                      color: Colors.green,
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {

                                          item.setItem(
                                              int.parse(
                                                  itemCodeController.text),
                                              itemDetailController.text,
                                              "",
                                              itemTaxController.text,
                                              itemUnitPriceController.text,
                                              "");

                                          _insert(item);

                                          //Clear the fields on screen to allow new item addition
                                          itemCodeController.clear();
                                          itemDetailController.clear();
                                          itemTaxController.clear();
                                          itemUnitPriceController.clear();

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
                                      child: Text('Add item',
                                          style: TextStyle(fontSize: 25))))),
                          Visibility(
                              visible: !isAdd,
                              child: ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: RaisedButton(
                                      padding: const EdgeInsets.all(12.0),
                                      textColor: Colors.black,
                                      color: Colors.orangeAccent,
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {

                                          item.setItem(
                                              int.parse(
                                                  itemCodeController.text),
                                              itemDetailController.text,
                                              "",
                                              itemTaxController.text,
                                              itemUnitPriceController.text,
                                              "");

                                          _update(item);

                                          HelperMethods.showMessage(
                                              context,
                                              Colors.green,
                                              "Item is updated successfully");

                                          //Go back to the item list page
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        } else {
                                          // If the form is valid, display a Snackbar.
                                          HelperMethods.showMessage(
                                              context,
                                              Colors.orange,
                                              "There are errors in your input data. Please fix them");
                                        }
                                      },
                                      child: Text('Update item',
                                          style: TextStyle(fontSize: 25))))),
                          SizedBox(
                            height: 35.0,
                          ),
                          Visibility(
                              visible: !isAdd,
                              child: ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: RaisedButton(
                                      padding: const EdgeInsets.all(12.0),
                                      textColor: Colors.white,
                                      color: Colors.red,
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          item.code = int.parse(
                                              itemCodeController.text);

                                          _delete(item.code);

                                          //Go back to the item list page
                                          HelperMethods.showMessage(
                                              context,
                                              Colors.green,
                                              "Item is deleted successfully");

                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        } else {
                                          // If the form is valid, display a Snackbar.
                                          HelperMethods.showMessage(
                                              context,
                                              Colors.deepOrange,
                                              "There are errors in your input data. Please fix them");
                                        }
                                      },
                                      child: Text('Delete item',
                                          style: TextStyle(fontSize: 25)))))
                        ],
                      )),
                ))));
  }
}
