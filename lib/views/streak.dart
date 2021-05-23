import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_care/utilities/bottomNavBar.dart';
import 'package:mind_care/utilities/helper.dart';

import '../main.dart';

class Streak extends StatefulWidget {
  const Streak({Key key}) : super(key: key);

  @override
  _StreakState createState() => _StreakState();
}

class _StreakState extends State<Streak> {

  int streak;

  @override
  void initState() {
    getStreak();
    super.initState();
  }

  getStreak() {
    streak = MyAppState.currentUser.streak;
  }

  Future<bool> _onBackPressed(){
    setState(() {
      MyAppState.bottomBarIndex = 0;
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: ScreenUtilInit(
          designSize: Size(360, 640),
          builder: () =>
              Scaffold(
                extendBody: true,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                    'Meditation Streak',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(24),
                      fontFamily: 'Pattaya',
                      color: Colors.white,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF3366FF),
                                  const Color(0xFF00CCFF),
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Meditation is one of the most important practices that must be followed for your mental well-being. '
                                    '\n\nHere we\'ll encourage you to adopt this practice (if you haven\'t already) by helping you keep a track of your meditation streak. \n\nJust increment the number after meditating each day.',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Text(
                            'Your Current Streak Is :',
                            style: TextStyle(
                              fontFamily: 'Pattaya',
                              fontSize: ScreenUtil().setHeight(20),
                            ),
                          ),
                        ),
                        Center(
                          child: ColorizeAnimatedTextKit(
                            text: ['$streak Days'],
                            repeatForever: true,
                            colors: colorizeColors,
                            speed: Duration(milliseconds: 500),
                            textStyle: TextStyle(
                              fontFamily: 'Pattaya',
                              fontSize: ScreenUtil().setSp(50),
                            ),
                          )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                                padding: EdgeInsets.all(20),
                              child: GestureDetector(
                                onTap: onTapIncrement,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.green[800],
                                  ),
                                  child: Text(
                                    'Add',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(20),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: GestureDetector(
                                onTap: _showMyDialog,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.red[800],
                                  ),
                                  child: Text(
                                    'Reset',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(20),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            'Keep Going! Every Step Counts!',
                            style: TextStyle(
                              fontFamily: 'Pattaya',

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: MyBottomAppBar(),
              )
      ),
    );
  }
  void onTapIncrement() async{
    showProgress(context, 'Updating', true);
    await Firestore.instance
        .collection('users')
        .document(MyAppState.currentUser.userId)
        .updateData({
      'streak': streak+1,
    }).then((value) {
      setState(() {
        ++streak;
        MyAppState.currentUser.streak = streak;
      });
    });
    hideProgress();
  }

  void onTapReset() async{
    showProgress(context, 'Resetting Streak...', true);
    await Firestore.instance
        .collection('users')
        .document(MyAppState.currentUser.userId)
        .updateData({
      'streak': 0,
    }).then((value) {
      setState(() {
        streak=0;
        MyAppState.currentUser.streak = 0;
      });
    });
    Navigator.pop(context);
    hideProgress();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you wan\'t to reset your streak?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () async{
                onTapReset();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () async{
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

const colorizeColors = [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
];
