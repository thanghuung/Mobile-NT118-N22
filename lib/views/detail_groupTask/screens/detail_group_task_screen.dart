import 'package:app/route_manager/route_manager.dart';
import 'package:app/views/detail_groupTask/widgets/filter_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/detail_group_task_bloc.dart';
import '../widgets/list_item_task.dart';

class DetailGroupTaskScreen extends StatelessWidget {
  const DetailGroupTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailGroupTaskBloc, DetailGroupTaskState>(
      builder: (context, state) {
        final Widget body;
        if (state is DetailGroupTaskLoading) {
          body = Container();
        } else {
          body = ListItemGroupTask(
            key: UniqueKey(),
            listData: state.listData,
          );
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
              "Không gian làm việc",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteManager.settingGroupTaskScreen,
                      arguments: state.groupID);
                },
                icon: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(child: body),
              const FilterGroupTask(),
            ],
          ),
        );
      },
    );
  }
}
