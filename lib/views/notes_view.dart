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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 0,
        title: const Text("Hôm nay", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
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
                                content: task["content"]??"",
                                description: task["description"]??"",
                                status: task["status"]??"",
                                category: task["categoryID"]??"",
                                date: task["dateDone"]??"",
                                backgroundColor: backgroundToColor(task["color"]),
                                priority: priorityToColor(task["priority"]),
                                onCheckboxChanged: (value) => setState(() {
                                  task["isCompleted"] = !task["isCompleted"];
                                }),
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
                                id: task["id"]??"",
                                content: task["content"]??"",
                                description: task["description"]??"",
                                status: task["status"]??"",
                                category: task["categoryID"]??"",
                                date: task["dateDone"]??"",
                                backgroundColor: backgroundToColor(task["color"]),
                                priority: priorityToColor(task["priority"]),
                                onCheckboxChanged: (value) => setState(() {
                                  task["isCompleted"] = !task["isCompleted"];
                                }),
                              );
                            },
                          )
                        ],
                      );
                    }
                    return Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text(
                            "Trễ hạn",
                            style: AppFontText.title,
                          ),
                          TextButton(
                            child: Text("Đặt lại",
                                style: AppFontText.title.copyWith(color: AppColors.pink)),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Đặt lại công việc trễ hạn',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // SizedBox(height: 16),
                                        CalendarDatePicker(
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2100),
                                          onDateChanged: (DateTime? selectedDate) {
                                            // Xử lý khi ngày được chọn
                                          },
                                        ),
                                        // SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Xử lý khi nhấn nút "Đặt"
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.pink, // Màu nền của nút
                                            padding:
                                                const EdgeInsets.all(4), // Padding xung quanh nút
                                          ),
                                          child: const Text(
                                            'Đặt',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ]),
                        const SizedBox(
                          height: 14,
                        ),
                        upcomingView,
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
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RouteManager.detailTaskScreen);
                          },
                          child: const Text(
                            "Xem tất cả",
                            style: TextStyle(color: AppColors.pink),
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
