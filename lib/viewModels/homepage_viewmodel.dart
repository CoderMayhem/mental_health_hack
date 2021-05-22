import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mind_care/model/user.dart';
import 'package:mind_care/utilities/postCard.dart';
import 'package:mind_care/views/postThread.dart';
import 'package:timeago/timeago.dart' as timeago;

final _firestore = Firestore.instance;

class HomepageVM extends StatelessWidget {
  final User user;
  //final HomePage tournamentDetails;

  const HomepageVM(
      {Key key, this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('posts')
          .orderBy('timeStamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: Text('No Posts Up Yet'),//CircularProgressIndicator(),
            ),
          );
        }

        final posts = snapshot.data.documents;
        List<PostCard> postCards = [];
        for (var details in posts) {
          final headingText = details.data['heading'];
          final bodyText = details.data['body'];
          final postedBy = details.data['postedBy'];
          final time = details.data['timeStamp'];
          final numberOfReplies = details.data['no_of_comments'];
          final postId = details.documentID;
          final List<dynamic> upvotesList = details.data['upvotes'];
          final String userId = details.data['userId'];

          DateTime myDateTime;
          String timeLapse;
          if (time != null) {
            myDateTime = time.toDate();
            final minuteAgo = myDateTime.subtract(new Duration(minutes: 1));
            timeLapse = timeago.format(minuteAgo);
          }

          final myPostCard = PostCard(
            headingText: headingText ?? '',
            bodyText: bodyText ?? '',
            postedBy: postedBy,
            postId: postId,
            noOfComments: numberOfReplies.toString() ?? '0',
            time: time != null ? timeLapse : myDateTime.toString(),
            noOfUpvotes:
            (upvotesList != null) ? upvotesList.length.toString() : '0',
            isCounsellor: false,
          );

          postCards.add(myPostCard);
          postCards.reversed;
        }
        return _buildTappableCardList(postCards);
      },
    );
  }

  Widget _buildTappableCardList(List<PostCard> postCards) {
    // ignore: missing_return
    return Container(
      //color: Colors.white54,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          // ignore: missing_return
          itemBuilder: (context, index) {
            if (index < postCards.length) {
              return GestureDetector(
                child: postCards[index],
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostThread(
                            postCard: postCards[index],
                            user: user,
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