import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/category_model.dart';

class CategoryController {
  static final String uuid = FirebaseAuth.instance.currentUser?.uid ?? "";

  static Future<void> addData(String name, String des) async {
    await FirebaseFirestore.instance
        .collection('categories')
        .add({"name": name, "description": des, "userID": uuid});
  }

  static Future<List<CategoryModel>> getListData() async {
    var categoryTable = await FirebaseFirestore.instance
        .collection('categories')
        .where('userID', isEqualTo: uuid)
        .get();

    var taskTable =
        await FirebaseFirestore.instance.collection('tasks').where('userID', isEqualTo: uuid).get();

    return categoryTable.docs.map((e) {
      int count = 0;
      for (var i in taskTable.docs) {
        if (i['categoryID'] == e.id) {
          count++;
        }
      }
      final result = CategoryModel.fromJson(e.data());
      result.countWork = count;
      return result;
    }).toList();
  }
}
