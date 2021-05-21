import 'package:flutter/material.dart';
import 'package:mind_care/views/homepage.dart';
import 'package:mind_care/views/login.dart';
import 'package:mind_care/views/register.dart';
import 'package:mind_care/views/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/welcome', routes: {
      '/': (context) => HomePage(),
      '/welcome': (context) => WelcomeScreen(),
      '/login': (context) => LoginScreen(),
      '/register': (context) => RegistrationScreen(),
    });
  }
}
