import 'package:flutter/material.dart';
import 'package:naapos/database_helper.dart';
import 'package:naapos/entities.dart';
import 'package:naapos/utils_invoice.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class TrendsChart extends StatefulWidget {
  TrendsChart({Key key, this.title}) : super(key: key);

  final String title;

  @override
  TrendsChartState createState() => TrendsChartState();
}

class TrendsChartState extends State<TrendsChart> {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;
  //Lists of map to store invoices
  List<OrderValueTimeline> orderValueTimelineList;
  List<OrderCountTimeline> orderCountTimelineList;

  @override
  void initState() {
    orderValueTimelineList = [];
    orderCountTimelineList = [];
    super.initState();

    //Load all orders initially
    _queryOrderTrends();
  }

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Order trends ',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 25.0, color: Colors.white),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Text(
                "Amount of orders from past 15 days",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              Container(
                  height: (MediaQuery.of(context).size.height - 250) / 2,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: new charts.BarChart(
                    [
                      new charts.Series<OrderValueTimeline, String>(
                        id: 'Sales',
                        colorFn: (_, __) =>
                            charts.MaterialPalette.blue.shadeDefault,
                        domainFn: (OrderValueTimeline sales, _) =>
                            sales.weekDay,
                        measureFn: (OrderValueTimeline sales, _) =>
                            sales.invoiceAmount,
                        data: orderValueTimelineList,
                      )
                    ],
                    animate: true,
                  )),
              Text(
                "Number of orders from past 15 days",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              Container(
                  height: (MediaQuery.of(context).size.height - 250) / 2,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: new charts.BarChart(
                    [
                      new charts.Series<OrderCountTimeline, String>(
                        id: 'Sales',
                        colorFn: (_, __) =>
                            charts.MaterialPalette.blue.shadeDefault,
                        domainFn: (OrderCountTimeline sales, _) =>
                            sales.weekDay,
                        measureFn: (OrderCountTimeline sales, _) =>
                            sales.orderCount,
                        data: orderCountTimelineList,
                      )
                    ],
                    animate: true,
                  )),
            ],
          ),
        ));
  }

  //Fetch order trends from backend.
  void _queryOrderTrends() async {
    //Set start and end date as today and execute top orders query
    final invNumberFormat = new DateFormat('yyyyMMdd');
    var now = DateTime.now();
    var old15Days = DateTime.now().subtract(Duration(days: 15));

    int searchStartDate = int.parse(
        int.parse(invNumberFormat.format(old15Days)).toString() + "000000");
    int searchEndDate =
        int.parse(int.parse(invNumberFormat.format(now)).toString() + "235959");
    int topItemsNum = 5;

    final allRows = await dbHelper.queryTrends(searchStartDate, searchEndDate);

    orderValueTimelineList = [];
    orderCountTimelineList = [];

    allRows.forEach((row) => _addTrendsToList(row));

    //Refresh screen with invoices list since this function is an async one
    setState(() {});
  }

  void _addTrendsToList(Map<String, Object> row) {
    OrderValueTimeline orderValue =
        new OrderValueTimeline(row["saleDate"].toString(), row["saleAmount"]);
    orderValueTimelineList.add(orderValue);

    OrderCountTimeline orderCount =
        new OrderCountTimeline(row["saleDate"].toString(), row["saleCount"]);
    orderCountTimelineList.add(orderCount);
  }
}
