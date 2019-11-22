import 'package:flutter/material.dart';
import 'package:naapos/database_helper.dart';
import 'package:naapos/entities.dart';
import 'package:naapos/utils_invoice.dart';

class Help extends StatefulWidget {
  Help({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HelpState createState() => HelpState();
}

class HelpState extends State<Help> {
  // reference to our single class that manages the database

  @override
  void initState() {
    super.initState();
  }

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Help',
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
                Card(
                    //color: Colors.grey,
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(
                        "Naa POS\n",
                        style: TextStyle(
                            fontSize: 20.0, color: Colors.orangeAccent),
                      ),
                      subtitle: Text(
                        "Naa (my) POS is a mobile application that helps independent small business with customer facing services. You could be running a small restaurant or general store or a medical shop or any other small business where you bill your customers. \n\nNaa POS helps you get a lot of things done in this space.",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    )),
                Card(
                    //color: Colors.grey,
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(
                        "Key features\n",
                        style: TextStyle(
                            fontSize: 20.0, color: Colors.orangeAccent),
                      ),
                      subtitle: Text(
                        "As small business owner, you can use Naa POS supports you in many ways.\n\n" +
                            "Get insights into your key selling items, order values and trends. This helps in identifying how your inventory or menu items are moving.\n\n" +
                            "Add items (products or services) that you will be billing your customers for. You can mention discounts, tax rate, item description and amount. This list of items is also referred to as item catalog.\n\n" +
                            "Create receipts at customer checkout. Select items from the item catalog, mention quantity, apply discounts and generate receipt.\n\n" +
                            "View the receipts generated and email them to anyone",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    )),
                Card(
                    //color: Colors.grey,
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(
                        "What next?\n",
                        style: TextStyle(
                            fontSize: 20.0, color: Colors.orangeAccent),
                      ),
                      subtitle: Text(
                        "We are launching the first version of Naa POS with features that are essential to track sales at small businesses. Based on feedback from you, we will be launching additional features. Some of the features that are already on our list are: \n\n" +
                            "Print the receipt.\n\n" +
                            "Improve tax feature to support GST.\n\n" +
                            "Add a token number feature which is generally used in small restaurants that are self-serve.\n\n" +
                            "Easy export and import  of item catalog and receipts.",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ))
              ],
            ),
          ),
        )));
  }
}
