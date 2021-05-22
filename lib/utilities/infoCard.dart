import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String bodyText;
  final String headingText;
  final String time;
  final String postedBy;
  final String infoId;
  final String noOfUpvotes;
  final String imageUrl;
  final bool isCounsellor;

  const InfoCard({Key key,
    this.postedBy,
    this.time,
    this.bodyText,
    this.headingText,
    this.noOfUpvotes,
    this.imageUrl,
    this.infoId, this.isCounsellor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),
      //elevation: ScreenUtil().setHeight(10),
      elevation: 0.0,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
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
                        ),
                      ),
                      SizedBox(width: 8),
                      Visibility(
                        visible: isCounsellor,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                              BorderRadius.all(Radius.circular(1.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'Counsellor',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
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
              imageUrl != null
                  ? textArea(Image.network(imageUrl))
                  : textArea(null),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      dullText('$noOfUpvotes Upvotes'),
                      SizedBox(width: 5),
                      //Image.asset('assets/images/dot.png', scale: 2),
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

  Widget textArea(Image myImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Visibility(
          visible: true, //headingText.isNotEmpty,
          child: Text(
            headingText ?? '',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
            textAlign: TextAlign.left,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 18),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            myImage != null
                ? Container(
              constraints: BoxConstraints(
                maxHeight: 180,
                maxWidth: 150,
              ),
              child: myImage,
            )
                : SizedBox.shrink(),
            myImage != null
                ? SizedBox(width: 20)
                : SizedBox(width: 0),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: 175,
                    minWidth: double.infinity),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                      visible: bodyText.isNotEmpty,
                      child: Flexible(
                        child: Text(
                          bodyText ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
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