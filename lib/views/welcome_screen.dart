import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:mind_care/utilities/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {
        //nothing implemented yet but necessary to call this method for animation to run.
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: CircleAvatar(
                      backgroundImage: AssetImage('images/logo2.png'),
                      radius: 60,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                RotateAnimatedTextKit(
                  totalRepeatCount: 50,
                  pause: const Duration(milliseconds: 250),
                  isRepeatingAnimation: true,
                  text: ['We Listen', 'We Care', 'Mind Care'],
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontFamily: 'Pattaya',
                    color: Colors.lightBlue[800],
                    fontSize: 45.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Center(child: Text('Have a Mind Care Account?')),
            RoundedButton(text: 'LOGIN', route: '/login'),
            SizedBox(height: 20),
            Center(child: Text('New to Mind Care?')),
            RoundedButton(text: 'REGISTER', route: '/register'),
          ],
        ),
      ),
    );
  }
}
