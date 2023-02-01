import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:masterg/utils/constant.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "Resume",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
          actions: const [
            Icon(
              Icons.close,
              color: Colors.black,
            )
          ]),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Container(
            width: width(context),
            height: height(context) * 0.9,
            child: Column(
              children: [
                Image.network(
                  'https://static.thenounproject.com/png/3321498-200.png',
                  color: const Color(0xffE5E5E5),
                  scale: 2,
                ),
                const Text(
                  "You have not uploaded your resume yet!",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff929BA3)),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: width(context),
                    height: height(context) * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1.0, color: const Color(0xffE5E5E5)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 110.0),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.upload,
                            color: Colors.orange,
                          ),
                          Text(
                            "  Upload Resume",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Text("Supported Format: .pdf, .doc, .jpeg",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff929BA3))),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 250.0),
                    child: Container(
                      height: height(context) * 0.06,
                      width: width(context) * 0.8,
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.all(20.0),
                      decoration: const BoxDecoration(
                          color: Color(0xff0E1638),
                          borderRadius: BorderRadius.all(Radius.circular(21))),
                      child: const Center(
                        child: Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
