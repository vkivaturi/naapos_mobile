import 'package:flutter/material.dart';
import 'package:naapos/charts_top_items.dart';
import 'package:naapos/charts_top_orders.dart';
import 'package:naapos/charts_trends.dart';

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
          "Naa POS Dashboard",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25.0, color: Colors.white),
        ),
//        backgroundColor: Color.fromRGBO(49, 87, 110, 1.0),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
//          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            makeDashboardItem("Top 5 selling items", Icons.list, Colors.pinkAccent, TopItemChart()),
            makeDashboardItem(
                "Top 5 orders", Icons.highlight, Colors.lightBlueAccent, TopOrderChart()),
            makeDashboardItem(
                "Weekly trends", Icons.graphic_eq, Colors.yellow, TrendsChart()),
//            makeDashboardItem(
//                "Weekly order values", Icons.show_chart, Colors.orange, TopOrdersChart()),
//            makeDashboardItem(
//                "View last order", Icons.remove_red_eye, Colors.green, TopOrdersChart()),
//            makeDashboardItem("Add new item", Icons.add_box, Colors.tealAccent, TopOrdersChart())
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
