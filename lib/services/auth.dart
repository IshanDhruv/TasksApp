import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final mainCollection = 'tasks';
final tasksCollection = 'tasks';
final projectsCollection = 'projects';

Future<String> signInWithGoogle() async {
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
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = auth.currentUser;
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: ${user.displayName}');
    firestore
        .collection(mainCollection)
        .doc(user.uid)
        .set({"Name": user.displayName});
    firestore
        .collection(mainCollection)
        .doc(user.uid)
        .collection(tasksCollection);
    firestore
        .collection(mainCollection)
        .doc(user.uid)
        .collection(projectsCollection);
    return '$user';
  }

  return null;
}

Future signOut() async {
  await googleSignIn.signOut();
  auth.signOut();
  print("User Signed Out");
}
