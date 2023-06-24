import 'package:app/AppColors.dart';
import 'package:app/common.dart';
import 'package:app/fire_base/task_controller.dart';
import 'package:app/fire_base/user_controller.dart';
import 'package:app/model/task_model.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../model/group_model.dart';
import '../model/user_model.dart';

class NoteComponentGroupTask extends StatefulWidget {
  final String id;
  final String content;
  final String description;
  final String groupID;
  final String category;
  final bool isCompleted;
  final Color? backgroundColor;
  final Color priority;
  final Timestamp date;
  final Timestamp dateStart;
  final String userId;
  final String userEmail;

  const NoteComponentGroupTask({
    Key? key,
    required this.id,
    required this.content,
    required this.description,
    required this.category,
    required this.backgroundColor,
    required this.priority,
    required this.date,
    required this.isCompleted,
    required this.dateStart,
    required this.userId,
    required this.userEmail,
    required this.groupID,
  }) : super(key: key);

  @override
  State<NoteComponentGroupTask> createState() => _NoteComponentGroupTaskState();
}

class _NoteComponentGroupTaskState extends State<NoteComponentGroupTask> {
  Map<String, dynamic>? category;
  TaskModel? taskModel;
  @override
  void initState() {
    taskModel = TaskModel(
        isCompleted: widget.isCompleted,
        id: widget.id,
        content: widget.content,
        dateStart: widget.dateStart.toDate(),
        dateDone: widget.date.toDate(),
        description: widget.description,
        email: widget.userEmail,
        userID: widget.userId);
    super.initState();
    refreshData();
  }

  Future<void> refreshData() async {
    taskModel = await TaskController.getTask(widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: UniqueKey(),
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text(
                    widget.content,
                    style: const TextStyle(color: AppColors.pink),
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    DialogDetailTask(
                      groupID: widget.groupID,
                      id: widget.id,
                      userId: taskModel?.id ?? "",
                      email: taskModel?.email ?? "",
                      dateStart: taskModel?.dateStart ?? DateTime.now(),
                      content: widget.description,
                      des: widget.description,
                      dateEnd: taskModel?.dateDone ?? DateTime.now(),
                      isCompeted: taskModel?.isCompleted ?? false,
                      onCallBack: refreshData,
                    )
                  ],
                ));
      },
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: !(widget.isCompleted)
                    ? (widget.backgroundColor ?? Colors.white)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.content,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            decoration: (taskModel?.isCompleted == true)
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.description,
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.red.shade700,
                                size: 12,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formatDateFromTimestamp(
                                    Timestamp.fromDate(taskModel?.dateDone ?? DateTime.now())),
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            taskModel?.email ?? "",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Text(
              taskModel?.isCompleted == true
                  ? "Hoàn Thành"
                  : TaskController.getStatus(taskModel?.dateStart ?? DateTime.now(),
                      taskModel?.dateDone ?? DateTime.now()),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.pink),
            ),
          )
        ],
      ),
    );
  }
}

class DialogDetailTask extends StatefulWidget {
  final String id;
  final String email;
  final String userId;
  final DateTime dateStart;
  final String des;
  final String groupID;
  final String content;
  final DateTime dateEnd;
  final bool isCompeted;
  final Function onCallBack;
  const DialogDetailTask(
      {Key? key,
      required this.dateStart,
      required this.dateEnd,
      required this.isCompeted,
      required this.des,
      required this.content,
      required this.id,
      required this.onCallBack,
      required this.email,
      required this.userId,
      required this.groupID})
      : super(key: key);

  @override
  State<DialogDetailTask> createState() => _DialogDetailTaskState();
}

class _DialogDetailTaskState extends State<DialogDetailTask> {
  DateTime? selectedDateEnd;
  DateTime? selectedDateStart;
  GroupModel? group;
  List<UserModel> listDataSelect = [];
  List<UserModel> listData = [];
  List<UserModel> userGroup = [];
  UserModel? itemSelect;
  Future<GroupModel> getData() async {
    EasyLoading.show();
    GroupModel groupBox = await FirebaseFirestore.instance
        .collection("group")
        .doc(widget.groupID)
        .get()
        .then((value) {
      final a = GroupModel.fromJson(value.data() ?? {});
      a.id = value.id;
      return a;
    });

    List<UserModel> _userGroup = await FirebaseFirestore.instance
        .collection("userGroup")
        .where("groupID", isEqualTo: groupBox.id)
        .get()
        .then((value) {
      return value.docs.map((e) {
        final a = UserModel.fromJson(e.data());
        a.id = e.data()["userID"];
        return a;
      }).toList();
    });
    List<UserModel> _user =
        await FirebaseFirestore.instance.collection("users").get().then((value) {
      return value.docs.map((e) {
        final a = UserModel.fromJson(e.data());
        a.id = e.id;
        return a;
      }).toList();
    });
    setState(() {
      group = groupBox;
      listData = _user;
      userGroup = _user
          .where((element) => _userGroup.any((e) {
                print(e.id);
                print(element.id);
                return e.id == element.id;
              }))
          .toList();
    });

    EasyLoading.dismiss();
    return groupBox;
  }

