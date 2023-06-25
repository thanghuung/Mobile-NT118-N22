import 'package:app/AppColors.dart';
import 'package:app/component/addGroupBottomSheet.dart';
import 'package:app/constants/routes.dart';
import 'package:app/fire_base/group_controller.dart';
import 'package:app/model/group_model.dart';
import 'package:app/route_manager/route_manager.dart';
import 'package:app/state/GlobalData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../services/auth/auth_service.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final GlobalData dataController = Get.put(GlobalData());
  final user = FirebaseAuth.instance.currentUser;
  Future<List<GroupModel>>? groups;

  @override
  void initState() {
    super.initState();
    loadGroup();
  }

  void loadGroup() {
    groups = GroupController.getGroups();
    setState(() {});
  }

  void showCreateGroupDialog(BuildContext context) {
    final TextEditingController groupNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('Tạo không gian làm việc'),
            contentPadding: const EdgeInsets.all(16),
            content: TextField(
              controller: groupNameController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  )),
            ),
            actions: [
              Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black, // Màu nền của nút
                        padding: const EdgeInsets.all(4), // Padding xung quanh nút
                      ),
                      child: const Text('Hủy'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final groupName = groupNameController.text;
                        if (groupName.isNotEmpty) {
                          // dataController.createGroup(groupName);
                        }
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pink, // Màu nền của nút
                        padding: const EdgeInsets.all(4), // Padding xung quanh nút
                      ),
                      child: const Text('Tạo'),
                    ),
                  ]))
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25, // Kích thước của Avatar
                  backgroundImage: NetworkImage(
                      'https://ath2.unileverservices.com/wp-content/uploads/sites/4/2020/02/IG-annvmariv.jpg'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.email ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        // user?.email??"",
                        "Đã xác minh",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text("Thông báo"),
                                content: Text("Bạn chắc chắn muốn đăng xuất"),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        await AuthService.firebase().logOut();
                                        Navigator.of(context).pushNamedAndRemoveUntil(
                                          RouteManager.welcomeRoute,
                                          (_) => false,
                                        );
                                      },
                                      child: Text("OK"))
                                ],
                              ));
                    },
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon(
                      Icons.exit_to_app,
                    )),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteManager.categoryScreen);
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 60)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.category,
                      color: AppColors.red,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Thể loại cá nhân",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    )
                  ],
                )),
            const Divider(),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Không gian làm việc",
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          useSafeArea: true,
                          builder: (context) => SingleChildScrollView(
                            child: Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: AddGroupBottomSheet(onCallback: loadGroup)),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<GroupModel>>(
                        future: groups,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Text("dang tai.."),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: () async{
                              loadGroup();
                            },
                            child: GridView.count(
                              primary: false,
                              padding: const EdgeInsets.all(20),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              children: (snapshot.data ?? [])
                                  .map(
                                    (group) => GestureDetector(
                                      onTap: () async {
                                        await Navigator.pushNamed(
                                            context, RouteManager.groupTaskScreen,
                                            arguments: group.id);
                                        loadGroup();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                                            border: Border.all(color: AppColors.pink)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              group.name ?? "",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: AppColors.pink,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Text(
                                                group.des ?? "",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("Thành viên: "),
                                                  Text((group.numUser ?? 0).toString())
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        }),
                  )
                ],
              ),
            )
          ])),
    );
  }
}
