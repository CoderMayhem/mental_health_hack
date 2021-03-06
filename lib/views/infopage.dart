import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mind_care/utilities/bottomNavBar.dart';
import 'package:mind_care/viewModels/info_VM.dart';

import '../main.dart';


class InfoPage extends StatefulWidget {
  static const routeName = '/info';

  const InfoPage(
      {Key key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  bool isCounsellor = false;

  @override
  void initState() {
    checkIsCounsellor();
    super.initState();
  }

  checkIsCounsellor() async {
    /*DocumentSnapshot snapshot = await Firestore.instance
        .collection('counsellors')
        .document()
        .get();

    List<dynamic> counsellorList = snapshot.data['organizers'];*/

    /*if (counsellorList.contains(MyAppState.currentUser.userId)) {*/
      setState(() {
        isCounsellor = true;
      });
    /*} else {
      setState(() {
        isCounsellor = false;
      });
    }*/
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
        builder: () => Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Mental Health Feed',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(24),
                fontFamily: 'Pattaya',
                color: Colors.white,
              ),
            ),
          ),
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InfoVM(),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: Visibility(
            visible: isCounsellor,
            child: FloatingActionButton(
              backgroundColor: Colors.blue[800],
              child: Icon(Icons.post_add,color: Colors.white),
              onPressed: (){
                showToast('You need to be a registered counsellor to add to the Mental Health Feed');
              },
            ),
          ),
          bottomNavigationBar: MyBottomAppBar(),
        ),
      ),
    );
  }
}

Future showToast(String msg){
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0
  );

}