import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/pages/singularis/careers/skill/skill_assessment.dart';
import 'package:masterg/pages/singularis/job/job_dashboard_page.dart';

import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../local/pref/Preference.dart';
import '../../../utils/Styles.dart';
import '../../../utils/constant.dart';
import '../../../utils/resource/colors.dart';
import '../../../utils/resource/size_constants.dart';
import '../../custom_pages/custom_widgets/rounded_appbar.dart';

class CareersDashboard extends StatefulWidget {
  const CareersDashboard({Key? key}) : super(key: key);

  @override
  State<CareersDashboard> createState() => _CareersDashboardState();
}

class _CareersDashboardState extends State<CareersDashboard> {
  @override
  Widget build(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[ColorConstants.GRADIENT_ORANGE, ColorConstants.GRADIENT_RED],
    ).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    final Shader linearGradientUn = LinearGradient(
      colors: <Color>[ColorConstants.GREY_3, ColorConstants.GREY_3],
    ).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));


    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {},
        child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  _customAppBar(),
                  SizedBox(height: 12,),
                  TabBar(
                    labelColor: ColorConstants.selected,
                    unselectedLabelColor: ColorConstants.GREY_3,
                    indicatorColor: ColorConstants.selected,
                    labelPadding: EdgeInsets.all(0),
                    unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,
                    ),
                    //labelStyle: TextStyle(foreground: new Paint()..shader = linearGradient,fontSize: 14, fontWeight: FontWeight.w700),
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    tabs: [
                      Tab(text: "Skill Assessment",),
                      Tab(text: "Career Opportunities"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SkillAssessment(),
                        JobDashboardPage(),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _customAppBar() {
    return RoundedAppBar(
        appBarHeight: height(context) * 0.16,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: SizedBox(
                      width: 40,
                      child: Image.network(
                          '${Preference.getString(
                              Preference.PROFILE_IMAGE)}'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome',
                          style: Styles.regular(
                              color: ColorConstants.WHITE)),
                      Text(
                        '${Preference.getString(
                            Preference.FIRST_NAME)}',
                        style: Styles.bold(color: ColorConstants.WHITE),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: 8,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: BoxDecoration(
                    color: ColorConstants.WHITE.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: Stack(
                  children: [
                    Container(
                      height: 10,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width *
                          0.6 *
                          (30 / 100),
                      decoration: BoxDecoration(
                          color: Color(0xffFFB72F),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text('Profile completed: 30% ',
                  style: Styles.semiBoldWhite())
            ],
          ),
        ));
  }
}
