import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ModifyProjectScreen extends StatefulWidget {
  final bool isModify;
  final User user;

  ModifyProjectScreen({this.user, @required this.isModify});

  @override
  _ModifyProjectScreenState createState() => _ModifyProjectScreenState();
}

class _ModifyProjectScreenState extends State<ModifyProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
