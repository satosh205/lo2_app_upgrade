
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  final int? coursesId;
  const CoursesPage({super.key, this.coursesId});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Links'),
      ),
      body: Center(
        child: Text('Courses Page Dynamic Link  ${widget.coursesId}'),
      ),
    );
  }
}
