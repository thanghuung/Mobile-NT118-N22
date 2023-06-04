import 'package:app/views/detail_task/blocs/detail_task_bloc.dart';
import 'package:app/views/detail_task/widgets/filter_task.dart';
import 'package:app/views/detail_task/widgets/list_item_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailTaskScreen extends StatelessWidget {
  const DetailTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailTaskBloc, DetailTaskState>(
      builder: (context, state) {
        final Widget body;
        if (state is DetailTaskLoading) {
          body = Container();
        } else {
          body = ListItemTask(listData: state.listData);
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              "Chi tiết công việc",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Column(
            children: [ Expanded(child: body), const FilterTask(),],
          ),
        );
      },
    );
  }
}
