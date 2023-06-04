part of 'detail_task_bloc.dart';

@immutable
abstract class DetailTaskState {
  final List<TaskModel> listData;
  const DetailTaskState(this.listData);
}

class DetailTaskLoading extends DetailTaskState {
  const DetailTaskLoading(super.listData);
}

class DetailTaskHasData extends DetailTaskState {
  const DetailTaskHasData(super.listData);
}
