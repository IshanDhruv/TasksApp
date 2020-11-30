import 'package:tasks_app/models/project.dart';

class Task {
  String id;
  String title;
  String description;
  Project project;
  DateTime time;
  bool isCompleted;

  Task(
      {this.id,
      this.title,
      this.description,
      this.isCompleted,
      this.time,
      this.project});
}
