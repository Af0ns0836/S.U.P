import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: const [
      Text('Courses', style: TextStyle(fontSize: 20)),
      Text('About Us', style: TextStyle(fontSize: 20)),
      Text('Contacts', style: TextStyle(fontSize: 20)),
      Text('Help', style: TextStyle(fontSize: 20)),
      Text('Main Features', style: TextStyle(fontSize: 20))
    ]));
  }
}
