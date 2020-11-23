import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks_app/models/project.dart';

class ProjectService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final mainCollection = 'tasks';
  final tasksCollection = 'tasks';
  final projectsCollection = 'projects';

  getProjects(String uid) {
    firestore.settings = Settings(persistenceEnabled: false);
    return firestore
        .collection(mainCollection)
        .doc(uid)
        .collection(projectsCollection)
        .snapshots();
  }

  Project projectFromSnapshot(DocumentSnapshot snapshot) {
    try {
      print(snapshot.metadata.isFromCache ? "Cached" : "Not Cached");
      Project project = Project(
          id: snapshot.id,
          category: snapshot['category'],
          title: snapshot['title'],
          description: snapshot['description'],
          time: snapshot['time'].toDate());
      return project;
    } catch (e) {
      print(e);
    }
  }

  createProject(String uid, Project project) {
    var obj = {
      "title": project.title,
      "description": project.description,
      "completed": project.completed,
      "category": project.category,
      "time": Timestamp.fromDate(project.time)
    };
    firestore
        .collection(mainCollection)
        .doc(uid)
        .collection(projectsCollection)
        .doc()
        .set(obj);
  }

  modifyProject(String uid, Project project) {
    var obj = {
      "title": project.title,
      "description": project.description,
      "completed": project.completed,
      "category": project.category,
      "time": Timestamp.fromDate(project.time)
    };
    firestore
        .collection(mainCollection)
        .doc(uid)
        .collection(projectsCollection)
        .doc(project.id)
        .update(obj);
  }
}
