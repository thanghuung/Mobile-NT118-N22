import 'package:app/AppColors.dart';
import 'package:app/common.dart';
import 'package:app/component/FormGroup.dart';
import 'package:app/state/GlobalData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

enum TaskColor { pink, purple, blue, yellow }

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final dataController = Get.find<GlobalData>();
  List<Map<String, dynamic>> categories = [];
  late final TextEditingController _content;
  late final TextEditingController _description;
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  String selectedPriority = "Không ưu tiên";
  TaskColor selectedColor = TaskColor.pink;
  Map<String, dynamic>? selectedCategory;

  @override
  void initState() {
    _content = TextEditingController();
    _description = TextEditingController();
    super.initState();
    loadCategories();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void loadCategories() async {
    List<Map<String, dynamic>> loadedCategories = await getAllCategories();
    print("category: $loadedCategories");

    setState(() {
      categories = loadedCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
      padding: const EdgeInsets.all(16),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text(
                'Tạo mới công việc',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )),
              const SizedBox(height: 16),
              FormGroup(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                controller: _content,
                hintText: "Nhập nội dung",
                label: "Nội dung",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nội dung không được để trống!';
                  }
                  return null;
                },
                isPassword: false,
              ),
              const SizedBox(height: 16),
              FormGroup(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                controller: _description,
                hintText: "Nhập mô tả",
                label: "Mô tả",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Môt không được để trống!';
                  }
                  return null;
                },
                isPassword: false,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.calendar_today), // Biểu tượng (icon)
                    label: Text(
                      selectedDate == null ? 'Chọn ngày' : formatDate(selectedDate!),
                    ), // Chữ
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Màu nền của button
                      foregroundColor: Colors.grey.shade600,
                      padding: EdgeInsets.all(12),
                      side: BorderSide(color: Colors.grey.shade600, width: 1), // Padding cho button
                    ),
                  ),
                  const SizedBox(width: 20),
                  DropdownButton<String>(
                    value: selectedPriority,
                    onChanged: (String? newValue) async {
                      setState(() {
                        selectedPriority = newValue!;
                      });
                    },
                    items: <String>[
                      'Rất quan trọng',
                      'Quan trọng',
                      'Bình thường',
                      'Không ưu tiên',
                    ].map<DropdownMenuItem<String>>((String value) {
                      Color flagColor;
                      switch (value) {
                        case 'Rất quan trọng':
                          flagColor = AppColors.red;
                          break;
                        case 'Quan trọng':
                          flagColor = AppColors.purple;
                          break;
                        case 'Bình thường':
                          flagColor = AppColors.blue;
                          break;
                        case 'Không ưu tiên':
                          flagColor = Colors.grey;
                          break;
                        default:
                          flagColor = Colors.grey;
                          break;
                      }

                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.flag,
                              color: flagColor,
                            ),
                            const SizedBox(width: 8.0),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                width: 50,
                height: 40, // Adjust the width as needed
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: _getColor(selectedColor),
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButtonFormField<TaskColor>(
                  value: selectedColor,
                  onChanged: (color) {
                    setState(() {
                      selectedColor = color!;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                  iconSize: 24,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.color_lens,
                      color: Colors.black,
                    ),
                  ),
                  items: TaskColor.values.map((TaskColor color) {
                    return DropdownMenuItem<TaskColor>(
                      value: color,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Icon(
                          Icons.circle,
                          color: _getColor(color),
                          size: 16,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              DropdownButton<Map<String, dynamic>>(
                hint: const Text("Chọn thể loại"),
                value: selectedCategory, // Giá trị category được chọn
                onChanged: (Map<String, dynamic>? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                items: categories.map<DropdownMenuItem<Map<String, dynamic>>>((category) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: category,
                    child: Text(category['categoryName']),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    } else {
                      return;
                    }
                    if (selectedDate == null) {
                      showToast("Hãy chọn ngày kết thúc của công việc!");
                      return;
                    }

                    if (selectedCategory == null) {
                      showToast("Hãy chọn thể loại của công việc!");
                      return;
                    }
                    EasyLoading.show();
                    String color = selectedColor.toString().split('.').last;
                    await dataController.addTaskToFirebase(_content.text, _description.text, color,
                        selectedPriority, selectedCategory, selectedDate);
                    EasyLoading.dismiss();
                    Navigator.of(context).pop(); // Đóng bottom sheet sau khi tạo task
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    backgroundColor: AppColors.purple, // Màu nền hồng
                    foregroundColor: Colors.white, // Màu chữ trắng
                  ),
                  child: const Text(
                    'Tạo công việc',
                  ),
                ),
              )
            ],
          )),
    );
  }

  Color _getColor(TaskColor color) {
    switch (color) {
      case TaskColor.pink:
        return AppColors.pinkSecond;
      case TaskColor.purple:
        return AppColors.purpleTertiary;
      case TaskColor.blue:
        return AppColors.blueSecond;
      case TaskColor.yellow:
        return AppColors.yellow;
      default:
        return Colors.transparent;
    }
  }

  String _getColorName(TaskColor color) {
    switch (color) {
      case TaskColor.pink:
        return 'Màu hồng';
      case TaskColor.purple:
        return 'Màu tím';
      case TaskColor.blue:
        return 'Màu xanh';
      case TaskColor.yellow:
        return 'Màu vàng';
      default:
        return '';
    }
  }
}
