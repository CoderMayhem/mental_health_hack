import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_care/model/user.dart';
import 'package:mind_care/utilities/bottomNavBar.dart';
import 'package:mind_care/viewModels/homepage_viewmodel.dart';
import 'package:mind_care/views/additon/addPost.dart';
import 'package:mind_care/views/infopage.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  final String userId;
  final User user;

  const HomePage({Key key, this.userId, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

@override
void initState() {
  MyAppState.bottomBarIndex = 0;
}


class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 640),
        builder: () => Scaffold(
              extendBody: true,
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  'Experiences',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(24),
                    fontFamily: 'Pattaya',
                    color: Colors.white,
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,20,0),
                    child: InkWell(
                      child: Icon(Icons.account_circle_rounded,
                          color: Colors.white, size: 30),
                      onTap: (){showToast('Hi USER');},
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //HeadingContainer(heading: 'Discussion Forum'),
                    HomepageVM(
                      user: MyAppState.currentUser,
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue[800],
                child: Icon(Icons.comment, color: Colors.white, size: 20),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddPost()));
                },
              ),
              bottomNavigationBar: Container(
                  constraints: BoxConstraints(
                    maxWidth: double.infinity,
                  ),
                  child: MyBottomAppBar()),
            ));
  }
}
/**/
