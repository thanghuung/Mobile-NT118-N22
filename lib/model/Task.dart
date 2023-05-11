import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task {
  String id;
  String content;
  String description;
  bool isCompleted;
  String category;
  Color backgroundColor;
  Color priority;
  Timestamp date;

  Task({
    required this.id,
    required this.content,
    required this.description,
    required this.isCompleted,
    required this.category,
    required this.backgroundColor,
    required this.priority,
    required this.date,
  });
}
