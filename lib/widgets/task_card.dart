import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/models/task.dart';

class TaskCard extends StatefulWidget {
  final Task task;

  TaskCard({this.task});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
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
                onChanged: (value) {
                  setState(() {
                    task.isCompleted = value;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
