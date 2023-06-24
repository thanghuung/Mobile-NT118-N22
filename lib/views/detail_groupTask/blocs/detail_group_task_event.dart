part of 'detail_group_task_bloc.dart';

@immutable
abstract class DetailGroupTaskEvent {}

class OnGetDataGroup extends DetailGroupTaskEvent {
  final String? status;
  final String? categoryId;
  final String? spaceId;

  OnGetDataGroup({
    this.status,
    this.categoryId,
    this.spaceId,
  });
}

class OnClickOnlyMe extends DetailGroupTaskEvent {
}

