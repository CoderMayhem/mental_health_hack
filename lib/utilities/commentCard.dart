import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentCard extends StatelessWidget {
  final String name;
  final String comment;
  final String time;
  final bool isCounsellor;

  const CommentCard({
    Key key,
    this.name,
    this.comment,
    this.time, this.isCounsellor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
//      elevation: ScreenUtil().setHeight(1),
      elevation: 0,
      margin: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 5),
      child: Container(
        constraints: BoxConstraints(minWidth: double.infinity),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage:
                    AssetImage('images/logo1.png'),
                    radius: 12,
                  ),
                  SizedBox(width: 5),
                  Text(
                    name ?? 'TFUser',
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 8),
                  /*Visibility(
                    visible: isOrganizer,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(1.0))),
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
                  Expanded(child: Container()),
                  Text(
                    time ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0x99000000),
                    ),
                  )
                ],
              ),
              SizedBox(height: 12),
              MarkdownBody(
                data: comment ?? '',
//                selectable: true,
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
            ],
          ),
        ),
      ),
    );
  }
}