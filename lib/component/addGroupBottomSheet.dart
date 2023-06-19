import 'package:app/AppColors.dart';
import 'package:app/component/FormGroup.dart';
import 'package:app/fire_base/group_controller.dart';
import 'package:app/fire_base/user_controller.dart';
import 'package:app/model/group_model.dart';
import 'package:app/state/GlobalData.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';

class AddGroupBottomSheet extends StatefulWidget {
  final Function onCallback;
  const AddGroupBottomSheet({super.key, required this.onCallback});
  @override
  State<AddGroupBottomSheet> createState() => _AddGroupBottomSheetState();
}

class _AddGroupBottomSheetState extends State<AddGroupBottomSheet> {
  final dataController = Get.find<GlobalData>();
  List<Map<String, dynamic>> categories = [];
  late final TextEditingController _content;
  late final TextEditingController _description;
  final _formKey = GlobalKey<FormState>();
  List<UserModel> listData = [];
  List<UserModel> listDataSelect = [];
  UserModel? itemSelect;

  @override
  void initState() {
    _content = TextEditingController();
    _description = TextEditingController();
    super.initState();
    getListUserName();
  }

  Future<void> getListUserName() async {
    listData = await UserController.getListData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  'Tạo Nhóm mới',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                const SizedBox(height: 16),
                FormGroup(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  controller: _content,
                  hintText: "Tên Nhóm",
                  label: "Tên Nhóm",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nội dung không được để trống!';
                    }
                    return null;
                  },
                  isPassword: false,
                ),
                const SizedBox(height: 16),
                FormGroup(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  controller: _description,
                  hintText: "Nhập mô tả",
                  label: "Mô tả",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Môt không được để trống!';
                    }
                    return null;
                  },
                  isPassword: false,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Thành viên",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
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
                          controller: TextEditingController(text: itemSelect?.email),
                          key: GlobalKey(),
                          suggestions: listData
                              .where((element) =>
                                  (listDataSelect.every((e) => (e.id != element.id)) &&
                                      element.id != FirebaseAuth.instance.currentUser?.uid))
                              .toList(),
                          clearOnSubmit: false,
                          itemFilter: (item, query) =>
                              item.email?.toLowerCase().startsWith(query.toLowerCase()) ?? true,
                          itemSorter: (a, b) => 1,
                          itemSubmitted: (item) => setState(() {
                            itemSelect = item;
                          }),
                          itemBuilder: (context, item) => ListTile(
                            title: Text(item.email ?? ""),
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter a name',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      SizedBox(
                          width: 80,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: itemSelect != null
                                  ? () {
                                      listDataSelect.add(itemSelect!);
                                      setState(() {
                                        itemSelect = null;
                                      });
                                    }
                                  : null,
                              child: const Text("Thêm")))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ...listDataSelect
                    .map((e) => Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                              border: Border.all(width: 1)),
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
                                    onPressed: () {
                                      setState(() {
                                        listDataSelect.remove(e);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      size: 15,
                                    )),
                              )
                            ],
                          ),
                        ))
                    .toList(),
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        EasyLoading.show();
                        await GroupController.addGroup(GroupModel(
                            name: _content.text,
                            des: _description.text,
                            userModels: listDataSelect));
                        widget.onCallback();
                        Navigator.pop(context);
                        EasyLoading.dismiss();
                      } else {}
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.pink),
                    child: const Text("Tạo"),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
