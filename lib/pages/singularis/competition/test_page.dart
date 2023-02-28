import 'package:flutter/material.dart';

class Node {
  String text;
  List<Node> children;
  Node({required this.text, required this.children});
}

class TestWidgeTree extends StatefulWidget {
  const TestWidgeTree({Key? key}) : super(key: key);

  @override
  State<TestWidgeTree> createState() => _TestWidgeTreeState();
}

class _TestWidgeTreeState extends State<TestWidgeTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
      Text('hello'),
      HierarchyTree()
    ],),);
  }
}

class HierarchyTree extends StatefulWidget {
  @override
  _HierarchyTreeState createState() => _HierarchyTreeState();
}

class _HierarchyTreeState extends State<HierarchyTree> {
  final Node rootNode = Node(
    text: 'Root',
    children: [
      Node(
        text: 'Child 1',
        children: [
          Node(text: 'Grandchild 1', children: []),
          Node(text: 'Grandchild 2', children: []),
        ],
      ),
      Node(text: 'Child 2', children: []),
      Node(text: 'Child 3', children: []),
      // Node(text: 'Child 3', children: []),
      // Node(text: 'Child 3', children: [])


    ],
  );
   double _dx = 0;
  double _dy = 0;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _dx += details.delta.dx;
          _dy += details.delta.dy;
        });
      },
      child: Container(
        child: CustomPaint(
          painter: TreePainter(rootNode),
          
        ),
      ),
    );
  }
}

class TreePainter extends CustomPainter {
  final Node rootNode;

  TreePainter(this.rootNode);

  @override
  void paint(Canvas canvas, Size size) {
    // Define the style for the text and lines
    final textStyle = TextStyle(fontSize: 16, color: Colors.black);
    final linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    // Draw the root node
    _drawNode(canvas, rootNode, Offset(size.width / 2, 50), textStyle);

    // Draw the children of the root node
    final childY = 150.0;
    final childXSpacing = 100.0;
    for (var i = 0; i < rootNode.children.length; i++) {
      final child = rootNode.children[i];
      final childX = (i - rootNode.children.length / 2) * childXSpacing + size.width / 2;
      _drawNode(canvas, child, Offset(childX, childY), textStyle);
      canvas.drawLine(Offset(size.width / 2, 75), Offset(childX, childY - 25), linePaint);

      // Draw the grandchildren of the child node
      final grandchildY = 250.0;
      final grandchildXSpacing = 80.0;
      for (var j = 0; j < child.children.length; j++) {
        final grandchild = child.children[j];
        final grandchildX =
            (j - child.children.length / 2) * grandchildXSpacing + childX;
        _drawNode(canvas, grandchild, Offset(grandchildX, grandchildY), textStyle);
        canvas.drawLine(Offset(childX, childY + 25), Offset(grandchildX, grandchildY - 25), linePaint);
      }
    }
  }
  
  
  void _drawNode(Canvas canvas, Node node, Offset position, TextStyle textStyle) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: node.text,
      style: textStyle,
    ),
    textDirection: TextDirection.ltr,
  )..layout();

  // Draw a circle for the node
  final nodeRadius = 20.0;
  final nodePaint = Paint()..color = Colors.blue;
  canvas.drawCircle(position, nodeRadius, nodePaint);

  // Draw the node text
  final textOffset = Offset(position.dx - textPainter.width / 2, position.dy - textPainter.height / 2);
  textPainter.paint(canvas, textOffset);
}

  // @override
  // bool shouldRepaint(TreePainter oldDelegate) => oldDelegate.rootNode !=this.rootNode;
@override
  bool shouldRepaint(TreePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TreePainter oldDelegate) => false;
 
}
