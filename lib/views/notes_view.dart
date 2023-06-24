import 'package:app/AppColors.dart';
import 'package:app/common.dart';
import 'package:app/component/NoteComponent.dart';
import 'package:app/route_manager/route_manager.dart';
import 'package:app/state/GlobalData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final GlobalData dataController = Get.put(GlobalData());
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        title: const Text("Todos", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.pink,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 3,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          dataController.getUpcomingTasks();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                GetX<GlobalData>(
                  init: dataController,
                  initState: (_) {
                    // Gọi hàm fetchTasksByUserId với user ID cần lấy tasks
                    dataController.getUpcomingTasks();
                  },
                  builder: (controller) {
                    final upcomingView;
                    final todayView;
                    if (controller.upcomingTasks.length == 1 &&
                        controller.upcomingTasks[0]['loading'] == true) {
                      upcomingView = const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (controller.upcomingTasks.isEmpty ?? false) {
                      upcomingView = const Center(
                        child: Text("Danh sách trống!"),
                      );
                    } else {
                      upcomingView = Column(
                        children: [
                          ...List.generate(
                            controller.upcomingTasks.length,
                            (index) {
                              final task = controller.upcomingTasks[index] ?? {};
                              return NoteComponent(
                                id: task["id"],
                                dateStart: task["dateStart"],
                                content: task["content"] ?? "",
                                description: task["description"] ?? "",
                                isCompleted: task["isCompleted"] ?? false,
                                category: task["categoryID"] ?? "",
                                date: task["dateDone"] ?? "",
                                backgroundColor: backgroundToColor(task["color"]),
                                priority: priorityToColor(task["priority"]),
                              );
                            },
                          )
                        ],
                      );
                    }
                    if (controller.todayTasks.length == 1 &&
                        controller.todayTasks[0]['loading'] == true) {
                      todayView = const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (controller.todayTasks.isEmpty ?? false) {
                      todayView = const Center(
                        child: Text("Danh sách trống!"),
                      );
                    } else {
                      todayView = Column(
                        children: [
                          ...List.generate(
                            controller.todayTasks.length,
                            (index) {
                              final task = controller.todayTasks[index] ?? {};
                              return NoteComponent(
                                id: task["id"] ?? "",
                                content: task["content"] ?? "",
                                dateStart: task["dateStart"],
                                description: task["description"] ?? "",
                                isCompleted: task["isCompleted"],
                                category: task["categoryID"] ?? "",
                                date: task["dateDone"] ?? "",
                                backgroundColor: backgroundToColor(task["color"]),
                                priority: priorityToColor(task["priority"]),
                              );
                            },
                          )
                        ],
                      );
                    }
                    return Column(
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  "Trễ hạn",
                                  textAlign: TextAlign.start,
                                  style: AppFontText.title,
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                upcomingView,
                              ],
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Hôm nay - ${DateTime.now().day} tháng ${DateTime.now().month}, ${DateTime.now().year}",
                                      style: AppFontText.title,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                todayView,
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: ElevatedButton(

                            onPressed: () {
                              Navigator.pushNamed(context, RouteManager.detailTaskScreen);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.pink,
                            ),
                            child: Text(
                              "Xem tất cả".toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // const Expanded(child: SizedBox(
                //   height: 400,
                //   width: 100,
                // ))
              ],
            ),
          ),
        ),
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
