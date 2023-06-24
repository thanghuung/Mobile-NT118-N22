import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meta/meta.dart';

import '../../../fire_base/task_controller.dart';
import '../../../model/task_model.dart';

part 'detail_group_task_event.dart';
part 'detail_group_task_state.dart';

class DetailGroupTaskBloc extends Bloc<DetailGroupTaskEvent, DetailGroupTaskState> {
  final String? groupID;
  DetailGroupTaskBloc(this.groupID) : super(DetailGroupTaskLoading([], groupID, false)) {

    on<DetailGroupTaskEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<OnClickOnlyMe>((event, emit) {
      emit(DetailGroupTaskHasData(state.listData, state.groupID, !state.onlyMe));
    });

    on<OnGetDataGroup>((event, emit) async {
      EasyLoading.show();
      switch (event.status ?? "all") {
        case "all":
          final listData = await TaskController.getListData(TaskParam(),
              groupId: state.groupID, onlyMe: state.onlyMe);
          emit(DetailGroupTaskHasData(listData, state.groupID, state.onlyMe));
          break;
        default:
          final listData = await TaskController.getListData(TaskParam(status: event.status),
              groupId: state.groupID, onlyMe: state.onlyMe);
          emit(DetailGroupTaskHasData(listData, state.groupID, state.onlyMe));
          break;
      }
      EasyLoading.dismiss();
    });
  }
}
