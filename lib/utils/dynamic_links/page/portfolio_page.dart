

import 'package:flutter/material.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Links'),
      ),
      body: Center(
        child: Text('Portfolio Page Dynamic Link'),
      ),
    );
  }
}
