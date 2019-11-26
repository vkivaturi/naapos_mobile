import 'package:flutter/material.dart';
import 'package:naapos/data/database_helper.dart';
import 'package:naapos/data/entities.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

//This class renders the graph for top orders by their amount
class TopOrderChart extends StatefulWidget {
  TopOrderChart({Key key, this.title}) : super(key: key);

  final String title;

  @override
  TopOrderChartState createState() => TopOrderChartState();
}

class TopOrderChartState extends State<TopOrderChart> {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;
  //Lists of map to store invoices
  List<TopOrdersSold> topOrdersSoldList;

  @override
  void initState() {
    topOrdersSoldList = [];
    super.initState();

    //Load all items initially
    _queryTopSoldOrders();
  }

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Top 5 orders of today ',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 25.0, color: Colors.white),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height - 200,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: new charts.BarChart(
                    [
                      new charts.Series<TopOrdersSold, String>(
                        id: 'Sales',
                        colorFn: (_, __) =>
                            charts.MaterialPalette.pink.shadeDefault,
                        domainFn: (TopOrdersSold sales, _) =>
                            sales.invoiceNumber.toString(),
                        measureFn: (TopOrdersSold sales, _) =>
                            sales.invoiceAmount,
                        data: topOrdersSoldList,
                      )
                    ],
                    animate: true,
                  )),
            ],
          ),
        ));
  }

  //Fetch top items list from backend.
  void _queryTopSoldOrders() async {
    //Set start and end date as today and execute top orders query
    final invNumberFormat = new DateFormat('yyyyMMdd');
    var now = DateTime.now();
    int searchStartDate =
        int.parse(int.parse(invNumberFormat.format(now)).toString() + "000000");
    int searchEndDate =
        int.parse(int.parse(invNumberFormat.format(now)).toString() + "235959");
    int topItemsNum = 5;

    final allRows = await dbHelper.queryTRTopOrdersSold(
        searchStartDate, searchEndDate, topItemsNum);

    topOrdersSoldList = [];

    if(allRows != null) {
      allRows.forEach((row) => _addTopOrdersToList(row));
    }

    //Refresh screen with invoices list since this function is an async one
    setState(() {});
  }

  void _addTopOrdersToList(Map<String, Object> row) {
    TopOrdersSold topOrder =
        new TopOrdersSold(row["invoiceNumber"], double.parse(row["soldCount"]));
    topOrdersSoldList.add(topOrder);
  }
}
