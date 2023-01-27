import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/utility.dart';

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
  TextEditingController? startDate;
  TextEditingController? endDate;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var startDate;
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
                height: height(context) * 0.9,
                child: SingleChildScrollView(
                    child: Column(children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 130.0),
                        child: Text(
                          "Add Experience",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                      ),
                      Icon(Icons.close),
                    ],
                  ),
                  Padding(
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
                            CustomTextField(
                                controller: titleController,
                                hintText: 'Ex. Ui Designer'),
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
                            CustomTextField(
                                controller: titleController,
                                hintText: 'Ex: Google, Microsoft'),
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
                            InkWell(
                              onTap: () {
                                try {
                                  selectDate(context, startDate!);
                                } catch (e) {
                                  startDate = TextEditingController();
                                  selectDate(context, startDate!);
                                }
                              },
                              child: Container(
                                width: width(context),
                                height: height(context) * 0.07,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xffE5E5E5)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        startDate != null
                                            ? startDate!.value.text
                                            : "Select Date",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff929BA3)),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      // child: InkWell(
                                      //   onTap: (() async {
                                      //     DateTime? datePiked =
                                      //         await showDatePicker(
                                      //             context: context,
                                      //             initialDate: DateTime.now(),
                                      //             firstDate: (DateTime(2021)),
                                      //             lastDate: DateTime(2050));
                                      //     if (datePiked != null) {
                                      //       print(
                                      //           'Date Selected : ${datePiked.day}--${datePiked.month}--${datePiked.year}');
                                      //     }
                                      //   }),
                                      child: SvgPicture.asset(
                                          'assets/images/selected_calender.svg'),
                                      // ),
                                    ),
                                  ],
                                ),
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
                            InkWell(
                              onTap: () {
                                try {
                                  selectDate(context, endDate!,
                                      startDate: selectedDate);
                                } catch (e) {
                                  endDate = TextEditingController();
                                  selectDate(context, endDate!,
                                      startDate: selectedDate);
                                }
                              },
                              child: Container(
                                width: width(context),
                                height: height(context) * 0.07,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xffE5E5E5)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        endDate != null
                                            ? endDate!.value.text
                                            : "Select Date",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff929BA3)),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      // child: InkWell(
                                      // onTap: (() async {
                                      //   DateTime? datePiked =
                                      //       await showDatePicker(
                                      //           context: context,
                                      //           initialDate: DateTime.now(),
                                      //           firstDate: (DateTime(2021)),
                                      //           lastDate: DateTime(2050));
                                      //   if (datePiked != null) {
                                      //     print(
                                      //         'Date Selected : ${datePiked.day}--${datePiked.month}--${datePiked.year}');
                                      //   }
                                      // }),
                                      child: SvgPicture.asset(
                                          'assets/images/selected_calender.svg'),
                                      // ),
                                    ),
                                  ],
                                ),
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
                              controller: descController,
                              maxLine: 6,
                              hintText: 'Describe your work or achievement',
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            PortfolioCustomButton(
                              clickAction: () {},
                            )
                          ])))
                ])))));
  }

  selectDate(BuildContext context, TextEditingController controller,
      {DateTime? startDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: startDate ?? DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        controller.text = Utility.convertDateFormat(selectedDate);
      });
  }
}
