import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/models/category.dart';
import 'package:tasks_app/presentation/widgets/category_card.dart';
import 'package:tasks_app/presentation/widgets/drawer.dart';
import 'package:tasks_app/services/category_service.dart';

class CategoryScreen extends StatefulWidget {
  final User user;

  CategoryScreen({this.user});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryService categoryDB = CategoryService();
  User get user => widget.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(
        user: user,
      ),
      appBar: AppBar(
        title: Text("Your Categories"),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _categoriesColumn(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoriesColumn() {
    List<Category> _categories = [];
    return StreamBuilder(
        stream: categoryDB.getCategories(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              _categories = snapshot.data.documents
                  .map<Category>(categoryDB.categoryFromSnapshot)
                  .toList();
//              _categories.sort((a, b) => a.time.compareTo(b.time));
              return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: CategoryCard(
                      category: _categories[index],
                    ),
                  );
                },
                itemCount: _categories.length,
              );
            } else
              return Text(
                "No tasks yet.",
                style: TextStyle(color: Colors.white),
              );
          } else {
            print(snapshot.connectionState);
            return Text(
              "Something went wrong",
              style: TextStyle(color: Colors.white),
            );
          }
        });
  }
}
