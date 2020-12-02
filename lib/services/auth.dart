import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasks_app/models/project.dart';
import 'package:tasks_app/models/task.dart';
import 'package:tasks_app/services/project_service.dart';
import 'package:tasks_app/services/task_service.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final mainCollection = 'tasks';
final tasksCollection = 'tasks';
final projectsCollection = 'projects';

signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult = await auth.signInWithCredential(credential);
  final User user = authResult.user;

  if (user != null) {
    TaskService taskDB = TaskService();
    ProjectService projectDB = ProjectService();
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = auth.currentUser;
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: ${user.displayName}');
    final snapshot =
        await firestore.collection(mainCollection).doc(user.uid).get();

    if (snapshot == null || !snapshot.exists) {
      firestore
          .collection(mainCollection)
          .doc(user.uid)
          .set({"Name": user.displayName});
      projectDB.createProject(
          user.uid,
          Project(
              title: "Welcome",
              time: DateTime.now(),
              description: "Complete this project"));
      taskDB.createTask(
          user.uid,
          Task(
              title: "Check this off!",
              time: DateTime.now(),
              isCompleted: false,
              description: "This is your first task. Mark it done!"));
    }
    return user;
  }

  return null;
}

Future signOut() async {
  await googleSignIn.signOut();
  auth.signOut();
  print("User Signed Out");
}
