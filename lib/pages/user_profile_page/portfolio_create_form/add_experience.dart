import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/constant.dart';

class AddExperience extends StatefulWidget {
  const AddExperience({Key? key}) : super(key: key);

  @override
  State<AddExperience> createState() => _AddExperienceState();
}

class _AddExperienceState extends State<AddExperience> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  static String _value = "value";
  bool? isclicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Add Experience",
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
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text(
                    "Position Title*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5A5F73)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomTextField(hintText: 'Ex. Ui Designer'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Company Name*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5A5F73)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomTextField(hintText: 'Ex: Google, Microsoft'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Employment type*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5A5F73)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Radio(
                          value: "Full-Time",
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = value.toString();
                            });
                          }),
                      Text("Full-Time"),
                      Radio(
                          value: "Part-Time",
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = value.toString();
                            });
                          }),
                      Text("Part-Time"),
                      Radio(
                          value: "Internship",
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = value.toString();
                            });
                          }),
                      Text("Internship"),
                    ],
                  ),
                  Text(
                    "Start Date*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5A5F73)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: width(context),
                    height: height(context) * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1.0, color: const Color(0xffE5E5E5)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Select Date",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff929BA3)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SvgPicture.asset(
                              'assets/images/selected_calender.svg'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: isclicked,
                          onChanged: (bool) {
                            setState(() {
                              isclicked = bool;
                            });
                          }),
                      Text("I currently work here",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff929BA3)))
                    ],
                  ),
                  Text(
                    "End date (or expected)*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5A5F73)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: width(context),
                    height: height(context) * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1.0, color: const Color(0xffE5E5E5)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Select Date",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff929BA3)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SvgPicture.asset(
                              'assets/images/selected_calender.svg'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Description",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff5A5F73)),
                    ),
                  ),
                CustomTextField(
                    maxLine: 6,
                    hintText: 'Describe your work or achievement',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  PortfolioCustomButton(clickAction: (){},)
                ]))));
  }
}
