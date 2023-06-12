import 'package:app/model/group_model.dart';
import 'package:app/model/task_model.dart';
import 'package:app/state/GlobalData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class GroupController {
  static final String uuid = FirebaseAuth.instance.currentUser?.uid ?? "";

  static Future<GroupModel> addGroup(GroupModel taskModel) async {
    final group = GroupModel(
      des: taskModel.des,
      name: taskModel.name,
      isHost: uuid,
    );
    final data = await FirebaseFirestore.instance.collection("group").add(group.toJson());
    await FirebaseFirestore.instance
        .collection("userGroup")
        .add({"groupID": data.id, "userID": uuid});
    for (int i = 0; i < (taskModel.userModels ?? []).length; i++) {
      await FirebaseFirestore.instance
          .collection("userGroup")
          .add({"groupID": data.id, "userID": taskModel.userModels?[i].id});
    }

    final result = await data.get().then((value) => GroupModel.fromJson(value.data() ?? {}));
    return result;
  }

  static Future<List<GroupModel>> getGroups() async {
    final data =
        await FirebaseFirestore.instance.collection("group").where("isHost", isEqualTo: uuid).get();
    final list = data.docs.map((e) {
      final daya = GroupModel.fromJson(e.data());
      daya.id = e.id;
      return daya;
    }).toList();
    for (int i = 0; i < list.length; i++) {
      final dt = await FirebaseFirestore.instance
          .collection("userGroup")
          .where("groupID", isEqualTo: list[i].id)
          .get();
      print(list[i].id);
      list[i].numUser = dt.size;
    }
    return list;
  }

  static Future<void> updateTask(
      String id, DateTime dateStart, DateTime dateEnd, bool isCompleted) async {
    final a = FirebaseFirestore.instance.collection('tasks').doc(id);
    EasyLoading.show();

    await a.update({'dateDone': dateEnd, 'dateStart': dateStart, 'isCompleted': isCompleted});
    EasyLoading.dismiss();
  }

  static Future<List<TaskModel>> getListData(TaskParam param, {String? category}) async {
    final listData = await FirebaseFirestore.instance
        .collection('tasks')
        .where('userID', isEqualTo: uuid)
        .where("categoryID", isEqualTo: category)
        .get()
        .then((value) => value.docs.map((e) {
              final data = TaskModel.fromJson(e.data());
              data.id = e.id;
              return data;
            }).toList());

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
