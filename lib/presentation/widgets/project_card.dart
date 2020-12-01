import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasks_app/models/project.dart';
import 'package:tasks_app/presentation/projects/modify_project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final User user;

  ProjectCard({this.project, this.user});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModifyProjectScreen(
                isModify: true,
                user: user,
                project: project,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(10),
          width: 150,
          color: Color(0xff222228),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AutoSizeText(
                project.category != null ? project.category.toUpperCase() : "",
                maxLines: 2,
                style: TextStyle(color: Color(0xff57585c), fontSize: 10),
              ),
              AutoSizeText(
                project.title,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(DateFormat.EEEE().format(project.time)),
            ],
          ),
        ),
      ),
    );
  }
}
