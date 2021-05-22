import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_care/model/user.dart';
import 'package:mind_care/utilities/headingContainer.dart';
import 'package:mind_care/utilities/helper.dart';
import 'package:mind_care/utilities/postCard.dart';
import 'package:mind_care/viewModels/postThreadVM.dart';
import 'package:url_launcher/url_launcher.dart';

class PostThread extends StatefulWidget {
  final PostCard postCard;
  final User user;

  const PostThread({
    Key key,
    this.postCard, this.user,
  }) : super(key: key);

  @override
  _PostThreadState createState() => _PostThreadState();
}

final _firestore = Firestore.instance;

class _PostThreadState extends State<PostThread> {
  bool upvoted = false;
  List<dynamic> upvotesList = [];
  int noOfReplies = 0;
  Stream<DocumentSnapshot> snapshotStream;

  void toggleUpvote() async {
    if (upvoted == false) {
      await _firestore
          .collection('posts')
          .document(widget.postCard.postId)
          .updateData({
        'upvotes': FieldValue.arrayUnion([widget.user.userId])
      });
    } else {
      await _firestore
          .collection('posts')
          .document(widget.postCard.postId)
          .updateData({
        'upvotes': FieldValue.arrayRemove([widget.user.userId])
      });
    }
  }

  void subscribeStream() {
    snapshotStream = _firestore
        .collection('posts')
        .document(widget.postCard.postId)
        .snapshots();
    snapshotStream.listen((DocumentSnapshot snapshot) {
      setState(() {
        upvotesList = snapshot.data['upvotes'] ?? [];
        upvoted = upvotesList.contains(widget.user.userId);
        noOfReplies = snapshot.data['no_of_comments'] ?? 0;
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
    int noOfComments = 0;

    // ScreenUtil.init(BoxConstraints(), designSize: Size(360, 640), allowFontScaling: false);
    return ScreenUtilInit(
      designSize: Size(360, 640),
      builder: () => Scaffold(
        backgroundColor: Color(0xFFE5E5E5),
        appBar: AppBar(
          title: Text(
            'Post',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(24),
              fontFamily: 'Pattaya',
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            InkWell(
              child: Icon(Icons.close, color: Colors.white),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
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
                                      widget.postCard.postedBy ??
                                          'Anonymous',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(12),
                                        color: Colors.blue[800],
                                      ),
                                    ),
                                    SizedBox(width: ScreenUtil().setWidth(8)),
                                    /*Visibility(
                                      visible:
                                      widget.postCard.isOrganizer,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border:
                                            Border.all(color: Colors.grey),
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
                                    ),*/
                                  ],
                                ),
                                Text(
                                  widget.postCard.time ?? 'Time Elapsed',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(12),
                                    color: Color(0x99000000),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: ScreenUtil().setHeight(15)),
                            Visibility(
                              visible:
                              widget.postCard.headingText.isNotEmpty,
                              child: Flexible(
                                child: Text(
                                  widget.postCard.headingText,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(17),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(15)),
                            Visibility(
                              visible:
                              widget.postCard.bodyText.isNotEmpty,
                              child: Flexible(
                                child: MarkdownBody(
                                  data: widget.postCard.bodyText ?? '',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    noOfComments != null
                                        ? dullText('$noOfReplies Replies')
                                        : dullText('0 Replies'),
                                    SizedBox(width: 5),
                                    SizedBox(width: 5),
                                    dullText('${upvotesList.length} Upvotes'),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: 10.0),
                                Icon(Icons.reply, size: 20, color: Colors.grey),
                                SizedBox(width: 10),
                                Text(
                                  'Reply',
                                ),
                              ],
                            ),
                            onTap: () {
                              _showDialog(context);
                            },
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(20)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                child: Row(
                                  children: upvoted
                                      ? <Widget>[
                                    Icon(Icons.thumb_up, size: 20, color: Colors.lightBlueAccent),
                                    SizedBox(width: 10),
                                    Text(
                                      'Upvoted',
                                      style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ),
                                  ]
                                      : <Widget>[
                                    Icon(Icons.thumb_up, size: 20, color: Colors.white12),
                                    SizedBox(width: 10),
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
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Replies : ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CommentStream(
                    postId: widget.postCard.postId,
                  )
                ],
              ),
            ),
          ],
        ),
        /*bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MyBottomAppBar(
              tournamentDetails: widget.tournamentDetails,
              gameName: widget.gameName,
              tournamentId: widget.tournamentId,
            ),
          ],
        ),*/
      ),
    );
  }

  TextEditingController replyController = TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();

  _showDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            children: <Widget>[
              Expanded(
                child: Form(
                  key: _key,
                  child: TextFormField(
                    autofocus: true,
                    validator: (value) {
                      if (value.isEmpty) return 'Some reply is required.';
                      return null;
                    },
                    controller: replyController,
                    decoration: InputDecoration(labelText: 'Your Reply'),
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
                onPressed: () async {
                  if (_key.currentState.validate()) {
                    _key.currentState.save();
                    showProgress(context, 'Posting your reply...', false);
                    await _firestore
                        .collection('posts')
                        .document(widget.postCard.postId)
                        .updateData({'no_of_comments': FieldValue.increment(1)});
                    await _firestore
                        .collection('posts')
                        .document(widget.postCard.postId)
                        .collection('comments')
                        .add({
                      'commentBody': replyController.text,
                      'postedBy': widget.user.name,
                      'userId': widget.user.userId,
                      'timeStamp': FieldValue.serverTimestamp(),
                    }).then((_) {
                      hideProgress();
                      replyController.clear();
                      Navigator.pop(context);
                    });
                  }
                })
          ],
        );
      },
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