  @override
  void initState() {
    selectedDateEnd = widget.dateEnd;
    selectedDateStart = widget.dateStart;
    getData();

    super.initState();
  }

  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateEnd ?? DateTime.now(),
      firstDate: selectedDateStart ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != selectedDateEnd) {
      setState(() {
        selectedDateEnd = picked;
      });
    }
  }

  Future<void> _selectDateStart(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateStart ?? DateTime.now(),
      firstDate: DateTime.parse("2022-06-20"),
      lastDate: selectedDateEnd ?? DateTime.now(),
    );

    if (picked != null && picked != selectedDateStart) {
      setState(() {
        selectedDateStart = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text("Mô tả: ", style: TextStyle(fontWeight: FontWeight.w200)),
            Expanded(
                child: Text(
              widget.des,
              textAlign: TextAlign.center,
            )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            const Text("Email: ", style: TextStyle(fontWeight: FontWeight.w200)),
            Expanded(
                child: Text(
              widget.email,
              textAlign: TextAlign.center,
            )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        if (!widget.isCompeted)
          Row(
            children: [
              const Text("Bàn giao: ", style: TextStyle(fontWeight: FontWeight.w200)),
              Expanded(
                  child: SizedBox(
                height: 40,
                child: AutoCompleteTextField<UserModel>(
                  controller: TextEditingController(text: itemSelect?.email),
                  key: GlobalKey(),
                  suggestions: userGroup,
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
                  style: TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    isDense: true,
                    hintText: 'email người muốn thêm',
                    hintStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                  ),
                ),
              )),
              const SizedBox(
                width: 8,
              ),
              GestureDetector(
                onTap: () async {
                  if (itemSelect != null) {
                    await TaskController.assign(
                        widget.id, itemSelect?.id ?? "", itemSelect?.email ?? "");
                    widget.onCallBack();
                    Navigator.pop(context);
                  }
                },
                child: const Icon(Icons.change_circle),
              )
            ],
          ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Bắt đầu: ", style: TextStyle(fontWeight: FontWeight.w200)),
            Expanded(
              child: Text(
                selectedDateStart == null ? 'Ngày bắt đầu' : formatDate(selectedDateStart!),
                textAlign: TextAlign.center,
              ),
            ), //
            if (!widget.isCompeted)
              IconButton(onPressed: () => _selectDateStart(context), icon: Icon(Icons.edit))
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Kết thúc: ", style: TextStyle(fontWeight: FontWeight.w200)),
            Expanded(
              child: Text(
                selectedDateEnd == null ? 'Ngày kết thúc' : formatDate(selectedDateEnd!),
                textAlign: TextAlign.center,
              ),
            ), // Chữ
            if (!widget.isCompeted)
              IconButton(onPressed: () => _selectDateEnd(context), icon: Icon(Icons.edit))
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Text(
              "Trạng thái: ",
              style: TextStyle(fontWeight: FontWeight.w200),
            ),
            Expanded(
                child: Text(
              TaskController.getStatus(
                  selectedDateStart ?? DateTime.now(), selectedDateEnd ?? DateTime.now()),
              textAlign: TextAlign.center,
            ))
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed:
                    ((selectedDateStart != widget.dateStart || selectedDateEnd != widget.dateEnd) &&
                            widget.isCompeted == false)
                        ? () async {
                            await TaskController.updateTask(
                                widget.id,
                                selectedDateStart ?? DateTime.now(),
                                selectedDateEnd ?? DateTime.now(),
                                widget.isCompeted);
                            Navigator.pop(context);
                            widget.onCallBack();
                          }
                        : null,
                child: const Text("Cập nhật")),
            ElevatedButton(
              onPressed: (!widget.isCompeted)
                  ? () async {
                      await TaskController.updateTask(
                        widget.id,
                        widget.dateStart,
                        widget.dateEnd,
                        true,
                      );
                      Navigator.pop(context);
                      widget.onCallBack();
                    }
                  : null,
              child: const Text("Hoàn thành"),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.pink),
            ),
          ],
        )
      ],
    );
  }
}
