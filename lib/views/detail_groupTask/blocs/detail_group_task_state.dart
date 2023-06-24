part of 'detail_group_task_bloc.dart';

@immutable
abstract class DetailGroupTaskState {
  final List<TaskModel> listData;
  final String? groupID;
  final bool onlyMe;
  DetailGroupTaskState(this.listData, this.groupID, this.onlyMe);
}

class DetailGroupTaskLoading extends DetailGroupTaskState {
  DetailGroupTaskLoading(super.listData, super.groupID, super.onlyMe);
}

class DetailGroupTaskHasData extends DetailGroupTaskState {
  DetailGroupTaskHasData(super.listData, super.groupID, super.onlyMe);
}
