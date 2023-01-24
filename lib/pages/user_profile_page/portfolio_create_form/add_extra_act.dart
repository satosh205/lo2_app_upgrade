import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class AddActivities extends StatefulWidget {
  const AddActivities({Key? key}) : super(key: key);

  @override
  State<AddActivities> createState() => _AddActivitiesState();
}

class _AddActivitiesState extends State<AddActivities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Add Extra Curricular Activities",
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
                    "Activity Title**",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5A5F73)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomTextField(hintText: 'Ex. Man of the match'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Associated Organisation Name*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5A5F73)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                      hintText: 'Ex. College, Company, NGO, Others'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Activity Type*",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5A5F73)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      hintText: 'Ex: Sports, Acting, Event Management'),
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
                        // Icon(Icons.edit_calendar_outlined)

                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SvgPicture.asset(
                              'assets/images/selected_calender.svg'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomDescription(
                    hintText: 'Describe your work or achievement',
                  ),
                  Text(
                    "Featured image",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5A5F73)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: <Color>[
                                    Color(0xfffc7804),
                                    ColorConstants.GRADIENT_RED
                                  ]).createShader(bounds);
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/images/upload_icon.svg'),
                                Text(
                                  "Upload Image",
                                  style: Styles.bold(size: 12),
                                ),
                              ],
                            )),
                        SizedBox(
                          width: 4,
                        ),
                        const Text("Supported Format: .pdf, .doc, .jpeg",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff929BA3))),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  PortfolioCustomButton(clickAction: (){},)
                ]))));
  }
}
