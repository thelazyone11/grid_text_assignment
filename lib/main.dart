import 'package:flutter/material.dart';
import 'package:grid_text_assignment/GridInputScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Grid Search App'),
        ),
        // body: GridSearchScreen(),
        // body: HomePage(),
        body: GridInputScreen(),
      ),
    );
  }
}
