import 'package:app/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class NoteComponent extends StatefulWidget {
  final String id;
  final String content;
  final String description;
  final bool isCompleted;
  final String category;
  final Color? backgroundColor;
  final Color priority;
  final Timestamp date;
  final Function(bool?) onCheckboxChanged;

  const NoteComponent({
    Key? key,
    required this.id,
    required this.content,
    required this.description,
    required this.isCompleted,
    required this.category,
    required this.backgroundColor,
    required this.priority,
    required this.date,
    required this.onCheckboxChanged,
  }) : super(key: key);

  @override
  State<NoteComponent> createState() => _NoteComponentState();
}

class _NoteComponentState extends State<NoteComponent> {
  Map<String, dynamic>? category;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final Map<String, dynamic>? fetchedCategory =
        await getCategoryById(widget.category);
    if (fetchedCategory != null) {
      setState(() {
        category = fetchedCategory;
      });
    } else {
      // Xử lý trường hợp không tìm thấy category
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: !widget.isCompleted
              ? (widget.backgroundColor ?? Colors.white)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              EasyLoading.show();
              CollectionReference tasks =
                  FirebaseFirestore.instance.collection('tasks');
              await tasks
                  .doc(widget.id)
                  .update({'isCompleted': !widget.isCompleted}).then(
                      (value) => print("tasks Updated"));
              widget.onCheckboxChanged.call(!widget.isCompleted);
              EasyLoading.dismiss();
            },
            child: Container(
              width: 20, // Chiều rộng của checkbox
              height: 20, // Chiều cao của checkbox
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Hình dạng hình tròn cho checkbox
                border: Border.all(
                    color: widget.priority,
                    width: 2), // Viền màu hồng cho checkbox
                color: widget.isCompleted
                    ? widget.priority
                    : Colors
                        .white, // Màu hồng khi được check, màu trong suốt khi chưa được check
              ),
            ),
          ),
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
                    decoration: widget.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.description,
                style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
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
                        formatDateFromTimestamp(widget.date),
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
                    category != null ? category!["categoryName"] : "",
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
    );
  }
}


// Dismissible(
//         key: Key(widget.id),
//         direction: DismissDirection.startToEnd,
//         background: Container(
//           color: Colors.red,
//           alignment: Alignment.centerLeft,
//           padding: EdgeInsets.only(left: 16),
//           child: Icon(
//             Icons.delete,
//             color: Colors.white,
//           ),
//         ),
//         onDismissed: (direction) {
//           // Xử lý khi vuốt để xóa
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Xác nhận xóa'),
//                 content: Text('Bạn có chắc chắn muốn xóa ghi chú này?'),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('Hủy'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       // Xử lý xóa ghi chú
//                       // ...
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('Xóa'),
//                   ),
//                 ],
//               );
//             },
//           );
//         },