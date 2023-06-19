import 'package:app/AppColors.dart';
import 'package:app/model/user_model.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../component/addTaskGroup.dart';
import '../../../model/group_model.dart';

class DetailGroupTaskSettingScreen extends StatefulWidget {
  final String groupID;
  const DetailGroupTaskSettingScreen({Key? key, required this.groupID}) : super(key: key);

  @override
  State<DetailGroupTaskSettingScreen> createState() => _DetailGroupTaskSettingScreenState();
}

class _DetailGroupTaskSettingScreenState extends State<DetailGroupTaskSettingScreen> {
  GroupModel? group;
  List<UserModel> userGroup = [];
  List<UserModel> listData = [];
  UserModel? itemSelect = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<GroupModel> getData() async {
    EasyLoading.show();
    GroupModel groupBox = await FirebaseFirestore.instance.collection("group").doc(widget.groupID).get().then((value) {
      final a = GroupModel.fromJson(value.data() ?? {});
      a.id = value.id;
      return a;
    });

    List<UserModel> _userGroup = await FirebaseFirestore.instance.collection("userGroup").where("groupID", isEqualTo: groupBox.id).get().then((value) {
      return value.docs.map((e) {
        final a = UserModel.fromJson(e.data());
        a.id = e.data()["userID"];
        return a;
      }).toList();
    });
    List<UserModel> _user = await FirebaseFirestore.instance.collection("users").get().then((value) {
      return value.docs.map((e) {
        final a = UserModel.fromJson(e.data());
        a.id = e.id;
        return a;
      }).toList();
    });
    setState(() {
      group = groupBox;
      listData = _user;
      userGroup = _user
          .where((element) => _userGroup.any((e) {
                print(e.id);
                print(element.id);
                return e.id == element.id;
              }))
          .toList();
    });

    EasyLoading.dismiss();
    return groupBox;
  }

  Future<void> addUser() async {
    EasyLoading.show();
    await FirebaseFirestore.instance.collection("userGroup").add({"groupID": group?.id, "userID": itemSelect?.id});
    userGroup.add(itemSelect!);
    EasyLoading.dismiss();
    setState(() {
      itemSelect = null;
    });
  }

  Future<void> removeUser(String id) async {
    final a = await FirebaseFirestore.instance.collection("userGroup").where("userID", isEqualTo: id).get();
    for (var element in a.docs) {
      await FirebaseFirestore.instance.collection("userGroup").doc(element.id).delete();
    }
  }

  Future<void> deleteGroup() async {
    EasyLoading.show();
    await FirebaseFirestore.instance.collection("group").doc(widget.groupID).delete();
    EasyLoading.dismiss();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Cài đặt Không gian làm việc",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tên".toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(child: Center(child: Text(group?.name ?? ""))),
                  // IconButton(
                  //     onPressed: () {
                  //
                  //     },
                  //     icon: const Icon(
                  //       Icons.edit,
                  //       size: 15,
                  //     ))
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mô tả".toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(child: Center(child: Text(group?.des ?? ""))),
                  // IconButton(
                  //     onPressed: () {
                  //
                  //     },
                  //     icon: const Icon(
                  //       Icons.edit,
                  //       size: 15,
                  //     ))
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              /// Thành viên
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thành viên: ".toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Wrap(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            ...userGroup
                                .map((e) => Container(
                                      margin: const EdgeInsets.only(bottom: 4),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(12)), border: Border.all(width: 1)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            e.email ?? "",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          SizedBox(
                                            width: 15,
                                            height: 15,
                                            child: IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: (group?.isHost != e.id)
                                                    ? () {
                                                        setState(() async {
                                                          EasyLoading.show();
                                                          await removeUser(e.id ?? "");
                                                          EasyLoading.dismiss();
                                                          setState(() {
                                                            userGroup.remove(e);
                                                          });
                                                        });
                                                      }
                                                    : null,
                                                icon: (group?.isHost != e.id)
                                                    ? const Icon(
                                                        Icons.close,
                                                        size: 15,
                                                      )
                                                    : const Text(
                                                        "host",
                                                        style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold, color: AppColors.pink),
                                                      )),
                                          )
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          height: 30,
                          child: Row(
                            children: [
                              Expanded(
                                child: AutoCompleteTextField<UserModel>(
                                  controller: TextEditingController(text: itemSelect?.email),
                                  key: GlobalKey(),
                                  suggestions: listData
                                      .where(
                                          (element) => (userGroup.every((e) => (e.id != element.id)) && element.id != FirebaseAuth.instance.currentUser?.uid))
                                      .toList(),
                                  clearOnSubmit: false,
                                  itemFilter: (item, query) => item.email?.toLowerCase().startsWith(query.toLowerCase()) ?? true,
                                  itemSorter: (a, b) => 1,
                                  itemSubmitted: (item) => setState(() {
                                    itemSelect = item;
                                  }),
                                  itemBuilder: (context, item) => ListTile(
                                    title: Text(item.email ?? ""),
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                    isDense: true,
                                    hintText: 'email người muốn thêm',
                                    hintStyle: TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              SizedBox(
                                  width: 60,
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: itemSelect != null
                                          ? () {
                                              addUser();
                                            }
                                          : null,
                                      child: const Text(
                                        "add",
                                        style: TextStyle(fontSize: 11),
                                      ))),
                              const SizedBox(
                                width: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.pink),
                  onPressed: () {
                    showAddTaskGroupBottomSheet(context, userGroup, group?.id ?? "");
                  },
                  child: Text("Thêm Công việc"),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Thông báo"),
                        content: const Text("Bạn có chắc chắn xóa?"),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                await deleteGroup();
                                Navigator.pop(context);
                              },
                              child: Text("OK")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("HỦY")),
                        ],
                      ),
                    );
                  },
                  child: Text("Xóa Group"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
