import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mind_care/views/homepage.dart';
import 'package:mind_care/views/infopage.dart';
import 'package:mind_care/views/streak.dart';

import '../main.dart';

class MyBottomAppBar extends StatefulWidget {
  const MyBottomAppBar({Key key}) : super(key: key);

  @override
  _MyBottomAppBarState createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {
  int _currentTabIndex = MyAppState.bottomBarIndex ?? 0;
  final Color activeColor = Colors.blue[500];
  final Color inactiveColor = Colors.blue[800];

  @override
  void initState() {
    super.initState();
    //checkIsRegisteredStream();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[800],
      child: onClickedBottomBar(),
    );
  }

  Widget onClickedBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Container(
            child: GestureDetector(
              onTap: onTapInfo,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _currentTabIndex == 0
                      ? BottomNavTab(activeColor, Icon(Icons.home, color: Colors.white))
                      : BottomNavTab(inactiveColor, Icon(Icons.home, color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Text(
                      'Home',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          //onPressed: onTapForum,
          child: GestureDetector(
            onTap: onTapForum,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _currentTabIndex == 1
                    ? BottomNavTab(activeColor, Icon(Icons.article_rounded, color: Colors.white))
                    : BottomNavTab(inactiveColor, Icon(Icons.article_rounded, color: Colors.white)),
                Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Text(
                    'Posts',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          //onPressed: onTapMed,
          child: GestureDetector(
            onTap: onTapMed,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _currentTabIndex == 2
                    ? BottomNavTab(activeColor, Icon(Icons.local_fire_department, color: Colors.white))
                    : BottomNavTab(inactiveColor, Icon(Icons.local_fire_department, color: Colors.white)),
                Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Text(
                    'Streak',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void onTapInfo() {
    setState(() {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => HomePage()));
      MyAppState.bottomBarIndex = 0;
    });
  }

  void onTapForum() {
    setState(() {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => InfoPage()));
      MyAppState.bottomBarIndex = 1;
    });
  }

  void onTapMed() {
    setState(() {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => Streak()));
      MyAppState.bottomBarIndex = 2;
    });
  }
}

class BottomNavTab extends StatelessWidget {
  final Color color;
  final Widget icon;

  BottomNavTab(this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(5.0)),
      padding: EdgeInsets.all(5),
      child: icon,
    );
  }
}
