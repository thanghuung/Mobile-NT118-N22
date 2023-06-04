import 'package:app/model/task_model.dart';
import 'package:app/state/GlobalData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskController {
  static final String uuid = FirebaseAuth.instance.currentUser?.uid ?? "";

  static Future<void> addTask(TaskModel taskModel) async {
    await FirebaseFirestore.instance.collection('tasks').add(taskModel.toJson());
  }

  static Future<List<TaskModel>> getListData(TaskParam param) async {
    final listData = await FirebaseFirestore.instance
        .collection('tasks')
        .where('userID', isEqualTo: uuid)
        .get()
        .then((value) => value.docs.map((e) {
              final data = TaskModel.fromJson(e.data());
              data.id = e.id;
              return data;
            }).toList());

    switch (param.status) {
      case 'pending':
        return listData
            .where((element) => compareDate(DateTime.now(), element.dateStart) == -1)
            .toList();
      case 'process':
        return listData
            .where((element) =>
                compareDate(DateTime.now(), element.dateDone) == -1 &&
                compareDate(DateTime.now(), element.dateStart) >= 0)
            .toList();
      case 'done':
        return listData.where((element) => element.status == "done").toList();
      case 'late':
        return listData
            .where((element) =>
                (compareDate(DateTime.now(), element.dateDone) == 1 && element.status != 'done'))
            .toList();
      default:
        return listData;
    }
  }
}

class TaskParam {
  final String? status;
  final String? categoryID;
  final String? spaceID;

  TaskParam({this.status, this.categoryID, this.spaceID});
}
