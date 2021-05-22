import 'package:flutter/material.dart';

class HeadingContainer extends StatelessWidget {
  final String heading;

  const HeadingContainer({
    this.heading,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: double.infinity),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: kElevationToShadow[1],
      ),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Text(
          heading,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.blue[800],
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}