import 'package:app/component/NoteComponent.dart';
import 'package:app/views/detail_task/blocs/detail_task_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../common.dart';
import '../../../model/task_model.dart';

class ListItemTask extends StatelessWidget {
  final List<TaskModel> listData;
  const ListItemTask({Key? key, required this.listData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            ...listData
                .map((e) {
                  return NoteComponent(
                    id: e.id ?? "",
                    content: e.content ?? "",
                    description: e.description ?? "",
                    isCompleted: e.isCompleted ?? false,
                    category: e.categoryID ?? "",
                    backgroundColor: backgroundToColor(e.color ?? ""),
                    priority: priorityToColor(e.priority ?? ""),
                    dateStart: Timestamp.fromDate(e.dateStart ?? DateTime.now()),
                    date: Timestamp.fromDate(e.dateDone ?? DateTime.now()));
                })
                .toList()
          ],
        ),
      ),
    );
  }
}
