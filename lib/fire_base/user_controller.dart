import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {

  static Future<void> addData(String name) async {
    await FirebaseFirestore.instance
        .collection('users')
        .add({"email": name, "userID": FirebaseAuth.instance.currentUser?.uid ?? ""});
  }

  static Future<List<UserModel>> getListData() async {
    var dataList = await FirebaseFirestore.instance.collection('users').get();
    return dataList.docs.map((e) {
      final result = UserModel.fromJson(e.data());
      result.id = e.id;
      return result;
    }).toList();
  }
}
