import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mind_care/utilities/infoCard.dart';
import 'package:mind_care/views/info_detail.dart';
import 'package:timeago/timeago.dart' as timeago;

final _firestore = Firestore.instance;

class InfoVM extends StatelessWidget {

  const InfoVM(
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('info')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        print('Reched Here 1');
        print(snapshot.data.documents);

        final info = snapshot.data.documents;
        print(info);
        List<InfoCard> infoCards = [];
        for (var details in info) {
          final headingText = details.data['heading'];
          final bodyText = details.data['body'];
          final postedBy = details.data['postedBy'];
          final time = details.data['timeStamp'];
          final infoId = details.documentID;
          final imageUrl = details.data['imageUrl'];
          final List<dynamic> upvotesList = details.data['upvotes'] ?? [];
          final String userId = details.data['userId'] ?? [];

          print(headingText);
          print(infoId);

          DateTime myDateTime;
          String timeLapse;
          if (time != null) {
            myDateTime = time.toDate();
            final minuteAgo = myDateTime.subtract(new Duration(minutes: 1));
            timeLapse = timeago.format(minuteAgo);
          }

          final infoCard = InfoCard(
            isCounsellor: true,
            headingText: headingText ?? '',
            bodyText: bodyText ?? '',
            postedBy: postedBy,
            infoId: infoId,
            imageUrl: imageUrl,
            time: time != null ? timeLapse : myDateTime.toString(),
            noOfUpvotes: upvotesList.length.toString(),
          );

          infoCards.add(infoCard);
          infoCards.reversed;
        }
        return _buildTappableCardList(infoCards);
      },
    );
  }

  Widget _buildTappableCardList(List<InfoCard> infoCards) {
    return Container(
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          // ignore: missing_return
          itemBuilder: (context, index) {
            if (index < infoCards.length) {
              return GestureDetector(
                child: infoCards[index],
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InfoDetail(
                            infoCard: infoCards[index],
                          )));
                },
              );
            }
          },
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}