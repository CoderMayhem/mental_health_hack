import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mind_care/model/user.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../main.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;
  String name;
  User user;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _firestrore = Firestore.instance;

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
                      name = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      hintText: 'Enter Your Name',
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
                    'REGISTER',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        await _firestrore
                            .collection('users')
                            .document(newUser.user.uid)
                            .setData({
                          'name': name,
                          'email': email,
                          'postIds': [],
                          'postUpvotes': 0,
                          'replyUpvotes': 0,
                          'zenRating': 0,
                        }).then((v) {
                          user = User(
                              name: name,
                              userId: newUser.user.uid,
                              email: email,
                              postIds: [],
                              postUpvotes: 0,
                              replyUpvotes: 0,
                              zenRating: 0);
                        });
                        MyAppState.currentUser = user;
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (Route<dynamic> route) => false,
                            arguments: {'userId': user.userId, 'user': user});
                      }
                      print(newUser);
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
