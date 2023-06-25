import 'package:app/AppColors.dart';
import 'package:app/fire_base/categories_controller.dart';
import 'package:app/fire_base/group_controller.dart';
import 'package:app/fire_base/task_controller.dart';
import 'package:app/model/category_model.dart';
import 'package:app/model/group_model.dart';
import 'package:app/views/category/blocs/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DialogEditInfoTask extends StatefulWidget {
  final String name;
  final String des;
  final String id;
  final Function callback;
  const DialogEditInfoTask(
      {Key? key, required this.callback, required this.name, required this.des, required this.id})
      : super(key: key);

  @override
  State<DialogEditInfoTask> createState() => _DialogEditInfoTaskState();
}

class _DialogEditInfoTaskState extends State<DialogEditInfoTask> {
  late final TextEditingController _name = TextEditingController(text: widget.name);
  late final TextEditingController _des = TextEditingController(text: widget.des);

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _keyForm,
              child: Column(
                children: [
                  const Text(
                    "Chỉnh sửa thông tin task",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _name,
                    validator: (text) {
                      if (text == "") return "Tên chủ đề không được để trống!";
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "Tên thể loại"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _des,
                    validator: (text) {
                      if (text == "") return "Tên chủ đề không được để trống!";
                      return null;
                    },
                    decoration:
                        const InputDecoration(border: OutlineInputBorder(), hintText: "Mô tả"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_keyForm.currentState?.validate() == true) {
                          EasyLoading.show();
                          await TaskController.updateInfoTask(
                            widget.id ?? "",
                            _name.text,
                            _des.text,
                          );
                          await widget.callback();
                          EasyLoading.dismiss();
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.pink),
                      child: Text("Cập nhật"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
