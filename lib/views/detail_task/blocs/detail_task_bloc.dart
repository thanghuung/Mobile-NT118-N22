import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meta/meta.dart';

import '../../../fire_base/user_controller.dart';
import '../../../model/task_model.dart';

part 'detail_task_event.dart';
part 'detail_task_state.dart';

class DetailTaskBloc extends Bloc<DetailTaskEvent, DetailTaskState> {
  DetailTaskBloc() : super(const DetailTaskLoading([])) {
    on<DetailTaskEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<OnGetData>((event, emit) async {
      EasyLoading.show();
      switch (event.status ?? "all") {
        case "all":
          final listData = await TaskController.getListData(TaskParam());
          emit(DetailTaskHasData(listData));
          break;
        default:
          final listData = await TaskController.getListData(TaskParam(status: event.status));
          emit(DetailTaskHasData(listData));
          break;
      }
      EasyLoading.dismiss();
    });
  }
}
