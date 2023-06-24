import 'package:app/model/task_model.dart';
import 'package:app/state/GlobalData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TaskController {

  static Future<void> addTask(TaskModel taskModel) async {
    await FirebaseFirestore.instance.collection('tasks').add(taskModel.toJson());
  }

  static Future<TaskModel> getTask(String id) async {
    final data = await FirebaseFirestore.instance.collection("tasks").doc(id).get();
    TaskModel result = TaskModel.fromJson(data.data() ?? {});
    return result;
  }

  static Future<void> updateTask(
      String id, DateTime dateStart, DateTime dateEnd, bool isCompleted) async {
    final a = FirebaseFirestore.instance.collection('tasks').doc(id);
    EasyLoading.show();

    await a.update({'dateDone': dateEnd, 'dateStart': dateStart, 'isCompleted': isCompleted});
    EasyLoading.dismiss();
  }

  static Future<void> assign(String id, String uuid, String email) async {
    final a = FirebaseFirestore.instance.collection('tasks').doc(id);
    EasyLoading.show();

    await a.update({'userID': uuid, 'email': email});
    EasyLoading.dismiss();
  }

  static Future<List<TaskModel>> getListData(TaskParam param,
      {String? category, String? groupId, bool? onlyMe}) async {
    late List<TaskModel> listData;
    if (groupId == null) {
      listData = await FirebaseFirestore.instance
          .collection('tasks')
          .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "")
          .where("categoryID", isEqualTo: category)
          .get()
          .then((value) => value.docs.map(
                (e) {
                  final data = TaskModel.fromJson(e.data());
                  data.id = e.id;
                  return data;
                },
              ).toList());
    } else if (onlyMe == true) {
      listData = await FirebaseFirestore.instance
          .collection('tasks')
          .where("groupID", isEqualTo: groupId)
          .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "")
          .get()
          .then((value) => value.docs.map(
                (e) {
                  final data = TaskModel.fromJson(e.data());
                  data.id = e.id;
                  return data;
                },
              ).toList());
    } else {
      listData = await FirebaseFirestore.instance
          .collection('tasks')
          .where("groupID", isEqualTo: groupId)
          .get()
          .then((value) => value.docs.map(
                (e) {
                  final data = TaskModel.fromJson(e.data());
                  data.id = e.id;
                  return data;
                },
              ).toList());
    }
    switch (param.status) {
      case 'pending':
        return listData
            .where((element) =>
                compareDate(DateTime.now(), element.dateStart) == -1 &&
                (element.isCompleted == false))
            .toList();
      case 'process':
        return listData
            .where((element) =>
                compareDate(DateTime.now(), element.dateDone) == -1 &&
                compareDate(DateTime.now(), element.dateStart) >= 0 &&
                (element.isCompleted == false))
            .toList();
      case 'done':
        return listData.where((element) => element.isCompleted ?? false).toList();
      case 'late':
        return listData
            .where((element) => (compareDate(DateTime.now(), element.dateDone) == 1 &&
                (element.isCompleted == false)))
            .toList();
      default:
        return listData;
    }
  }

  static String getStatus(DateTime dateStart, DateTime dateEnd) {
    if (compareDate(DateTime.now(), dateStart) == -1) {
      return "Đang đợi";
    } else if (compareDate(DateTime.now(), dateEnd) == -1 &&
        compareDate(DateTime.now(), dateStart) >= 0) {
      return 'Đang làm';
    }
    if (compareDate(DateTime.now(), dateEnd) == 1) {
      return "Trễ";
    } else {
      return "Chưa hoàn thành";
    }
  }
}

class TaskParam {
  final String? status;
  final String? categoryID;
  final String? spaceID;

  TaskParam({this.status, this.categoryID, this.spaceID});
}
