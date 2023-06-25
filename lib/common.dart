import 'dart:async';

import 'package:app/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

void showToast(String message, {ToastGravity gravity = ToastGravity.TOP}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 2,
      webBgColor: "#ffffff",
      textColor: Colors.white,
      fontSize: 16.0);
}

bool isValidEmail(String email) {
  return EmailValidator.validate(email);
}

void addUserToFirestore(String email, String password, String uid) async {
  try {
    // Lấy tham chiếu đến collection "users"
    final collectionRef = FirebaseFirestore.instance.collection('users');
    // Tạo một document mới với id của người dùng
    final documentRef = collectionRef.doc(uid); // Để Firebase tự sinh id
    // Tạo dữ liệu của người dùng
    final userData = {
      'email': email,
      'password': password,
      'dateCreated': DateTime.now().toString(),
    };
    // Thêm dữ liệu vào document trong collection
    await documentRef.set(userData);

    print('Thêm người dùng vào Firestore thành công!');
  } catch (error) {
    print('Lỗi khi thêm người dùng vào Firestore: $error');
  }
}

Future<Map<String, dynamic>?> getUserInfo(String userId) async {
  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  if (snapshot.exists) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data;
  } else {
    return null;
  }
}

void addCatetoryToFirestore(String name, String uid, String? groupID) async {
  try {
    // Lấy tham chiếu đến collection "users"
    final collectionRef = FirebaseFirestore.instance.collection('categories');
    // Tạo một document mới với id của người dùng
    final documentRef = collectionRef.doc(); // Để Firebase tự sinh id
    // Tạo dữ liệu của người dùng
    final categoryData = {
      'categoryName': name,
      'userID': uid,
      'groupID': groupID,
      'dateCreated': DateTime.now().toString(),
    };
    // Thêm dữ liệu vào document trong collection
    await documentRef.set(categoryData);
    print('Thêm category vào Firestore thành công!');
  } catch (error) {
    print('Lỗi khi thêm category vào Firestore: $error');
  }
}

Future<List<Map<String, dynamic>>> getAllCategories() async {
  List<Map<String, dynamic>> categories = [];

  if (FirebaseAuth.instance.currentUser!= null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> categoryData = doc.data() as Map<String, dynamic>;
        categoryData['id'] = doc.id; // Lấy ID của category
        categories.add(categoryData);
      });

      return categories;
    } catch (error) {
      print('Lỗi khi lấy dữ liệu từ Firestore: $error');
      return [];
    }
  }
  return [];
}

Future<List<Map<String, dynamic>>> getUpcomingTasks() async {
  List<Map<String, dynamic>> upcomingTasks = [];
  try {
    final DateTime currentDate = DateTime.now();

    final collectionRef = FirebaseFirestore.instance.collection('tasks');
    final querySnapshot = await collectionRef
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('dateDone', isGreaterThanOrEqualTo: currentDate)
        .get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> taskData = doc.data();
      taskData['id'] = doc.id; // Lấy ID của category
      upcomingTasks.add(taskData);
    });

    print('Lấy danh sách các task sắp đến hạn thành công!');
    return upcomingTasks;
  } catch (error) {
    print('Lỗi khi lấy danh sách các task sắp đến hạn: $error');
    return [];
  }
}

Future<Map<String, dynamic>?> getCategoryById(String categoryId) async {
  try {
    final collectionRef = FirebaseFirestore.instance.collection('categories');
    final documentRef = collectionRef.doc(categoryId);
    final documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists) {
      final categoryData = documentSnapshot.data();
      return categoryData;
    } else {
      print('Không tìm thấy category với ID: $categoryId');
      return null;
    }
  } catch (error) {
    print('Lỗi khi lấy thông tin category: $error');
    return null;
  }
}

String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

String formatDateFromTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
  return formattedDate;
}

enum TaskColor { pink, purple, blue, yellow }

Color convertTaskColorToAppColor(TaskColor taskColor) {
  switch (taskColor) {
    case TaskColor.pink:
      return AppColors.pink;
    case TaskColor.purple:
      return AppColors.purple;
    case TaskColor.blue:
      return AppColors.blue;
    case TaskColor.yellow:
      return AppColors.yellow;
    default:
      return AppColors.pink; // Mặc định nếu giá trị không hợp lệ
  }
}

TaskColor convertAppColorToTaskColor(Color appColor) {
  if (appColor == AppColors.pink) {
    return TaskColor.pink;
  } else if (appColor == AppColors.purple) {
    return TaskColor.purple;
  } else if (appColor == AppColors.blue) {
    return TaskColor.blue;
  } else if (appColor == AppColors.yellow) {
    return TaskColor.yellow;
  } else {
    return TaskColor.pink; // Mặc định nếu giá trị không hợp lệ
  }
}

// Hàm chuyển đổi int thành AppColors
Color convertIntToAppColor(int colorValue) {
  return Color(colorValue);
}

Color priorityToColor(String priority) {
  switch (priority) {
    case 'Không ưu tiên':
      return Colors.grey;
    case 'Rất quan trọng':
      return AppColors.red;
    case 'Quan trọng':
      return AppColors.purple;
    case 'Bình thường':
      return AppColors.blue;
    default:
      return Colors.grey;
  }
}

Color backgroundToColor(String priority) {
  switch (priority) {
    case 'yellow':
      return AppColors.yellow;
    case 'pink':
      return AppColors.pinkSecond;
    case 'purple':
      return AppColors.purpleTertiary;
    case 'blue':
      return AppColors.blueSecond;
    default:
      return Colors.grey;
  }
}


// Hàm chuyển đổi AppColors thành TaskColor
// TaskColor convertAppColorToTaskColor(Color appColor) {
//   int colorValue = appColor.value;
//   TaskColor taskColor = convertIntToTaskColor(colorValue);
//   return taskColor;
// }
