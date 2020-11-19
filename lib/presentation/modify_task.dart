import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/models/task.dart';
import 'package:tasks_app/services/db_service.dart';

class ModifyTaskScreen extends StatefulWidget {
  final bool isModify;
  final User user;
  final Task task;

  ModifyTaskScreen({@required this.isModify, @required this.user, this.task});

  @override
  _ModifyTaskScreenState createState() => _ModifyTaskScreenState();
}

DateTime _date = DateTime.now();
TimeOfDay _time = TimeOfDay.now();

class _ModifyTaskScreenState extends State<ModifyTaskScreen> {
  DBService db = DBService();

  bool get isModify => widget.isModify;
  Task task = Task();

  User get user => widget.user;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    if (isModify == true) {
      task = widget.task;
      _titleController.text = task.title;
    }
    ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(child: Text("Create a New Task")),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: Tooltip(child: Icon(Icons.done), message: "Create"),
              onTap: () {
                task.title = _titleController.text;
                task.time = _date;
                if (isModify == false)
                  db.createTask(user.uid, task);
                else {
                  db.modifyTask(user.uid, task);
                }
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        decoration: InputDecoration(
                          fillColor: Color(0xff212126),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.pinkAccent),
                          ),
                          hintText: 'Task title',
                        ),
                        controller: _titleController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'A task can\'t be empty!';
                          }
                          return null;
                        }),
                    _dateRow(context)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _dateRow(context) {
  return Container(
    child: Row(
      children: [
        FlatButton(
          child: Text("TODAY"),
          onPressed: () async {
            _time = await showTimePicker(
                context: context, initialTime: TimeOfDay.now());
            _date = DateTime(
                _date.year, _date.month, _date.day, _time.hour, _time.minute);
            print(_date);
          },
        )
      ],
    ),
  );
}
