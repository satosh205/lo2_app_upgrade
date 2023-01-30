import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../blocs/bloc_manager.dart';
import '../../../../blocs/home_bloc.dart';
import '../../../../utils/Styles.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/resource/colors.dart';
import '../../../../utils/resource/size_constants.dart';

class SkillAssessment extends StatefulWidget {
  const SkillAssessment({Key? key}) : super(key: key);

  @override
  State<SkillAssessment> createState() => _SkillAssessmentState();
}

class _SkillAssessmentState extends State<SkillAssessment> {
  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          /*if (state is UserJobListState) {
            _handleJobResponse(state);
          }*/
        },
        child: Scaffold(
          backgroundColor: ColorConstants.JOB_BG_COLOR,
          body: _makeBody(),
        ),
      ),
    );
  }

  Widget _makeBody() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        // margin: EdgeInsets.only(
        // left: SizeConstants.JOB_LEFT_SCREEN_MGN,
        // right: SizeConstants.JOB_RIGHT_SCREEN_MGN,
        // bottom: SizeConstants.JOB_BOTTOM_SCREEN_MGN),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: height(context) * 0.03,
            ),

            ///TODO: Skill
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  skillProgressBar("3D Animation", 1, 20),
                  skillProgressBar("HTML", 2, 30),
                  skillProgressBar("Motion Design", 3, 80),
                  skillProgressBar("Animation", 4, 90),
                ],
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  height: height(context) * 0.15,
                  width: width(context) * 6,
                  child: Column(
                    children: [
                      // Image.asset('assets/images/temp/UX_SKILL.png',
                      //     height: 20, width: 20),
                      Row(
                        children: [
                          SvgPicture.asset('assets/images/temp/ux_skill.svg'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, bottom: 8),
                                child: Text(
                                  "UX Research",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("10/200 Assessments Completed"),
                                    Icon(Icons.arrow_forward_ios_outlined)
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 60.0),
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
                              child: Text(
                                "Learner",
                                style: Styles.bold(size: 12),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 10,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  color: ColorConstants.GREY,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 10,
                                    width: width(context) * 0.3,
                                    // width: MediaQuery.of(context).size.width *
                                    //     0.9 *
                                    //     (
                                    //         //.completion! /
                                    //         100),
                                    decoration: BoxDecoration(
                                        color: Color(
                                          0xfffc7804,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
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
                              child: Text(
                                "Master",
                                style: Styles.bold(size: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  height: height(context) * 0.15,
                  // width: width(context) * 2,
                  child: Column(
                    children: [
                      // Image.asset('assets/images/temp/UX_SKILL.png',
                      //     height: 20, width: 20),
                      Row(
                        children: [
                          SvgPicture.asset(
                              'assets/images/temp/graphic_skill.svg'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, bottom: 8),
                                child: Text(
                                  "Graphic Design",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("0/100 Assessments Completed"),
                                    Icon(Icons.arrow_forward_ios_outlined)
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 60.0),
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
                              child: Text(
                                "Learner",
                                style: Styles.bold(size: 12),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 10,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  color: ColorConstants.GREY,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 10,
                                    width: width(context) * 0.3,
                                    // width: MediaQuery.of(context).size.width *
                                    //     0.9 *
                                    //     (
                                    //         //.completion! /
                                    //         100),
                                    decoration: BoxDecoration(
                                        color: Color(
                                          0xfffc7804,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
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
                              child: Text(
                                "Master",
                                style: Styles.bold(size: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  height: height(context) * 0.15,
                  // width: width(context) * 2,
                  child: Column(
                    children: [
                      // Image.asset('assets/images/temp/UX_SKILL.png',
                      //     height: 20, width: 20),
                      Row(
                        children: [
                          SvgPicture.asset(
                              'assets/images/temp/motion_skill.svg'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, bottom: 8),
                                child: Text(
                                  "Motion Design",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("2/100 Assessments Completed"),
                                    Icon(Icons.arrow_forward_ios_outlined)
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 60.0),
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
                              child: Text(
                                "Learner",
                                style: Styles.bold(size: 12),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 10,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  color: ColorConstants.GREY,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 10,
                                    width: width(context) * 0.3,
                                    // width: MediaQuery.of(context).size.width *
                                    //     0.9 *
                                    //     (
                                    //         //.completion! /
                                    //         100),
                                    decoration: BoxDecoration(
                                        color: Color(
                                          0xfffc7804,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
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
                              child: Text(
                                "Master",
                                style: Styles.bold(size: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  height: height(context) * 0.15,
                  // width: width(context) * 2,
                  child: Column(
                    children: [
                      // Image.asset('assets/images/temp/UX_SKILL.png',
                      //     height: 20, width: 20),
                      Row(
                        children: [
                          SvgPicture.asset(
                              'assets/images/temp/animation_skill.svg'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, bottom: 8),
                                child: Text(
                                  "Animation",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("4/100 Assessments Completed"),
                                    Icon(Icons.arrow_forward_ios_outlined)
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 60.0),
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
                              child: Text(
                                "Learner",
                                style: Styles.bold(size: 12),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 10,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  color: ColorConstants.GREY,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 10,
                                    width: width(context) * 0.3,
                                    // width: MediaQuery.of(context).size.width *
                                    //     0.9 *
                                    //     (
                                    //         //.completion! /
                                    //         100),
                                    decoration: BoxDecoration(
                                        color: Color(
                                          0xfffc7804,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
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
                              child: Text(
                                "Master",
                                style: Styles.bold(size: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget skillProgressBar(String title, int rating, double percent) {
    String? position;
    String? image = 'assets/images/';
    switch (rating) {
      case 5:
        position = 'LEADER';
        image += 'pro_in_bg.svg';
        break;
      case 4:
        position = 'EXPERT';
        image += 'pro_in_bg.svg';
        break;
      case 3:
        position = 'MASTER';
        image += 'pro_in_bg.svg';
        break;
      case 2:
        position = 'Learner';
        image += 'pro_in_bg.svg';
        break;
      case 1:
        position = 'NOVICE';
        image += 'pro_in_bg.svg';
        break;
    }
    return Column(
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
          child: Text(
            title,
            style: Styles.bold(size: 12),
          ),
        ),
        Transform.scale(
          scale: 0.75,
          child: CircularPercentIndicator(
            radius: 50.0,
            circularStrokeCap: CircularStrokeCap.round,
            lineWidth: 5.0,
            percent: percent / 100,
            center: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Color(0xff000000).withOpacity(0.25),
                      blurRadius: 4.36274)
                ],
                color: ColorConstants.WHITE,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 2),
                  SvgPicture.asset(
                    image,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
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
                    child: Text(
                      '$position',
                      style: Styles.bold(size: 9.19),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Color(0xffEFEFEF),
            linearGradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: <Color>[
                  Color(0xfffc7804),
                  ColorConstants.GRADIENT_RED
                ]),
          ),
        ),
      ],
    );
  }
}
