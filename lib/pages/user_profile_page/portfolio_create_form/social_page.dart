import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:masterg/utils/constant.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Contact and Social",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            actions: [
              Icon(
                Icons.menu,
                color: Colors.black,
              )
            ]),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffE5E5E5)),
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: SizedBox(
                      width: 30,
                      height: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(
                            Icons.phone,
                            color: Colors.orange,
                          ),
                          VerticalDivider(
                            thickness: 1,
                            color: Color(0xffE5E5E5),
                          ),
                        ],
                      ),
                    ),
                    hintText: 'Enter your mobile number',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffE5E5E5)),
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: SizedBox(
                      width: 30,
                      height: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(
                            Icons.mail,
                            color: Colors.orange,
                          ),
                          VerticalDivider(
                            thickness: 1,
                            color: Color(0xffE5E5E5),
                          ),
                        ],
                      ),
                    ),
                    hintText: 'Enter your email address',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.orange,
                      ),
                      VerticalDivider(),
                      Text(
                        "Hide contact details on portfolio",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff5A5F73)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Text(
                        "Social",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: width(context),
                  height: height(context) * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: Color(0xffE5E5E5)),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.mail,
                          color: Colors.orange,
                        ),
                        VerticalDivider(
                          thickness: 1,
                          color: Color(0xffE5E5E5),
                        ),
                        Text("linkedin/",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff929BA3))),
                        Spacer(),
                        Text(
                          "Connect Linkedin",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.orange),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: width(context),
                  height: height(context) * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: Color(0xffE5E5E5)),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.mail,
                          color: Colors.orange,
                        ),
                        VerticalDivider(
                          thickness: 1,
                          color: Color(0xffE5E5E5),
                        ),
                        Text("behance.net/",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff929BA3))),
                        Spacer(),
                        Text(
                          "Connect behance",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.orange),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: width(context),
                  height: height(context) * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: Color(0xffE5E5E5)),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.mail,
                          color: Colors.orange,
                        ),
                        VerticalDivider(
                          thickness: 1,
                          color: Color(0xffE5E5E5),
                        ),
                        Text("dribbble.net/",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff929BA3))),
                        Spacer(),
                        Text(
                          "Connect dribbble",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.orange),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: width(context),
                  height: height(context) * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: Color(0xffE5E5E5)),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.mail,
                          color: Colors.orange,
                        ),
                        VerticalDivider(
                          thickness: 1,
                          color: Color(0xffE5E5E5),
                        ),
                        Text("instagram.com/",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff929BA3))),
                        Spacer(),
                        Text(
                          "Connect instagram",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.orange),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: width(context),
                  height: height(context) * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: Color(0xffE5E5E5)),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.mail,
                          color: Colors.orange,
                        ),
                        VerticalDivider(
                          thickness: 1,
                          color: Color(0xffE5E5E5),
                        ),
                        Text("facebook.com/",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff929BA3))),
                        Spacer(),
                        Text(
                          "Connect facebook",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.orange),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: width(context),
                  height: height(context) * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: Color(0xffE5E5E5)),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.mail,
                          color: Colors.orange,
                        ),
                        VerticalDivider(
                          thickness: 1,
                          color: Color(0xffE5E5E5),
                        ),
                        Text("twitter.com/",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff929BA3))),
                        Spacer(),
                        Text(
                          "Connect twitter",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.orange),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: width(context),
                  height: height(context) * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: Color(0xffE5E5E5)),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.mail,
                          color: Colors.orange,
                        ),
                        VerticalDivider(
                          thickness: 1,
                          color: Color(0xffE5E5E5),
                        ),
                        Text("pinterest.com/",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff929BA3))),
                        Spacer(),
                        Text(
                          "Connect pinterest",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.orange),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
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
                )
              ],
            ),
          ),
        ));
  }
}
