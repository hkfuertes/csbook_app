import 'package:csbook_app/pages/ListPage.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main_screen';

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return ListPage();
  }
}
