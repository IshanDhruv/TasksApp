import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/presentation/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: 'Tasks App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xff1e1e23),
        scaffoldBackgroundColor: Color(0xff17171a),
        accentColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    ),
  );
}
