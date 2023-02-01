import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});



// 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

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black,
          title: const Padding(
            padding: EdgeInsets.only(left: 120.0),
            child: Text(
              "Profile Picture",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          actions: [
            Row(
              children: const [
                Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0, right: 8),
              child: Text(
                "  Save",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            )
          ]),
    );
  }
}
