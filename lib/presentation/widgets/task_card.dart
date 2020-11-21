import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/models/task.dart';
import 'package:tasks_app/presentation/modify_task.dart';
import 'package:tasks_app/services/task_service.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final User user;

  TaskCard({this.task, this.user});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  TaskService taskDB = TaskService();
  User get user => widget.user;
  Task get task => widget.task;

  @override
  Widget build(BuildContext context) {
    Color _color = Colors.blue;
    if (task.time.day == DateTime.now().day) _color = Colors.pinkAccent;
    if (task.time.day == DateTime.now().day + 1)
      _color = Colors.deepPurpleAccent;
    if (task.time.isBefore(DateTime.now())) _color = Colors.red;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModifyTaskScreen(
                isModify: true,
                user: user,
                task: task,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Container(
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
                      value: task.isCompleted ?? false,
                      onChanged: (value) async {
                        setState(() {
                          task.isCompleted = value;
                        });
                        await Future.delayed(Duration(seconds: 3));
                        if (task.isCompleted) taskDB.finishTask(user.uid, task);
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(color: _color, height: 4)
          ],
        ),
      ),
    );
  }
}
