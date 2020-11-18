import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/models/project.dart';
import 'package:tasks_app/models/task.dart';
import 'package:tasks_app/services/auth.dart';
import 'package:tasks_app/presentation/widgets/project_card.dart';
import 'package:tasks_app/presentation/widgets/task_card.dart';
import 'package:tasks_app/services/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

List<Task> tasks = [
  Task(
    title: "Take the coat to dry cleaning",
    isCompleted: false,
  )
];

List<Project> projects = [
  Project(
      category: "Meetings",
      title: "Amanda at Ruth's",
      day: "Today",
      completed: 75),
  Project(
    category: "trip",
    title: "Holidays in Norway",
    day: "Sat",
    completed: 40,
  )
];

class _HomeScreenState extends State<HomeScreen> {
  DBService db = DBService();

  User get user => widget.user;

  getTasks() async {
    var a = await db.getTasks(user.uid);
    print(a);
  }

  @override
  void initState() {
//    getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                signOut();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Center(child: Text("Tasks")),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: Tooltip(
                  child: Icon(Icons.calendar_today_rounded),
                  message: "Calendar"),
              onTap: () {},
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Projects",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            _projectsRow(),
            SizedBox(height: 20),
            Text(
              "Tasks",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            _tasksColumn(user.uid)
          ],
        ),
      ),
    );
  }
}

Widget _projectsRow() {
  return Container(
    height: 200,
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        Project _project = projects[index];
        return Container(
          padding: EdgeInsets.only(right: 10),
          child: ProjectCard(
            category: _project.category,
            title: _project.title,
            day: _project.day,
            completed: _project.completed,
          ),
        );
      },
      itemCount: projects.length,
    ),
  );
}

Widget _tasksColumn(String uid) {
  DBService db = DBService();
  return StreamBuilder<List<Task>>(
      stream: db.getTasks(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            tasks = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TaskCard(
                    task: tasks[index],
                  ),
                );
              },
              itemCount: tasks.length,
            );
          } else
            return Text(
              "No tasks yet.",
              style: TextStyle(color: Colors.white),
            );
        } else {
          print(snapshot.connectionState);
          return Text(
            "Something went wrong",
            style: TextStyle(color: Colors.white),
          );
        }
      });
}
