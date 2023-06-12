import 'package:app/AppColors.dart';
import 'package:app/common.dart';
import 'package:app/fire_base/task_controller.dart';
import 'package:app/model/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteComponent extends StatefulWidget {
  final String id;
  final String content;
  final String description;
  final String category;
  final bool isCompleted;
  final Color? backgroundColor;
  final Color priority;
  final Timestamp date;
  final Timestamp dateStart;

  const NoteComponent({
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
  }) : super(key: key);

  @override
  State<NoteComponent> createState() => _NoteComponentState();
}

class _NoteComponentState extends State<NoteComponent> {
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
    );
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
                    style: TextStyle(color: AppColors.pink),
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    DialogDetailTask(
                      id: widget.id,
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
                Column(
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
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          category != null ? category!["categoryName"] ?? "" : "",
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    )
                  ],
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
  final DateTime dateStart;
  final String des;
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
      required this.onCallBack})
      : super(key: key);

  @override
  State<DialogDetailTask> createState() => _DialogDetailTaskState();
}

class _DialogDetailTaskState extends State<DialogDetailTask> {
  DateTime? selectedDateEnd;
  DateTime? selectedDateStart;

  @override
  void initState() {
    selectedDateEnd = widget.dateEnd;
    selectedDateStart = widget.dateStart;
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
    return Container(
      child: Column(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Bắt đầu: ", style: TextStyle(fontWeight: FontWeight.w200)),
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.calendar_today,
                    size: 15,
                  ), // Biểu tượng (icon)
                  label: Text(
                    selectedDateStart == null ? 'Ngày bắt đầu' : formatDate(selectedDateStart!),
                  ), // Chữ
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Màu nền của button
                    foregroundColor: Colors.grey.shade600,
                    padding: EdgeInsets.all(12),
                    side: BorderSide(color: Colors.grey.shade600, width: 1), // Padding cho button
                  ),
                ),
              ),
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
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.calendar_today,
                    size: 15,
                  ),
                  label: Text(
                    selectedDateEnd == null ? 'Ngày kết thúc' : formatDate(selectedDateEnd!),
                  ), // Chữ
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Màu nền của button
                    foregroundColor: Colors.grey.shade600,
                    padding: const EdgeInsets.all(12),
                    side: BorderSide(color: Colors.grey.shade600, width: 1), // Padding cho button
                  ),
                ),
              ),
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
                  onPressed: ((selectedDateStart != widget.dateStart ||
                              selectedDateEnd != widget.dateEnd) &&
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
      ),
    );
  }
}
