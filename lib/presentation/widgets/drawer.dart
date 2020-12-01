import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/presentation/categories/category_screen.dart';
import 'package:tasks_app/presentation/home_screen.dart';
import 'package:tasks_app/services/auth.dart';

class DrawerWidget extends StatelessWidget {
  final User user;

  DrawerWidget({this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user.displayName),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.photoURL),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text(
              'Home',
            ),
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(
                    user: user,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Categories',
            ),
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => CategoryScreen(
                    user: user,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              signOut();
            },
          ),
        ],
      ),
    );
  }
}
