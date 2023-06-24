import 'package:app/AppColors.dart';
import 'package:app/model/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../component/AddTaskBottomSheet.dart';
import '../../category/blocs/category_cubit.dart';
import '../../category/widgets/dialog_add.dart';
class DetailTaskSetting extends StatefulWidget {
  final String categoryID;
  const DetailTaskSetting({Key? key, required this.categoryID}) : super(key: key);

  @override
  State<DetailTaskSetting> createState() => _DetailTaskSettingState();
}

class _DetailTaskSettingState extends State<DetailTaskSetting> {
  CategoryModel? group;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void _showAddTaskBottomSheet(BuildContext context, String categoryID, String nameCategory) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                  child: AddTaskBottomSheet(
                categoryID: group?.id ?? "",
                categoryName: group?.name ?? "",
                categoryDes: group?.description ?? "",
              ))),
        );
      },
    );
  }

  Future<CategoryModel> getData() async {
    EasyLoading.show();
    CategoryModel groupBox = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryID)
        .get()
        .then((value) {
      final a = CategoryModel.fromJson(value.data() ?? {});
      a.id = value.id;
      return a;
    });

    setState(() {
      group = groupBox;
    });
    EasyLoading.dismiss();
    return groupBox;
  }

  Future<void> deleteCategory() async {
    EasyLoading.show();
    await FirebaseFirestore.instance.collection("categories").doc(widget.categoryID).delete();
    final list = await FirebaseFirestore.instance
        .collection("tasks")
        .where("categoryID", isEqualTo: widget.categoryID)
        .get();
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var element in list.docs) {
      batch.delete(element.reference);
    }
    await batch.commit();
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
          "Cài đặt Thể loại cá nhân",
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
                  child: Row(
                    children: [
                      Expanded(
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
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Expanded(child: Center(child: Text(group?.description ?? ""))),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                      IconButton(onPressed: (){
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Colors.transparent,
                            actions: [
                              DialogAddCategory(
                                callback: (){
                                  getData();
                                },
                                categoryModel: group,
                              )
                            ],
                          ),
                        );
                      }, icon: const Icon(Icons.edit))
                    ],
                  ),
                ),
              ),

              /// Thành viên
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.pink),
                  onPressed: () {
                    _showAddTaskBottomSheet(context, group?.id ?? "", group?.name ?? "");
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
                                await deleteCategory();
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
                  child: Text("Xóa thể loại"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
