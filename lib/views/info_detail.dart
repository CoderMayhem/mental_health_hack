import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_care/utilities/bottomNavBar.dart';
import 'package:mind_care/utilities/infoCard.dart';
import 'package:mind_care/views/imagePreviewScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class InfoDetail extends StatefulWidget {
  final InfoCard infoCard;

  const InfoDetail({
    Key key,
    this.infoCard,
  }) : super(key: key);

  @override
  _InfoDetailState createState() => _InfoDetailState();
}

final _firestore = Firestore.instance;

class _InfoDetailState extends State<InfoDetail> {
  bool upvoted = false;
  List<dynamic> upvotesList = [];

  Stream<DocumentSnapshot> snapshotStream;

  void toggleUpvote() async {
    if (upvoted == false) {
      await _firestore
          .collection('info')
          .document(widget.infoCard.infoId)
          .updateData({
        'upvotes': FieldValue.arrayUnion([MyAppState.currentUser.userId])
      });
    } else {
      await _firestore
          .collection('info')
          .document(widget.infoCard.infoId)
          .updateData({
        'upvotes': FieldValue.arrayRemove([MyAppState.currentUser.userId])
      });
    }
  }

  void subscribeStream() {
    snapshotStream = _firestore
        .collection('info')
        .document(widget.infoCard.infoId)
        .snapshots();
    snapshotStream.listen((DocumentSnapshot snapshot) {
      setState(() {
        upvotesList = snapshot.data['upvotes'] ?? [];
        upvoted = upvotesList.contains(MyAppState.currentUser.userId);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    subscribeStream();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(BoxConstraints(), designSize: Size(360, 640), allowFontScaling: false);
    return ScreenUtilInit(
      designSize: Size(360, 640),
      builder: () =>
          Scaffold(
            backgroundColor: Color(0xFFE5E5E5),
            appBar: AppBar(
              title: Text(
                'Feed Post',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(24),
                  color: Colors.white,
                  fontFamily: 'Pattaya',
                ),
              ),
              actions: <Widget>[
                InkWell(
                  child: Icon(Icons.close, color: Colors.white),
                  onTap: () {
                    Navigator.pop(context);
                    MyAppState.bottomBarIndex = 1;
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(20),
                        bottom: ScreenUtil().setHeight(2)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(ScreenUtil().setHeight(20))),
                      ),
                      constraints: BoxConstraints(minWidth: double.infinity),
                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'images/logo.png'),
                                      radius: ScreenUtil().setWidth(12),
                                    ),
                                    SizedBox(width: ScreenUtil().setWidth(5)),
                                    Text(
                                      widget.infoCard.postedBy ?? 'Anonymous',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(12),
                                        color: Colors.blue[800],
                                      ),
                                    ),
                                    SizedBox(width: ScreenUtil().setWidth(8)),
                                    Visibility(
                                      visible: widget.infoCard.isCounsellor,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(1.0))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            'Organizer',
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(10),
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  widget.infoCard.time ?? 'Time Elapsed',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(12),
                                    color: Color(0x99000000),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: ScreenUtil().setHeight(15)),
                            Visibility(
                              visible: widget.infoCard.headingText.isNotEmpty,
                              child: Flexible(
                                child: Text(
                                  widget.infoCard.headingText ?? 'Heading',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(17),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(12.0)),
                            widget.infoCard.imageUrl != null
                                ? Visibility(
                                visible: widget.infoCard.imageUrl != null,
                                child: Container(
                                  constraints: BoxConstraints(maxHeight: 240.0),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            '/image_preview', arguments: {
                                          'imageProvider': NetworkImage(widget
                                              .infoCard.imageUrl)
                                        });
                                      },
                                      child: Image.network(
                                          widget.infoCard.imageUrl),
                                    ),
                                  ),
                                )
                            ): SizedBox.shrink(),
                            SizedBox(height: ScreenUtil().setHeight(20.0)),
                            Visibility(
                              visible: widget.infoCard.bodyText.isNotEmpty,
                              child: Flexible(
                                child: MarkdownBody(
                                  data: widget.infoCard.bodyText ?? '',
//                            selectable: true,
                                  styleSheet: MarkdownStyleSheet(
                                    textScaleFactor: 1.1,
                                  ),
                                  onTapLink: (text, url, title) async {
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(16)),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Row(
//                            children: <Widget>[
//                              SizedBox(width: 5),
//                              dullText('${upvotesList.length} Upvotes'),
//                            ],
//                          ),
//                        ],
//                      )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  color: Colors.blue[800],
                  child: Container(
                    constraints:
                    BoxConstraints(minWidth: double.infinity, minHeight: 48.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: kElevationToShadow[2],
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(ScreenUtil().setHeight(20))),
                    ),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 24.0),
                        dullText('${upvotesList.length} Upvotes'),
                        SizedBox(width: 5),
                        SizedBox(width: 16.0),
                        GestureDetector(
                          child: Row(
                            children: upvoted
                                ? <Widget>[
                              Icon(Icons.thumb_up,
                                  color: Colors.lightBlueAccent),
                              SizedBox(width: 5),
                              Text(
                                'Upvoted',
                                style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                            ]
                                : <Widget>[
                              Icon(Icons.thumb_up, color: Colors.grey),
                              SizedBox(width: 5),
                              Text(
                                'Upvote',
                              ),
                            ],
                          ),
                          onTap: () {
                            toggleUpvote();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                MyBottomAppBar(),
              ],
            ),
          ),
    );
  }

  Widget dullText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: ScreenUtil().setSp(10),
        color: Color(0x99000000),
      ),
    );
  }
}
