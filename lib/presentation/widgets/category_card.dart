import 'package:flutter/material.dart';
import 'package:tasks_app/models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard({this.category});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) => ModifyProjectScreen(
//                isModify: true,
//                user: user,
//                project: project,
//              ),
//            ),
//          );
        },
        child: Container(
          padding: EdgeInsets.all(10),
          width: 150,
          color: Color(0xff222228),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 70,
                  width: 8,
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 20),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      category.title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "5 tasks",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
