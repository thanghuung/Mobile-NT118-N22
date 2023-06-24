import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? id;
  String? categoryID;
  String? groupID;
  String? color;
  String? content;
  DateTime? dateCreated;
  DateTime? dateStart;
  DateTime? dateDone;
  String? description;
  bool? isCompleted;
  bool? isFavorite;
  String? priority;
  String? userID;
  String? email;

  TaskModel(
      {this.id,
      this.categoryID,
      this.color,
      this.content,
      this.groupID,
      this.dateCreated,
      this.dateStart,
      this.dateDone,
      this.description,
      required this.isCompleted,
      this.isFavorite,
      this.priority,
      this.email,
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
    isCompleted = json['isCompleted'];
    isFavorite = json['isFavorite'];
    priority = json['priority'];
    userID = json['userID'];
    groupID = json['groupID'];
    email = json['email'];
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
    data['isCompleted'] = this.isCompleted;
    data['isFavorite'] = this.isFavorite;
    data['priority'] = this.priority;
    data['userID'] = this.userID;
    data['groupID'] = this.groupID;
    data['email'] = this.email;
    return data;
  }
}
