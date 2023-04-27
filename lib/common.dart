import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

void showToast(String message, {ToastGravity gravity = ToastGravity.TOP}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 2,
      webBgColor: "#ffffff",
      textColor: Colors.black,
      fontSize: 16.0);
}

bool isValidEmail(String email) {
  return EmailValidator.validate(email);
}
