import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:progress_dialog/progress_dialog.dart';

String timestampFormatDDMMYYYY(Timestamp timestamp) {
  return Jiffy(timestamp.toDate().toIso8601String()).format('do MMMM yyyy');
}

String timestampFormatwithTime(Timestamp timestamp) {
  return Jiffy(timestamp.toDate().toIso8601String())
      .format('MMMM do yyyy, h:mm a');
}

String validateName(String value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Name is required";
  } else if (value.length > 20) {
    return "Number of characters must not exceed 20.";
  } else if (!regExp.hasMatch(value)) {
    return "Name must be a-z and A-Z";
  }
  return null;
}

String validateMobile(String value) {
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = RegExp(pattern);
  if (value.length == 0) {
    return "Mobile phone number is required";
  } else if (value.length != 10) {
    return "Mobile phone number must have 10 digits";
  } else if (!regExp.hasMatch(value)) {
    return "Mobile phone number must contain only digits";
  }
  return null;
}

String validateInternationalMobile(String value) {
  String pattern = r'^[0-9\-\+]{9,15}$';
  RegExp regExp = RegExp(pattern);
  if (value.length == 0) {
    return "Mobile phone number is required";
  } else if (!regExp.hasMatch(value)) {
    return "Enter valid mobile number";
  }

  return null;
}

String validatePassword(String value) {
  if (value.length < 6)
    return 'Password must be more than 5 charaters';
  else
    return null;
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}

String validateConfirmPassword(String password, String confirmPassword) {
  print("$password $confirmPassword");
  if (password != confirmPassword) {
    return 'Password doesn\'t match';
  } else if (confirmPassword.length == 0) {
    return 'Confirm password is required';
  } else {
    return null;
  }
}

//helper method to show progress
ProgressDialog progressDialog;

showProgress(BuildContext context, String message, bool isDismissible) async {
  progressDialog = new ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: isDismissible);
  progressDialog.style(
      message: message,
      borderRadius: 10.0,
      backgroundColor: Colors.blue[800],
      progressWidget: Container(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          )),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600));
  await progressDialog.show();
}

updateProgress(String message) {
  progressDialog.update(message: message);
}

hideProgress() async {
  await progressDialog.hide();
}

//helper method to show alert dialog
showAlertDialog(BuildContext context, String title, String content) {
  // set up the AlertDialog
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}