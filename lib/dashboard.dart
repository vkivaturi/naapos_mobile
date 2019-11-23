import 'package:flutter/material.dart';
import 'package:naapos/charts_top_items.dart';
import 'package:naapos/charts_top_orders.dart';
import 'package:naapos/charts_trends.dart';
import 'package:naapos/download_data.dart';
import 'package:naapos/help.dart';
import 'package:naapos/add_item.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Naa POS Home",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25.0, color: Colors.white),
        ),
//        backgroundColor: Color.fromRGBO(49, 87, 110, 1.0),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            makeDashboardItem("Top 5 selling items", Icons.list, Colors.pinkAccent, TopItemChart()),
            makeDashboardItem(
                "Top 5 orders", Icons.highlight, Colors.lightBlueAccent, TopOrderChart()),
            makeDashboardItem(
                "Weekly trends", Icons.graphic_eq, Colors.yellow, TrendsChart()),
            makeDashboardItem(
                "Know about Naa POS", Icons.help, Colors.orange, Help()),
            makeDashboardItem("Add new item", Icons.add_box, Colors.tealAccent, AddItem()),
            makeDashboardItem(
                "Download data", Icons.file_download, Colors.green, DownloadData()),
          ],
        ),
      ),
    );
  }

  Card makeDashboardItem(String title, IconData icon, Color colorBG, Widget actionWidget) {
    return Card(
        elevation: 10.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: colorBG),
          child: new InkWell(
            onTap: () {
              print('on tap');
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return actionWidget;
              }));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 50.0),
                Center(
                    child: Icon(
                  icon,
                  size: 75.0,
                )),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }
}
