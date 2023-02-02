import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/pages/singularis/careers/skill/skill_assessment.dart';
import 'package:masterg/pages/singularis/community/tab2/alumni_voice.dart';
import 'package:masterg/pages/singularis/job/job_dashboard_page.dart';

import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import 'package:masterg/pages/user_profile_page/portfolio_page.dart';
import '../../../local/pref/Preference.dart';
import '../../../utils/Styles.dart';
import '../../../utils/constant.dart';
import '../../../utils/resource/colors.dart';
import '../../../utils/resource/size_constants.dart';
import '../../custom_pages/custom_widgets/NextPageRouting.dart';
import '../../custom_pages/custom_widgets/rounded_appbar.dart';
import '../../gcarvaan/post/gcarvaan_post_page.dart';
import '../../reels/reels_dashboard_page.dart';

class CommunityDashboard extends StatefulWidget {
  const CommunityDashboard({Key? key}) : super(key: key);

  @override
  State<CommunityDashboard> createState() => _CommunityDashboardState();
}

class _CommunityDashboardState extends State<CommunityDashboard> {
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
        listener: (context, state) async{},
        child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  _customAppBar(),
                  Padding(
                    padding: const EdgeInsets.only(right: 108.0),
                    child: TabBar(
                      labelColor: ColorConstants.selected,
                      unselectedLabelColor: ColorConstants.GREY_3,
                      indicatorColor: ColorConstants.selected,
                      labelPadding: EdgeInsets.all(0),
                      unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,
                      ),
                      //labelStyle: TextStyle(foreground: new Paint()..shader = linearGradient,fontSize: 14, fontWeight: FontWeight.w700),
                      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      tabs: [
                        Tab(text: "Community",),
                        Tab(text: "Alumni Voice"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                      GCarvaanPostPage(
                      fileToUpload: null,
                      desc: null,
                      filesPath: null,
                      formCreatePost: false,),
                        AlumniVoice(),
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
        appBarHeight: height(context) * 0.1,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment:
                MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Portfolio()));
                        },
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(
                              200),
                          child: SizedBox(
                            width: 40,
                            child: Image.network(
                                '${Preference.getString(Preference.PROFILE_IMAGE)}'),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 8,
                            width:
                            MediaQuery.of(context)
                                .size
                                .width *
                                0.5,
                            decoration: BoxDecoration(
                                color: ColorConstants
                                    .WHITE
                                    .withOpacity(0.2),
                                borderRadius:
                                BorderRadius
                                    .circular(10)),
                            child: Stack(
                              children: [
                                Container(
                                  height: 10,
                                  width: MediaQuery.of(
                                      context)
                                      .size
                                      .width *
                                      0.6 *
                                      (30 / 100),
                                  decoration: BoxDecoration(
                                      color: Color(
                                          0xffFFB72F),
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                          10)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                              'Profile completed: 30% ',
                              style: Styles
                                  .semiBoldWhite())
                        ],
                      ),
                      Spacer(),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, NextPageRoute(ReelsDashboardPage()));
                        },
                        child: Container(
                            margin:
                            EdgeInsets.only(left: 4),
                            padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8),
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(
                                    10),
                                color: ColorConstants
                                    .WHITE
                                    .withOpacity(0.5)),
                            child: Row(
                              children: [
                                Container(
                                    padding:
                                    EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        shape: BoxShape
                                            .circle,
                                        color:
                                        ColorConstants
                                            .WHITE),
                                    child: Center(
                                        child: SvgPicture
                                            .asset(
                                            'assets/images/GReelsS.svg'))),
                                SizedBox(width: 4),
                                Text('Reels',
                                    style: Styles.semibold(
                                        size: 14,
                                        color: Color(
                                            0xff0E1638)))
                              ],
                            )),
                      ),
                    ],
                  ),
                ])));
  }

  Widget _customAppBar11() {
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
