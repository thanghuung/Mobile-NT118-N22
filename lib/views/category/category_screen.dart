import 'package:app/AppColors.dart';
import 'package:app/route_manager/route_manager.dart';
import 'package:app/views/category/blocs/category_cubit.dart';
import 'package:app/views/category/blocs/category_cubit.dart';
import 'package:app/views/category/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/category_button_add.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final Widget body;
        if (state is CategoryLoading) {
          body = Container();
        } else {
          body = SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16),
              child: Wrap(
                children: [
                  ...List.generate(
                    state.listData.length,
                    (index) => GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RouteManager.detailTaskScreen,
                            arguments: state.listData[index].id);
                      },
                      child: CategoryItem(
                        title: state.listData[index].name ?? "",
                        countWork: state.listData[index].countWork ?? 0,
                      ),
                    ),
                  ),
                  const CategoryButtonAdd()
                ],
              ),
            ),
          );
        }
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                "Thể loại cá nhân",
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

            ),
            body: body);
      },
    );
  }
}
