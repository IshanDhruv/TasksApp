import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/services/db_service.dart';

class ModifyTaskScreen extends StatefulWidget {
  final bool isModify;
  final User user;

  ModifyTaskScreen({@required this.isModify, @required this.user});

  @override
  _ModifyTaskScreenState createState() => _ModifyTaskScreenState();
}

class _ModifyTaskScreenState extends State<ModifyTaskScreen> {
  DBService db = DBService();

  bool get isModify => widget.isModify;

  User get user => widget.user;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();

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
                db.createTask(user.uid, _titleController.text);
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
                child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: Color(0xff212126),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.pinkAccent),
                      ),
                      hintText: 'Task title...',
                    ),
                    controller: _titleController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'A task can\'t be empty!';
                      }
                      return null;
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
