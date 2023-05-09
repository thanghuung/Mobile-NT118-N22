import 'package:app/AppColors.dart';
import 'package:app/common.dart';
import 'package:app/component/NoteComponent.dart';
import 'package:app/state/GlobalData.dart';
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
    // loadUpcomingTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<GlobalData>(
        init: dataController,
        initState: (_) {
          // Gọi hàm fetchTasksByUserId với user ID cần lấy tasks
          dataController.getUpcomingTasks();
        },
        builder: (controller) {
          if (controller.upcomingTasks.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: controller.upcomingTasks.length,
              itemBuilder: (context, index) {
                final task = controller.upcomingTasks[index];
                return NoteComponent(
                  id: task["id"],
                  content: task["content"],
                  description: task["description"],
                  isCompleted: task["isCompleted"],
                  category: task["categoryID"],
                  date: task["dateDone"],
                  backgroundColor: backgroundToColor(task["color"]),
                  priority: priorityToColor(task["priority"]),
                  onCheckboxChanged: (value) => setState(() {
                    task["isCompleted"] = !task["isCompleted"];
                  }),
                );
              },
            );
          }
        },
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