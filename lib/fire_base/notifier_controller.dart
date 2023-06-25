import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/notifier_model.dart';

class NotifierController {
  static Future<void> addNotifier(NotifierModel model) async {
    await FirebaseFirestore.instance.collection('notifier').add({
      "groupID": model.groupID,
      "isSeen": model.isSeen,
      "nameGroup": model.nameGroup,
      "nameTask": model.nameTask,
      "timeCreate": DateTime.now(),
      "userID": model.userID,
    });
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref(model.userID);
    databaseReference.push().set("");
  }

  static Future<List<NotifierModel>> getListData() async {
    final listData = await FirebaseFirestore.instance
        .collection('notifier')
        .where("userID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    return listData.docs.map((e) {
      final re = NotifierModel.fromJson(e.data());
      re.id = e.id;
      return re;
    }).toList();
  }

  static Future<void> update(String id) async {
    final listData = FirebaseFirestore.instance.collection('notifier').doc(id);
    await listData.update({"isSeen": true});
  }
}
