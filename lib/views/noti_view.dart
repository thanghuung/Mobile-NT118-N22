import 'package:app/AppColors.dart';
import 'package:app/fire_base/notifier_controller.dart';
import 'package:app/route_manager/route_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../model/notifier_model.dart';

class NotifierView extends StatefulWidget {
  const NotifierView({super.key});

  @override
  State<NotifierView> createState() => _NotifierViewState();
}

class _NotifierViewState extends State<NotifierView> {
  List<NotifierModel> listData = [];
  @override
  void initState() {
    functionListen();
    super.initState();
  }

  void functionListen() {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref(FirebaseAuth.instance.currentUser?.uid);
    databaseReference.onValue.listen((event) async {
      listData = await NotifierController.getListData();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Thông báo",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
                listData.length,
                (index) => GestureDetector(
                      onTap: () async {
                        EasyLoading.show();
                        await NotifierController.update(listData[index].id ?? "");
                        listData = await NotifierController.getListData();
                        setState(() {});
                        EasyLoading.dismiss();
                        Navigator.pushNamed(context, RouteManager.groupTaskScreen,
                            arguments: listData[index].groupID);
                      },
                      child: Stack(
                        children: [
                          Card(
                            color: listData[index].isSeen == false ? AppColors.pinkSecond : null,
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Bạn nhận được một task từ ${listData[index].nameGroup}",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text("Tên task: ${listData[index].nameTask ?? ""}"),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                        "Thời gian: ${listData[index].timeCreate.toString() ?? ""}"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (listData[index].isSeen == false)
                            Positioned(
                                right: 15,
                                top: 15,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(Radius.circular(10))),
                                ))
                        ],
                      ),
                    ))
          ],
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
