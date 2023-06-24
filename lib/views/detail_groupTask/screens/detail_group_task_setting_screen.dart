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
  GlobalKey<AutoCompleteTextFieldState<UserModel>> _key =
      GlobalKey<AutoCompleteTextFieldState<UserModel>>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<GroupModel> getData() async {
    EasyLoading.show();
    GroupModel groupBox = await FirebaseFirestore.instance
        .collection("group")
        .doc(widget.groupID)
        .get()
        .then((value) {
      final a = GroupModel.fromJson(value.data() ?? {});
      a.id = value.id;
      return a;
    });

    List<UserModel> _userGroup = await FirebaseFirestore.instance
        .collection("userGroup")
        .where("groupID", isEqualTo: groupBox.id)
        .get()
        .then((value) {
      return value.docs.map((e) {
        final a = UserModel.fromJson(e.data());
        a.id = e.data()["userID"];
        return a;
      }).toList();
    });
    List<UserModel> _user =
        await FirebaseFirestore.instance.collection("users").get().then((value) {
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
                return e.id == element.id;
              }))
          .toList();
    });
    EasyLoading.dismiss();
    _key = GlobalKey<AutoCompleteTextFieldState<UserModel>>();
    return groupBox;
  }

  Future<void> addUser() async {
    EasyLoading.show();
    await FirebaseFirestore.instance
        .collection("userGroup")
        .add({"groupID": group?.id, "userID": itemSelect?.id});
    userGroup.add(itemSelect!);
    EasyLoading.dismiss();
    setState(() {
      _key = GlobalKey<AutoCompleteTextFieldState<UserModel>>();
      itemSelect = null;
    });
  }

  Future<void> removeUser(String id) async {
    final a = await FirebaseFirestore.instance
        .collection("userGroup")
        .where("userID", isEqualTo: id)
        .get();
    for (var element in a.docs) {
      await FirebaseFirestore.instance.collection("userGroup").doc(element.id).delete();
    }
    userGroup.removeWhere((element) => element.id == id);
    setState(() {
      _key = GlobalKey<AutoCompleteTextFieldState<UserModel>>();
    });
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
      appBar: AppBar(
        backgroundColor: AppColors.pink,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Cài đặt Không gian làm việc",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
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
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),

              /// Thành viên
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Thành viên: ".toUpperCase(),
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Wrap(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          ...userGroup
                              .map((e) => Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                                      border: Border.all(width: 1),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e.email ?? "",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: (group?.isHost != e.id && e.id != FirebaseAuth.instance.currentUser?.uid && group?.isHost == FirebaseAuth.instance.currentUser?.uid)
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
                                              icon: (group?.isHost == e.id)
                                                  ? const Text(
                                                      "host",
                                                      style: TextStyle(
                                                          fontSize: 7,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.pink),
                                                    )
                                                  : (e.id != FirebaseAuth.instance.currentUser?.uid
                                                      ? (group?.isHost == FirebaseAuth.instance.currentUser?.uid? const Icon(
                                                          Icons.close,
                                                          size: 20,
                                                        ): const SizedBox.shrink() )
                                                      : const Text(
                                                          "me",
                                                          style: TextStyle(
                                                              fontSize: 7,
                                                              fontWeight: FontWeight.bold,
                                                              color: AppColors.pink),
                                                        ))),
                                        )
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              child: AutoCompleteTextField<UserModel>(
                                key: _key,
                                suggestions: listData
                                    .where((element) =>
                                        (userGroup.every((e) => (e.id != element.id)) &&
                                            element.id != FirebaseAuth.instance.currentUser?.uid))
                                    .toList(),
                                clearOnSubmit: false,
                                itemFilter: (item, query) =>
                                    item.email?.toLowerCase().startsWith(query.toLowerCase()) ??
                                    true,
                                itemSorter: (a, b) => 1,
                                itemSubmitted: (item) {
                                  setState(() {
                                    itemSelect = item;
                                  });
                                },
                                itemBuilder: (context, item) => ListTile(
                                  title: Text(
                                    item.email ?? "",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                style: const TextStyle(fontSize: 12),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  hintText: 'email người muốn thêm',
                                  hintStyle: TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8))),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            SizedBox(
                                width: 60,
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
