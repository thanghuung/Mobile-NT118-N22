import 'package:app/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common.dart';
import '../component/NoteComponent.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<Map<String, dynamic>>? listData = null;

  TextEditingController _searchInput = TextEditingController();
  Future<void> getData() async {
    if (_searchInput.text.trim() != "") {
      EasyLoading.show();
      final collectionRef = FirebaseFirestore.instance.collection('tasks');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userId') ?? "";
      var querySnapshot = await collectionRef.where('userID', isEqualTo: userId).get();

      // Xóa danh sách cũ trước khi thêm dữ liệu mới1
      listData = [];
      for (var doc in querySnapshot.docs) {
        if ((doc['content'] as String).contains(_searchInput.text)) {
          Map<String, dynamic> taskData = doc.data();
          taskData['id'] = doc.id; // Lấy ID của category
          listData?.add(taskData);
        }
      }

      if (querySnapshot.docs.isEmpty) {
        listData = [];
      }
      setState(() {});
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leadingWidth: 0,
          elevation: 0,
          scrolledUnderElevation: 3,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width - 32,
                child: TextFormField(
                  controller: _searchInput,
                  onChanged: (value) {
                    getData(); // Gọi hàm tìm kiếm khi giá trị thay đổi
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: AppColors.pink,
                      border: OutlineInputBorder(),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: AppColors.pink))),
                ),
              )
            ],
          ),
        ),
        body: listData == null
            ? const Center(
                child: Text(
                  "Vui nhập từ khóa để tìm kiếm",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : (listData?.isEmpty ?? false
                ? const Center(
                    child: Text("Danh sách trống"),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ...(listData ?? [])
                              .map(
                                (task) => NoteComponent(
                                  dateStart: task["dateStart"],
                                  id: task["id"],
                                  content: task["content"],
                                  description: task["description"],
                                  isCompleted: task["isCompleted"],
                                  category: task["categoryID"],
                                  date: task["dateDone"],
                                  backgroundColor: backgroundToColor(task["color"]),
                                  priority: priorityToColor(task["priority"]),
                                ),
                              )
                              .toList()
                        ],
                      ),
                    ),
                  )),
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      }).then((value) => value ?? false);
}

// actions: [
//           PopupMenuButton<MenuAction>(
//             onSelected: (value) async {
//               switch (value) {
//                 case MenuAction.logout:
//                   final shouldLogout = await showLogOutDialog(context);
//                   if (shouldLogout) {
//                     await AuthService.firebase().logOut();
//                     Navigator.of(context).pushNamedAndRemoveUntil(
//                       loginRoute,
//                       (_) => false,
//                     );
//                   }
//               }
//             },
//             itemBuilder: (context) {
//               return const [
//                 PopupMenuItem<MenuAction>(
//                   value: MenuAction.logout,
//                   child: Text('Logout'),
//                 )
//               ];
//             },
//           )
