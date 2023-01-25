
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
        margin: EdgeInsets.only(
            left: SizeConstants.JOB_LEFT_SCREEN_MGN,
            right: SizeConstants.JOB_RIGHT_SCREEN_MGN,
            bottom: SizeConstants.JOB_BOTTOM_SCREEN_MGN),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(height: height(context) * 0.03,),

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
                colors: <Color>[Color(0xfffc7804), ColorConstants.GRADIENT_RED])
                .createShader(bounds);
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
                colors: <Color>[Color(0xfffc7804), ColorConstants.GRADIENT_RED]),
          ),
        ),
      ],
    );
  }
}
