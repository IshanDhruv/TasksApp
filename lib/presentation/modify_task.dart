import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    if (isModify == true) {
      task = widget.task;
      _titleController.text = task.title;
      _descController.text = task.description;
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
                task.description = _descController.text;
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                        decoration: InputDecoration(
                          fillColor: Color(0xff212126),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white),
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
                    SizedBox(height: 40),
                    TextFormField(
                      minLines: 3,
                      maxLines: 10,
                      decoration: InputDecoration(
                        fillColor: Color(0xff212126),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintText: 'Optional description',
                      ),
                      controller: _descController,
                    ),
//                    SizedBox(height: 20),
//                    _dateRow(context),
                    SizedBox(height: 20),
                    _dateWidget(context)
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlatButton(
          height: 40,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7), side: BorderSide()),
          color: Colors.pinkAccent,
          child: Text("Today"),
          onPressed: () async {
            _date = DateTime.now();
            _time = await showTimePicker(
                context: context, initialTime: TimeOfDay.now());
            _date = DateTime(
                _date.year, _date.month, _date.day, _time.hour, _time.minute);
            print(_date);
          },
        ),
//        SizedBox(width: 30),
        FlatButton(
          height: 40,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7), side: BorderSide()),
          color: Colors.deepPurpleAccent,
          child: Text("Tomorrow"),
          onPressed: () async {
            _date = DateTime.now();
            _time = await showTimePicker(
                context: context, initialTime: TimeOfDay.now());
            _date = DateTime(_date.year, _date.month, _date.day + 1, _time.hour,
                _time.minute);
            print(_date);
          },
        ),
        FlatButton(
          height: 40,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7), side: BorderSide()),
          color: Colors.indigoAccent,
          child: Text("Pick time"),
          onPressed: () async {
            _date = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime.now(),
                lastDate: DateTime(2025));
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

Widget _dateWidget(context) {
  return Container(
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white),
    ),
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date",
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(height: 10),
        Text(
          DateFormat.jm().add_yMMMMEEEEd().format(_date),
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        _dateRow(context)
      ],
    ),
  );
}
