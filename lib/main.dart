import 'package:flutter/material.dart';
import 'package:mind_care/model/user.dart';
import 'package:mind_care/views/homepage.dart';
import 'package:mind_care/views/imagePreviewScreen.dart';
import 'package:mind_care/views/infopage.dart';
import 'package:mind_care/views/login.dart';
import 'package:mind_care/views/register.dart';
import 'package:mind_care/views/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  MyAppState createState() => MyAppState();

}

class MyAppState extends State<MyApp> {
  static User currentUser;
  static int bottomBarIndex;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/welcome', routes: {
      '/': (context) => HomePage(),
      '/welcome': (context) => WelcomeScreen(),
      '/login': (context) => LoginScreen(),
      '/register': (context) => RegistrationScreen(),
      '/image_preview' : (context) => ImagePreviewScreen(),
      '/info' : (context) => InfoPage(),
    });
  }
}
