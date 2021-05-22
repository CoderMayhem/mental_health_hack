import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(BoxConstraints(), designSize: Size(360, 640), allowFontScaling: false);
    return ScreenUtilInit(
      designSize: Size(360, 640),
      builder: () => Scaffold(
        backgroundColor: Colors.white70,
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
          ),
        ),
        bottomNavigationBar: MyBottomAppBar(),
      ),
    );
  }
}