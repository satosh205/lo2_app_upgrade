import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_portfolio.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/utility.dart';

class AddEducation extends StatefulWidget {
  const AddEducation({Key? key}) : super(key: key);

  @override
  State<AddEducation> createState() => _AddEducationState();
}

class _AddEducationState extends State<AddEducation> {
  TextEditingController? titleController;
  TextEditingController? descController;
  TextEditingController? startDate;
  TextEditingController? endDate;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //     elevation: 0.0,
        //     backgroundColor: Colors.white,
        //     title: const Center(
        //       child: Text(
        //         "Add Education",
        //         style: TextStyle(
        //             fontSize: 14,
        //             fontWeight: FontWeight.w600,
        //             color: Colors.black),
        //       ),
        //     ),
        //     actions: const [
        //       Icon(
        //         Icons.close,
        //         color: Colors.black,
        //       )
        //     ]),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(
                    children: [
                      Text('Add Education', style: Styles.bold(size: 14)),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  Text(
                    "School*",
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
                      hintText: 'Ex. Middle East College (MEC), Muscat, Oman'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Degree*",
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
                      hintText: 'Ex: Bachelor\'s of Instrumentation'),
                  SizedBox(
                    height: 10,
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
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SvgPicture.asset(
                                'assets/images/selected_calender.svg'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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

                    onTap: (){
                        try {
                        selectDate(context, endDate!, startDate: selectedDate);
                      } catch (e) {
                        endDate = TextEditingController();
                      selectDate(context, endDate!,  startDate: selectedDate);

                      }
                    },
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                          endDate != null
                                  ? endDate!.value.text
                                  :     "Select Date",
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
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Description",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5A5F73)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                    controller: descController,
                    maxLine: 6,
                    hintText:
                        'You can mention your Grades, Achievements, Activities or subjects you are studying ',
                  ),
                  PortfolioCustomButton(
                    clickAction: () {},
                  )
                ]))));
  }

  selectDate(BuildContext context, TextEditingController controller, {DateTime? startDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate:startDate ??  DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        controller.text = Utility.convertDateFormat(selectedDate);
      });
  }
}
