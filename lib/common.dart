import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

void addUserToFirestore(String email, String password) async {
  try {
    // Lấy tham chiếu đến collection "users"
    final collectionRef = FirebaseFirestore.instance.collection('users');

    // Tạo một document mới với id của người dùng
    final documentRef = collectionRef.doc(); // Để Firebase tự sinh id

    // Tạo dữ liệu của người dùng
    final userData = {'email': email, 'password': password};

    // Thêm dữ liệu vào document trong collection
    await documentRef.set(userData);

    print('Thêm người dùng vào Firestore thành công!');
  } catch (error) {
    print('Lỗi khi thêm người dùng vào Firestore: $error');
  }
}

void addTaskToFirestore(String email, String password) async {
  try {
    // Lấy tham chiếu đến collection "users"
    final collectionRef = FirebaseFirestore.instance.collection('users');

    // Tạo một document mới với id của người dùng
    final documentRef = collectionRef.doc(); // Để Firebase tự sinh id

    // Tạo dữ liệu của người dùng
    final userData = {'email': email, 'password': password};

    // Thêm dữ liệu vào document trong collection
    await documentRef.set(userData);

    print('Thêm người dùng vào Firestore thành công!');
  } catch (error) {
    print('Lỗi khi thêm người dùng vào Firestore: $error');
  }
}
