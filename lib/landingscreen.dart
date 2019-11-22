import 'package:flutter/material.dart';
import 'package:naapos/dashboard.dart';
import 'package:naapos/homescreen.dart';
import 'package:naapos/invoice_screen.dart';
import 'package:naapos/items_catalog.dart';
import 'package:naapos/utils.dart';
import 'package:naapos/charts_top_items.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 0;

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
          ManageItem(),
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
              icon: Icon(Icons.home, size: 40.0, color: Colors.orangeAccent),
              color: _page == 0
                  ? Theme.of(context).accentColor
                  : Theme.of(context).textTheme.caption.color,
              onPressed: () => _pageController.jumpToPage(0),
            ),
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                size: 40.0,
                color: Colors.orangeAccent,
              ),
              color: _page == 1
                  ? Theme.of(context).accentColor
                  : Theme.of(context).textTheme.caption.color,
              onPressed: () => _pageController.jumpToPage(1),
            ),
            IconButton(
              icon: Icon(
                Icons.list,
                size: 40.0,
                color: Colors.orangeAccent,
              ),
              color: _page == 2
                  ? Theme.of(context).accentColor
                  : Theme.of(context).textTheme.caption.color,
              onPressed: () => _pageController.jumpToPage(2),
            ),
            IconButton(
              icon: Icon(
                Icons.receipt,
                size: 40.0,
                color: Colors.orangeAccent,
              ),
              color: _page == 2
                  ? Theme.of(context).accentColor
                  : Theme.of(context).textTheme.caption.color,
              onPressed: () => _pageController.jumpToPage(3),
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
