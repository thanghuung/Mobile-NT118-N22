import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? id;
  String? categoryID;
  String? color;
  String? content;
  DateTime? dateCreated;
  DateTime? dateStart;
  DateTime? dateDone;
  String? description;
  String? status;
  bool? isFavorite;
  String? priority;
  String? userID;

  TaskModel(
      {this.id,
      this.categoryID,
      this.color,
      this.content,
      this.dateCreated,
      this.dateStart,
      this.dateDone,
      this.description,
      this.status,
      this.isFavorite,
      this.priority,
      this.userID});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    categoryID = json['categoryID'];
    color = json['color'];
    content = json['content'];
    dateCreated = DateTime.fromMicrosecondsSinceEpoch(
        (json['dateCreated'] as Timestamp).microsecondsSinceEpoch);
    dateStart = DateTime.fromMicrosecondsSinceEpoch(
        (json['dateStart'] as Timestamp).microsecondsSinceEpoch);
    dateDone =
        DateTime.fromMicrosecondsSinceEpoch((json['dateDone'] as Timestamp).microsecondsSinceEpoch);
    description = json['description'];
    status = json['status'];
    isFavorite = json['isFavorite'];
    priority = json['priority'];
    userID = json['userID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryID'] = this.categoryID;
    data['id'] = id;
    data['color'] = this.color;
    data['content'] = this.content;
    data['dateCreated'] = this.dateCreated;
    data['dateStart'] = this.dateStart;
    data['dateDone'] = this.dateDone;
    data['description'] = this.description;
    data['status'] = this.status;
    data['isFavorite'] = this.isFavorite;
    data['priority'] = this.priority;
    data['userID'] = this.userID;
    return data;
  }
}
