import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks_app/models/task.dart';

class DBService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final mainCollection = 'tasks';
  final tasksCollection = 'tasks';
  final projectsCollection = 'projects';

  createTask(String uid, String title) {}

  getTasks(String uid) {
    firestore.settings = Settings(persistenceEnabled: false);
    return firestore
        .collection(mainCollection)
        .doc(uid)
        .snapshots(includeMetadataChanges: true)
        .map(_tasksFromSnapshot);
  }

  List<Task> _tasksFromSnapshot(DocumentSnapshot snapshot) {
    List<Task> tasks = [
      Task(
        title: "Take the coat to dry cleaning",
        isCompleted: false,
      )
    ];
    try {
      print(snapshot.metadata.isFromCache ? "Cached" : "Not Cached");
      snapshot.data()['tasks'].forEach((task) {
        tasks.add(Task(title: task['title'], isCompleted: task['isCompleted']));
      });
    } catch (e) {
      print(e);
    }
    var b = snapshot.data();
    print(b);
//    print(tasks.first.title);
    return tasks;
  }
}
