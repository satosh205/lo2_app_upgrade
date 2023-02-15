
import 'package:flutter/cupertino.dart';

class CoursesPage extends StatefulWidget {
  final int? coursesId;
  const CoursesPage({Key? key, this.coursesId}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Text('Courses Page Dynamic Link  ${widget.coursesId}'),
      ),
    );
  }
}
