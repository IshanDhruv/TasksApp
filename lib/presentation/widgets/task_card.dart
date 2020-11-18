import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/models/task.dart';
import 'package:tasks_app/services/db_service.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final User user;
  TaskCard({this.task, this.user});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  DBService db = DBService();
  User get user => widget.user;
  Task get task => widget.task;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(5),
        color: Color(0xff222228),
        child: Container(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            children: [
              AutoSizeText(
                task.title,
                maxLines: 2,
                minFontSize: 18,
                maxFontSize: 36,
              ),
              Spacer(),
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) async {
                  setState(() {
                    task.isCompleted = value;
                  });
                  await Future.delayed(Duration(seconds: 3));
                  if (task.isCompleted) db.finishTask(user.uid, task.title);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
