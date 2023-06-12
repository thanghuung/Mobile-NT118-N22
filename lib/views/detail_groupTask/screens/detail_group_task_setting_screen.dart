import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../model/group_model.dart';

class DetailGroupTaskSettingScreen extends StatefulWidget {
  final String groupID;
  const DetailGroupTaskSettingScreen({Key? key, required this.groupID}) : super(key: key);

  @override
  State<DetailGroupTaskSettingScreen> createState() => _DetailGroupTaskSettingScreenState();
}

class _DetailGroupTaskSettingScreenState extends State<DetailGroupTaskSettingScreen> {
  Future<GroupModel>? group;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    group = getData();
  }

  Future<GroupModel> getData() async {
    EasyLoading.show();
    GroupModel groupBox = await FirebaseFirestore.instance
        .collection("group")
        .doc(widget.groupID)
        .get()
        .then((value) {
          return GroupModel.fromJson(value.data() ?? {});
        });
    EasyLoading.dismiss();
    return groupBox;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        scrolledUnderElevation: 3,
        title: const Text(
          "Cài đặt Không gian làm việc",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: group,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [Text("Name"), Text(snapshot.data?.name ?? "")],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
