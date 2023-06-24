import 'package:app/AppColors.dart';
import 'package:app/common.dart';
import 'package:app/component/FormGroup.dart';
import 'package:app/state/GlobalData.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';

enum TaskColor { pink, purple, blue, yellow }

void showAddTaskGroupBottomSheet(BuildContext context, List<UserModel> list, String idGroup) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    useSafeArea: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
                child: AddTaskGroup(
              userModel: list,
              idGroup: idGroup,
            ))),
      );
    },
  );
}

class AddTaskGroup extends StatefulWidget {
  final List<UserModel> userModel;
  final String idGroup;
  const AddTaskGroup({super.key, required this.userModel, required this.idGroup});
  @override
  State<AddTaskGroup> createState() => _AddTaskGroupState();
}

class _AddTaskGroupState extends State<AddTaskGroup> {
  final dataController = Get.find<GlobalData>();
  List<Map<String, dynamic>> categories = [];
  late final TextEditingController _content;
  late final TextEditingController _description;
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDateEnd;
  DateTime? selectedDateStart;
  String selectedPriority = "Không ưu tiên";
  TaskColor selectedColor = TaskColor.pink;
  Map<String, dynamic>? selectedCategory;
  UserModel? itemSelect;
  final GlobalKey<AutoCompleteTextFieldState<UserModel>> _key =  GlobalKey<AutoCompleteTextFieldState<UserModel>>();

  @override
  void initState() {
    _content = TextEditingController();
    _description = TextEditingController();
    super.initState();
    loadCategories();
  }

  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
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
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null && picked != selectedDateStart) {
      setState(() {
        selectedDateStart = picked;
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
              const Text(
                "Giao Phó",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              ),
              AutoCompleteTextField<UserModel>(
                key: _key,
                suggestions: (widget.userModel)
                    .where((element) => ([itemSelect].every((e) => (e?.id != element.id))))
                    .toList(),
                clearOnSubmit: false,
                textSubmitted: (_String){
                  print(_String);
                },
                itemFilter: (item, query) =>
                    item.email?.toLowerCase().startsWith(query.toLowerCase()) ?? true,
                itemSorter: (a, b) => 1,
                itemSubmitted: (item) => setState(() {
                  itemSelect = item;
                  setState(() {

                  });
                }),
                itemBuilder: (context, item) => ListTile(
                  title: Text(item.email ?? ""),
                ),
                decoration: const InputDecoration(
                  hintText: 'Nhập email',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _selectDateStart(context),
                    icon: Icon(Icons.calendar_today), // Biểu tượng (icon)
                    label: Text(
                      selectedDateStart == null
                          ? 'Chọn ngày bắt đầu'
                          : formatDate(selectedDateStart!),
                    ), // Chữ
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Màu nền của button
                      foregroundColor: Colors.grey.shade600,
                      padding: EdgeInsets.all(12),
                      side: BorderSide(color: Colors.grey.shade600, width: 1), // Padding cho button
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _selectDateEnd(context),
                    icon: Icon(Icons.calendar_today), // Biểu tượng (icon)
                    label: Text(
                      selectedDateEnd == null ? 'Chọn ngày kết thúc' : formatDate(selectedDateEnd!),
                    ), // Chữ
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Màu nền của button
                      foregroundColor: Colors.grey.shade600,
                      padding: EdgeInsets.all(12),
                      side: BorderSide(color: Colors.grey.shade600, width: 1), // Padding cho button
                    ),
                  ),
                  const SizedBox(height: 16),
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
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    } else {
                      return;
                    }
                    if (selectedDateEnd == null) {
                      showToast("Hãy chọn ngày kết thúc của công việc!");
                      return;
                    }
                    if (itemSelect == null) {
                      showToast("Hãy chọn người để giao phó!");
                      return;
                    }
                    if (selectedDateStart == null) {
                      showToast("Hãy chọn ngày bắt đầu của công việc!");
                      return;
                    }
                    EasyLoading.show();
                    String color = selectedColor.toString().split('.').last;
                    await dataController.addTaskToFirebase(_content.text, _description.text, color,
                        selectedPriority, selectedCategory, selectedDateEnd, selectedDateStart,
                        idUser: itemSelect?.id, idGroup: widget.idGroup, email: itemSelect?.email);
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
              ),
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
