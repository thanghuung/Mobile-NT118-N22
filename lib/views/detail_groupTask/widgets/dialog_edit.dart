import 'package:app/AppColors.dart';
import 'package:app/fire_base/categories_controller.dart';
import 'package:app/fire_base/group_controller.dart';
import 'package:app/model/category_model.dart';
import 'package:app/model/group_model.dart';
import 'package:app/views/category/blocs/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DialogEdit extends StatefulWidget {
  final GroupModel? groupModel;
  final Function callback;
  const DialogEdit({Key? key,required this.callback, this.groupModel}) : super(key: key);

  @override
  State<DialogEdit> createState() => _DialogEditState();
}

class _DialogEditState extends State<DialogEdit> {
  late final TextEditingController _name = TextEditingController(text: widget.groupModel?.name?? "");
  late final TextEditingController _des = TextEditingController(text: widget.groupModel?.des?? "");

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
          margin: const EdgeInsets.all(32),
          decoration:  const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _keyForm,
              child: Column(
                children: [
                  const Text("Chỉnh sửa thông tin group", style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _name,
                    validator: (text) {
                      if (text == "") return "Tên chủ đề không được để trống!";
                      return null;
                    },
                    decoration:
                    const InputDecoration(border: OutlineInputBorder(), hintText: "Tên thể loại"),
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
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Mô tả"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: () async {
                      if(_keyForm.currentState?.validate() == true){
                        if(widget.groupModel != null){
                          EasyLoading.show();
                          await GroupController.updateInfoGroup(widget.groupModel?.id ?? "", _name.text, _des.text,);
                          await widget.callback();
                          EasyLoading.dismiss();
                          Navigator.pop(context);
                        }
                        else{
                          EasyLoading.show();
                          await CategoryController.addData(_name.text, _des.text);
                          await widget.callback();
                          EasyLoading.dismiss();
                          Navigator.pop(context);
                        }
                      }
                    }, style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pink
                    ), child: widget.groupModel == null? Text("Thêm"): Text("Cập nhật"),),
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
