import 'package:app/fire_base/user_controller.dart';
import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  static final googleSignIn = GoogleSignIn();
  static final String uuid = FirebaseAuth.instance.currentUser?.uid ?? "";

  static Future<void> SignInWithGG() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    EasyLoading.show();
    final googleAuth = await googleUser.authentication;
    final creadential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseAuth.instance.signOut();
    await FirebaseAppAuth.googleSignIn(creadential);
    EasyLoading.dismiss();
    UserController.addData(FirebaseAuth.instance.currentUser?.email ?? "");
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

class FirebaseAppAuth {
  static final user = FirebaseAuth.instance.currentUser;
  static Future<void> googleSignIn(AuthCredential authCredential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(authCredential);
    } catch (e) {
      print(e.toString());
    }
  }
}
