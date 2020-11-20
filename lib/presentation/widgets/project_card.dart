import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectCard extends StatelessWidget {
  final String category;
  final String title;
  final DateTime day;
  final int completed;

  ProjectCard({this.category, this.title, this.day, this.completed});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(10),
        width: 150,
        color: Color(0xff222228),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AutoSizeText(
              category.toUpperCase(),
              maxLines: 2,
              style: TextStyle(color: Color(0xff57585c), fontSize: 10),
            ),
            AutoSizeText(
              title,
              maxLines: 2,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(DateFormat.EEEE().format(day)),
          ],
        ),
      ),
    );
  }
}
