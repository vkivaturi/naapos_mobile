import 'package:flutter/material.dart';
import 'package:naapos/home.dart';
import 'package:naapos/create_receipt.dart';
import 'package:naapos/invoice_screen.dart';
import 'package:naapos/items_catalog.dart';
import 'package:naapos/utils.dart';
import 'package:naapos/charts_top_items.dart';
import 'package:naapos/add_update_delete_item.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 0;

  bool homePressed = false;
  bool createReceiptPressed = false;
  bool manageInvoicePressed = false;
  bool viewReceiptPressed = false;

  Color selectedIconColor = Colors.pink;
  Color normalIconColor = Colors.grey;

  List<bool> trackPress = [false, false, false, false];

  //Change color of the icon on bottom navigation bar upon click
  void updateIconPressed(int indx) {
    trackPress = [false, false, false, false];
    trackPress[indx] = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          Dashboard(),
          NaaPOSHome(),
          ItemCatalog(),
          ManageInvoice(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 7),
            IconButton(
              icon: Icon(Icons.home,
                  size: 30.0,
                  color: (trackPress[0]) ? selectedIconColor : normalIconColor),
              color: _page == 0
                  ? Theme.of(context).accentColor
                  : Theme.of(context).textTheme.caption.color,
              onPressed: () {
                updateIconPressed(0);
                _pageController.jumpToPage(0);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                size: 30.0,
                  color: (trackPress[1]) ? selectedIconColor : normalIconColor
              ),
              color: _page == 1
                  ? Theme.of(context).accentColor
                  : Theme.of(context).textTheme.caption.color,
              onPressed: () {
                updateIconPressed(1);
                _pageController.jumpToPage(1);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.list,
                size: 30.0,
                  color: (trackPress[2]) ? selectedIconColor : normalIconColor
              ),
              color: _page == 2
                  ? Theme.of(context).accentColor
                  : Theme.of(context).textTheme.caption.color,
              onPressed: () {
                updateIconPressed(2);
                _pageController.jumpToPage(2);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.receipt,
                size: 30.0,
                  color: (trackPress[3]) ? selectedIconColor : normalIconColor
              ),
              color: _page == 3
                  ? Theme.of(context).accentColor
                  : Theme.of(context).textTheme.caption.color,
              onPressed: () {
                updateIconPressed(3);
                _pageController.jumpToPage(3);
              },
            ),
            SizedBox(width: 7),
          ],
        ),
        color: Theme.of(context).primaryColor,
        shape: CircularNotchedRectangle(),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    //Initialize icon pressed to first icon on page load
    updateIconPressed(0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
