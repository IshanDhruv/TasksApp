import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tasks_app/models/project.dart';
import 'package:tasks_app/models/task.dart';
import 'package:tasks_app/presentation/modify_task.dart';
import 'package:tasks_app/services/auth.dart';
import 'package:tasks_app/presentation/widgets/project_card.dart';
import 'package:tasks_app/presentation/widgets/task_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasks_app/services/project_service.dart';
import 'package:tasks_app/services/task_service.dart';

import 'modify_project.dart';

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
      time: DateTime.now(),
      completed: 75),
  Project(
    category: "trip",
    title: "Holidays in Norway",
    time: DateTime.now(),
    completed: 40,
  )
];

class _HomeScreenState extends State<HomeScreen> {
  User get user => widget.user;

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
        elevation: 0,
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
      floatingActionButton: buildSpeedDial(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Projects",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 10),
              _projectsRow(user),
              SizedBox(height: 20),
              Text(
                "Tasks",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 10),
              _tasksColumn(user)
            ],
          ),
        ),
      ),
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      child: Icon(
        Icons.add,
        color: Colors.pinkAccent,
      ),
//      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.edit, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ModifyTaskScreen(user: user, isModify: false),
            ),
          ),
          label: 'New task',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.blue,
        ),
        SpeedDialChild(
          child: Icon(Icons.assignment_rounded, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModifyProjectScreen(
                user: user,
                isModify: false,
              ),
            ),
          ),
          label: 'New project',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
      ],
    );
  }
}

Widget _projectsRow(User user) {
  List projects = [];
  ProjectService projectDB = ProjectService();
  return StreamBuilder(
      stream: projectDB.getProjects(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            projects = snapshot.data.documents
                .map<Project>(projectDB.projectFromSnapshot)
                .toList();
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
                      project: _project,
                      user: user,
                    ),
                  );
                },
                itemCount: projects.length,
              ),
            );
          } else
            return Text(
              "No projects yet.",
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

Widget _tasksColumn(User user) {
  List<Task> tasks = [];
  TaskService taskDB = TaskService();
  return StreamBuilder(
      stream: taskDB.getTasks(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            tasks = snapshot.data.documents
                .map<Task>(taskDB.taskFromSnapshot)
                .toList();
            tasks.sort((a, b) => a.time.compareTo(b.time));
            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: TaskCard(
                    task: tasks[index],
                    user: user,
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
