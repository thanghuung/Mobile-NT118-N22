import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meta/meta.dart';

import '../../../fire_base/task_controller.dart';
import '../../../model/task_model.dart';

part 'detail_task_event.dart';
part 'detail_task_state.dart';

class DetailTaskBloc extends Bloc<DetailTaskEvent, DetailTaskState> {
  final String? categoryID;
  DetailTaskBloc(this.categoryID) : super(DetailTaskLoading([], categoryID)) {
    on<DetailTaskEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<OnGetData>((event, emit) async {
      EasyLoading.show();
      switch (event.status ?? "all") {
        case "all":
          final listData =
              await TaskController.getListData(TaskParam(), category: state.categoriesID);
          emit(DetailTaskHasData(listData, state.categoriesID));
          break;
        default:
          final listData = await TaskController.getListData(
              TaskParam(status: event.status, categoryID: state.categoriesID),
              category: state.categoriesID);
          emit(DetailTaskHasData(listData, state.categoriesID));
          break;
      }
      EasyLoading.dismiss();
    });
  }
}
