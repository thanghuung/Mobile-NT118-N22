import 'package:app/AppColors.dart';
import 'package:app/fire_base/categories_controller.dart';
import 'package:app/views/category/blocs/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DialogAddCategory extends StatelessWidget {
  final Function callback;
  DialogAddCategory({Key? key,required this.callback}) : super(key: key);

  final TextEditingController _name = TextEditingController();
  final TextEditingController _des = TextEditingController();

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
                    EasyLoading.show();
                    await CategoryController.addData(_name.text, _des.text);
                    await callback();
                    EasyLoading.dismiss();
                    Navigator.pop(context);
                  }
                }, style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pink
                ), child: Text("Thêm"),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
