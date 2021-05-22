import 'package:flutter/material.dart';

class User{

  String name;
  String userId;
  String email;
  List postIds;
  int postUpvotes;
  int replyUpvotes;
  int zenRating;
  int streak;

  User({this.name, this.userId, this.email, this.postIds, this.postUpvotes, this.replyUpvotes, this.zenRating, this.streak});
}