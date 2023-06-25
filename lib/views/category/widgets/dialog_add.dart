import 'package:app/AppColors.dart';
import 'package:app/fire_base/categories_controller.dart';
import 'package:app/model/category_model.dart';
import 'package:app/views/category/blocs/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DialogAddCategory extends StatefulWidget {
  final CategoryModel? categoryModel;
  final Function callback;
  const DialogAddCategory({Key? key,required this.callback, this.categoryModel}) : super(key: key);

  @override
  State<DialogAddCategory> createState() => _DialogAddCategoryState();
}

class _DialogAddCategoryState extends State<DialogAddCategory> {
  late final TextEditingController _name = TextEditingController(text: widget.categoryModel?.name?? "");
  late final TextEditingController _des = TextEditingController(text: widget.categoryModel?.description?? "");

  @override
  void initState() {
    super.initState();
  }
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const Text("Thêm thể loại cá nhân", style: TextStyle(
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
                    if(widget.categoryModel != null){
                      EasyLoading.show();
                      await CategoryController.editData(_name.text, _des.text, widget.categoryModel?.id ?? "");
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
                ), child: widget.categoryModel == null? Text("Thêm"): Text("Cập nhật"),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
