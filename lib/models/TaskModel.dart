import 'package:flutter/cupertino.dart';

class TaskModel {
  final String title;
  final String desc;
  final String date;
  final String pirority;
  int status;
  final int id;

  TaskModel(
      {@required this.title,
      @required this.desc,
      @required this.date,
      @required this.pirority,
      @required this.status,
      this.id});
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'desc': desc,
      'date': date,
      'pirority': pirority,
      'status': status
    };
  }
}
