import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks_app/models/category.dart';

class CategoryService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final mainCollection = 'tasks';
  final tasksCollection = 'tasks';
  final projectsCollection = 'projects';
  final categoryCollection = 'categories';

  getCategories(String uid) {
    return firestore
        .collection('tasks')
        .doc(uid)
        .collection('categories')
        .snapshots();
  }

  Category categoryFromSnapshot(DocumentSnapshot snapshot) {
    try {
      print(snapshot.metadata.isFromCache ? "Cached" : "Not Cached");
      Category category = Category(
        id: snapshot.id,
        title: snapshot['title'],
      );
      return category;
    } catch (e) {
      print(e);
    }
  }

  createCategory(String uid, Category category) {
    var obj = {"title": category.title};
    return firestore
        .collection(mainCollection)
        .doc(uid)
        .collection(categoryCollection)
        .doc()
        .set(obj);
  }
}
