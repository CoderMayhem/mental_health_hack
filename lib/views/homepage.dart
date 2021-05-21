import 'package:flutter/material.dart';
import 'package:mind_care/model/user.dart';

class HomePage extends StatefulWidget {

  final String userId;
  final User user;
  const HomePage({Key key, this.userId, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('HOME'),);
  }
}
