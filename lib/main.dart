import 'package:flutter/material.dart';
import 'package:flutter_todo_list/index_screen.dart';

void main() => runApp(const MiApp());

class MiApp extends StatelessWidget {
  const MiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Flutter',
      home: IndexScreen(),
    );
  }
}
