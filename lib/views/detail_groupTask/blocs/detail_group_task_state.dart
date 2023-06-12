part of 'detail_group_task_bloc.dart';

@immutable
abstract class DetailGroupTaskState {
  final List<TaskModel> listData;
  final String? groupID;
  DetailGroupTaskState(this.listData, this.groupID);
}

class DetailGroupTaskLoading extends DetailGroupTaskState {
  DetailGroupTaskLoading(super.listData, super.groupID);
}

class DetailGroupTaskHasData extends DetailGroupTaskState {
  DetailGroupTaskHasData(super.listData, super.groupID);
}
