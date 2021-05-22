import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class PostCard extends StatelessWidget {
  final String headingText;
  final String bodyText;
  final String postId;
  final String postedBy;
  final String noOfComments;
  final String time;
  final String noOfUpvotes;
  final bool isCounsellor;

  const PostCard({
    Key key,
    this.headingText,
    this.bodyText,
    this.postedBy,
    this.noOfComments,
    this.time,
    this.noOfUpvotes,
    this.isCounsellor = false,
    this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//      elevation: ScreenUtil().setHeight(10),
      elevation: 0.0,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: BoxConstraints(minWidth: double.infinity),
        child: Padding(
          padding: EdgeInsets.all(15),
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
                        backgroundImage:
                            AssetImage('images/logo.png'),
                        radius: 12,
                      ),
                      SizedBox(width: 5),
                      Text(
                        postedBy ?? 'Anonymous',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      SizedBox(width: 8),
                      /*Visibility(
                        visible: isCounsellor,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                              BorderRadius.all(Radius.circular(1.0))),
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
                    time ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0x99000000),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              Visibility(
                visible: headingText.isNotEmpty,
                child: Flexible(
                  child: Text(
                    headingText,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Visibility(
                visible: bodyText.isNotEmpty,
                child: Flexible(
                  child: MarkdownBody(
                    data: bodyText ?? '',
//                    selectable: true,
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
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      dullText('$noOfComments Replies'),
                      SizedBox(width: 5),
                      // Image.asset('assets/images/dot.png', scale: 2),
                      SizedBox(width: 5),
                      dullText('$noOfUpvotes Upvotes'),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget dullText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        color: Color(0x99000000),
      ),
    );
  }
}
