import 'package:app/views/category/blocs/category_cubit.dart';
import 'package:app/views/category/widgets/dialog_add.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryButtonAdd extends StatelessWidget {
  const CategoryButtonAdd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.transparent,
            actions: [
              DialogAddCategory(
                callback: context.read<CategoryCubit>().getData,
              )
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        width: (MediaQuery.of(context).size.width - 24) / 2,
        padding: const EdgeInsets.all(8),
        height: 70,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: Colors.black12),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.black12,
          ),
        ),
      ),
    );
  }
}
