import 'package:flutter/material.dart';
import 'package:naapos/views/charts_top_items.dart';
import 'package:naapos/views/charts_top_orders.dart';
import 'package:naapos/views/charts_trends.dart';
import 'package:naapos/views/download_data.dart';
import 'package:naapos/views/help.dart';
import 'package:naapos/views/add_update_delete_item.dart';

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
          style: TextStyle(fontSize: 30.0, color: Colors.pink),
        ),
//        backgroundColor: Color.fromRGBO(49, 87, 110, 1.0),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            makeDashboardItem("Top 5 selling items", Icons.list,
                Colors.pinkAccent, TopItemChart()),
            makeDashboardItem("Top 5 orders", Icons.highlight,
                Colors.lightBlueAccent, TopOrderChart()),
            makeDashboardItem("Weekly trends", Icons.graphic_eq, Colors.yellow,
                TrendsChart()),
            makeDashboardItem(
                "Naa POS Help", Icons.help, Colors.orange, Help()),
            makeDashboardItem("Add new item", Icons.add_box,
                Colors.deepPurpleAccent, ManageItem(incomingItem: null,)),
            makeDashboardItem("Download data", Icons.file_download,
                Colors.green, DownloadData()),
          ],
        ),
      ),
    );
  }

  Card makeDashboardItem(
      String title, IconData icon, Color colorBG, Widget actionWidget) {
    return Card(
        elevation: 10.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: colorBG),
          child: new InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return actionWidget;
              }));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 30.0),
                Center(
                    child: Icon(
                  icon,
                  size: 75.0,
                )),
                SizedBox(height: 10.0),
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
