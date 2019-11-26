import 'package:flutter/material.dart';
import 'package:naapos/data/database_helper.dart';
import 'package:naapos/data/entities.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class TopItemChart extends StatefulWidget {
  TopItemChart({Key key, this.title}) : super(key: key);

  final String title;

  @override
  TopItemChartState createState() => TopItemChartState();
}

class TopItemChartState extends State<TopItemChart> {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;
  //Lists of map to store invoices
  List<TopItemsSold> topItemsSoldList;

  @override
  void initState() {
    topItemsSoldList = [];
    super.initState();

    //Load all items initially
    _queryTopSoldItems();
  }

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Top 5 items sold today ',
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
                      new charts.Series<TopItemsSold, String>(
                        id: 'Sales',
                        colorFn: (_, __) =>
                            charts.MaterialPalette.blue.shadeDefault,
                        domainFn: (TopItemsSold sales, _) => sales.item,
                        measureFn: (TopItemsSold sales, _) => sales.sales,
                        data: topItemsSoldList,
                      )
                    ],
                    animate: true,
                  )),
            ],
          ),
        ));
  }

  //Fetch top items list from backend.
  void _queryTopSoldItems() async {
    //Set start and end date as today and execute top orders query
    final invNumberFormat = new DateFormat('yyyyMMdd');
    var now = DateTime.now();
    int searchStartDate =
        int.parse(int.parse(invNumberFormat.format(now)).toString() + "000000");
    int searchEndDate =
        int.parse(int.parse(invNumberFormat.format(now)).toString() + "235959");
    int topItemsNum = 5;

    final allRows = await dbHelper.queryTRTopItemsSold(
        searchStartDate, searchEndDate, topItemsNum);

    topItemsSoldList = [];

    if (allRows != null) {
      allRows.forEach((row) => _addTopItemsToList(row));
    }

    //Refresh screen with invoices list since this function is an async one
    setState(() {});
  }

  void _addTopItemsToList(Map<String, Object> row) {
    TopItemsSold invoice =
        new TopItemsSold(row["itemDetail"], row["soldCount"]);
    topItemsSoldList.add(invoice);
  }
}
