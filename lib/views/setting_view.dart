import 'package:app/AppColors.dart';
import 'package:app/model/Group.dart';
import 'package:app/state/GlobalData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  bool _isExpanded = false;
  final GlobalData dataController = Get.put(GlobalData());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      dataController.getGroups();
    });
  }

  void showCreateGroupDialog() {
    print(dataController.groups);
    final TextEditingController groupNameController = TextEditingController();
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text('Tạo không gian làm việc'),
          contentPadding: const EdgeInsets.all(16),
          content: TextField(
            controller: groupNameController,
            decoration: InputDecoration(
                labelText: "Tên không gian",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                )),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final groupName = groupNameController.text;
                if (groupName.isNotEmpty) {
                  dataController.createGroup(groupName);
                }
                Get.back();
              },
              child: Text('Tạo'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
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
                          'User Name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'user@example.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút cài đặt
                        // Chuyển đến màn hình cài đặt người dùng
                      },
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: const Icon(
                        Icons.settings,
                      )),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        // border:
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 60)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: AppColors.blue,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Hôm nay",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        // border:
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 60)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check,
                            color: AppColors.purple,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Hoàn thành",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        // border:

                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 60)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: AppColors.pink,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Yêu thích",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          )
                        ],
                      ))
                ],
              ),
              const Divider(),
              TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size(double.infinity, 60)),
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
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      )
                    ],
                  )),
              const Divider(),
              Column(
                children: [
                  ExpansionPanelList(
                    elevation: 1,
                    expandedHeaderPadding: EdgeInsets.zero,
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        _isExpanded = !isExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text(
                              "Không gian làm việc",
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: showCreateGroupDialog,
                            ),
                          );
                        },
                        body: Obx(() {
                          final List<Group> groups = dataController.groups;
                          if (groups.isEmpty) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                "Chưa có không gian nào!",
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: groups
                                  .map(
                                    (group) => TextButton(
                                      onPressed: () {
                                        // Xử lý khi nhấn vào nút của nhóm
                                        // Chuyển đến màn hình chi tiết nhóm
                                      },
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                                const Size(double.infinity, 60)),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            color: AppColors.orange,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            group.name,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade600),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        }),
                        isExpanded: _isExpanded,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
