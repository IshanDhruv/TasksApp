import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasks_app/models/project.dart';
import 'package:tasks_app/services/project_service.dart';

class ModifyProjectScreen extends StatefulWidget {
  final bool isModify;
  final User user;
  final Project project;

  ModifyProjectScreen({this.user, this.project, @required this.isModify});

  @override
  _ModifyProjectScreenState createState() => _ModifyProjectScreenState();
}

class _ModifyProjectScreenState extends State<ModifyProjectScreen> {
  ProjectService projectDB = ProjectService();
  DateTime _date;
  TimeOfDay _time;

  bool get isModify => widget.isModify;
  Project project = Project();

  User get user => widget.user;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    if (isModify == true) {
      project = widget.project;
      _date = project.time;
      _time = TimeOfDay.fromDateTime(project.time);
      _titleController.text = project.title;
      _descController.text = project.description;
    } else {
      _date = DateTime.now();
      _time = TimeOfDay.now();
    }
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
                project.title = _titleController.text;
                project.description = _descController.text;
                project.time = _date;
                if (isModify == false)
                  projectDB.createProject(user.uid, project);
                else {
                  projectDB.modifyProject(user.uid, project);
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
                          hintText: 'Project title',
                        ),
                        controller: _titleController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'A project can\'t be empty!';
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
              var a =
                  await showTimePicker(context: context, initialTime: _time);
              setState(() {
                if (a != null) {
                  _date = DateTime.now();
                  _time = a;
                  _date = DateTime(_date.year, _date.month, _date.day,
                      _time.hour, _time.minute);
                }
              });
            },
          ),
          FlatButton(
            height: 40,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7), side: BorderSide()),
            color: Colors.deepPurpleAccent,
            child: Text("Tomorrow"),
            onPressed: () async {
              var a =
                  await showTimePicker(context: context, initialTime: _time);
              setState(() {
                if (a != null) {
                  _date = DateTime.now();
                  _time = a;
                  _date = DateTime(_date.year, _date.month, _date.day + 1,
                      _time.hour, _time.minute);
                }
              });
            },
          ),
          FlatButton(
            height: 40,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7), side: BorderSide()),
            color: Colors.indigoAccent,
            child: Text("Pick time"),
            onPressed: () async {
              var a = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2025));
              var b = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());
              setState(() {
                if (a != null && b != null) {
                  _date = a;
                  _time = b;
                  _date = DateTime(_date.year, _date.month, _date.day,
                      _time.hour, _time.minute);
                }
              });
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
            "Deadline",
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
}
