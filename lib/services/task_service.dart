import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks_app/models/project.dart';
import 'package:tasks_app/models/task.dart';

class TaskService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final mainCollection = 'tasks';
  final tasksCollection = 'tasks';
  final projectsCollection = 'projects';
  final categoryCollection = 'categories';

  getTasks(String uid) {
    firestore.settings = Settings(persistenceEnabled: false);
    return firestore
        .collection(mainCollection)
        .doc(uid)
        .collection(tasksCollection)
        .snapshots();
  }

  Task taskFromSnapshot(DocumentSnapshot snapshot) {
    try {
//      print(snapshot.metadata.isFromCache ? "Cached" : "Not Cached");
      Task task = Task(
        id: snapshot.id,
        title: snapshot['title'],
        description: snapshot['description'],
        isCompleted: snapshot['isCompleted'],
        time: snapshot['time'].toDate(),
        project: Project.fromJson(snapshot['project']),
      );
      return task;
    } catch (e) {
      print(e);
    }
  }

  createTask(String uid, Task task) {
    var obj = {
      "title": task.title,
      "description": task.description,
      "isCompleted": false,
      "project": {"title": task.project.title, "id": task.project.id},
      "time": Timestamp.fromDate(task.time)
    };
    firestore
        .collection(mainCollection)
        .doc(uid)
        .collection(tasksCollection)
        .doc()
        .set(obj);
  }

  modifyTask(String uid, Task task) {
    var obj = {
      "title": task.title,
      "description": task.description,
      "isCompleted": false,
      "project": {"title": task.project.title, "id": task.project.id},
      "time": Timestamp.fromDate(task.time)
    };
    firestore
        .collection(mainCollection)
        .doc(uid)
        .collection(tasksCollection)
        .doc(task.id)
        .update(obj);
  }

  finishTask(String uid, Task task) {
    firestore
        .collection(mainCollection)
        .doc(uid)
        .collection(tasksCollection)
        .doc(task.id)
        .delete();
  }
}
