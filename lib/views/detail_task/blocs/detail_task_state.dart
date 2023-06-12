part of 'detail_task_bloc.dart';

@immutable
abstract class DetailTaskState {
  final List<TaskModel> listData;
  final String? categoriesID;
  DetailTaskState(this.listData, this.categoriesID);
}

class DetailTaskLoading extends DetailTaskState {
  DetailTaskLoading(super.listData, super.categoriesID);
}

class DetailTaskHasData extends DetailTaskState {
  DetailTaskHasData(super.listData, super.categoriesID);
}
