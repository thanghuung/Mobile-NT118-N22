part of 'detail_task_bloc.dart';

@immutable
abstract class DetailTaskEvent {}

class OnGetData extends DetailTaskEvent {
  final String? status;
  final String? categoryId;
  final String? spaceId;

  OnGetData({
    this.status,
    this.categoryId,
    this.spaceId,
  });
}
