import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  final String text;
  final String route;

  const RoundedButton({this.text, this.route});
  

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Container(
          width: 200,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.lightBlue[800],
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          )),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
