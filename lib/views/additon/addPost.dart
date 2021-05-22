import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mind_care/main.dart';
import 'package:mind_care/utilities/helper.dart';

class AddPost extends StatefulWidget {

  const AddPost({Key key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

final _firestore = Firestore.instance;

class _AddPostState extends State<AddPost> {
  TextEditingController _controller1, _controller2;
  String heading, body;

  GlobalKey<FormState> _key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          ' Tell us what you have to say...',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Pattaya',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Icon(Icons.close, color: Colors.white, size: 15),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false,
                  arguments: {
                    'userId': MyAppState.currentUser.userId,
                    'user': MyAppState.currentUser
                  });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            //HeadingContainer(heading: 'Discussion Thread'),
            SizedBox(height: 20),
            Container(
              //constraints: BoxConstraints(minHeight: double.infinity),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20), bottom: Radius.circular(0))),
              child: Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                       /* constraints: BoxConstraints(
                            minHeight: 100),*/
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Color(0xFFC4C4C4),
                            )),
                        child: TextFormField(
                          controller: _controller1,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Subject of your query can\'t be null';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'What is it about?',
                            hintStyle: TextStyle(
                              fontFamily: 'Pattaya',
                              fontSize: 20,
                              color: Color(0x80242424),
                            ),
                            contentPadding: EdgeInsets.all(8),
                          ),
                          onChanged: (val) {
                            heading = val;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20,0,20,10),
                      child: Container(
                        constraints: BoxConstraints(
                            minHeight: 500),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Color(0xFFC4C4C4),
                            )),
                        child: TextFormField(
                          controller: _controller2,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Description of your query can\'t be null';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Describe the experience . . . ',
                            hintStyle: TextStyle(
                              fontFamily: 'Pattaya',
                              fontSize: 20,
                              color: Color(0x80242424),
                            ),
                            hintMaxLines: 2,
                            contentPadding: EdgeInsets.all(8),
                          ),
                          onChanged: (val) {
                            body = val;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,20,10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.blue[800],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: GestureDetector(
                              child : Text('Post', style: TextStyle(color: Colors.white, fontSize: 19),),

                            )
                          ),
                        ],
                      ),
                    )
                    /*Container(
                      decoration: BoxDecoration(
                          color: Colors.blue[800],
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20))),
                      child: GestureDetector(
                        onTap: () async {
                          if (_key.currentState.validate()) {
                            _key.currentState.save();
                            if (heading != null) {
                              showProgress(context, 'Posting new discussion...', false);
                              _firestore
                                  .collection('posts')
                                  .add({
                                'heading': heading,
                                'body': body,
                                'postedBy': MyAppState.currentUser.name,
                                'userId': MyAppState.currentUser.userId,
                                'timeStamp': FieldValue.serverTimestamp(),
                                'no_of_comments': 0,
                                'upvotes': [MyAppState.currentUser.userId],
                              }).then((_) {
                                hideProgress();
                                Navigator.pop(context);
                              });
                            } else {
                              showToast('Heading cannot be empty!');
                            }
                          }
                        },
                        child: Container(
                          constraints: BoxConstraints(minWidth: double.infinity),
                          decoration: BoxDecoration(
                            color: Color(0xFF189AA7),
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                'POST',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showToast(String s) {
    return Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.blue[900],
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
