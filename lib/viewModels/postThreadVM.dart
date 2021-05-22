import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mind_care/utilities/commentCard.dart';
import 'package:timeago/timeago.dart' as timeago;

final _firestore = Firestore.instance;

class CommentStream extends StatelessWidget {
  final String postId;

  const CommentStream(
      {Key key,
        this.postId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('posts')
          .document(postId)
          .collection('comments')
          .orderBy('timeStamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final comments = snapshot.data.documents;
        List<CommentCard> myComments = [];
        for (var details in comments) {
          final commentBody = details.data['commentBody'];
          final postedBy = details.data['postedBy'];
          final Timestamp timestamp =
              details.data['timeStamp'] ?? Timestamp.now();

          final myCommentCard = CommentCard(
            name: postedBy,
            comment: commentBody,
            time: timeago.format(
              DateTime.fromMicrosecondsSinceEpoch(
                  timestamp.microsecondsSinceEpoch),
              allowFromNow: true,
            ),
            isCounsellor: false,
          );

          myComments.add(myCommentCard);
          myComments.reversed;
        }
        return _buildCommentList(myComments);
      },
    );
  }

  Widget _buildCommentList(List<CommentCard> myComments) {
    if (myComments.length != 0) {
      return ListView.builder(
        // ignore: missing_return
        itemBuilder: (context, index) {
          if (index < myComments.length) {
            return myComments[index];
          }
        },
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            'There are no replies yet.',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      );
    }
  }
}