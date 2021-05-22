import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mind_care/main.dart';
import 'package:mind_care/model/user.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String userId;
  bool showSpinner = false;
  final _firestrore = Firestore.instance;
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: CircleAvatar(
                    radius: 120.0,
                    backgroundImage: AssetImage('images/logo2.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      hintText: 'Enter Your Email',
                      border: InputBorder.none,
                    )),
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      hintText: 'Enter Your Password',
                      border: InputBorder.none,
                    )),
              ),
              SizedBox(
                height: 24.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextButton(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final signedInUser = await _auth
                          .signInWithEmailAndPassword(
                              email: email, password: password);
                      if (signedInUser != null) {
                             await _firestrore
                                  .collection('users')
                                  .document(signedInUser.user.uid)
                                  .get()
                                  .then((result) {
                                user = User(
                                  name: result.data['name'],
                                  userId: signedInUser.user.uid,
                                  email: result.data['email'],
                                  postIds: result.data['postIds'],
                                  postUpvotes: result.data['postUpvotes'],
                                  replyUpvotes: result.data['replyUpvotes'],
                                  zenRating: result.data['zenRating'],
                                  streak: result.data['streak'] ?? 0,
                                );
                                MyAppState.currentUser = user;
                              });
                             Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false,
                                 arguments: {'userId': user.userId, 'user': user});
                          }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
