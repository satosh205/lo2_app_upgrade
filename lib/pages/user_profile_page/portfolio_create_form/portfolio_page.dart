import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/new_portfolio_response.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/auth_pages/choose_language.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/pdf_view_page.dart';
import 'package:masterg/pages/ghome/widget/read_more.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_certificate.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_education.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_experience.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_extra_act.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_portfolio.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/certificate_list.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/education_list.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/extra_activities_list.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/view_resume.dart';
import 'package:masterg/pages/user_profile_page/portfolio_list.dart';

import 'package:masterg/pages/user_profile_page/singularis_profile_edit.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

class NewPortfolioPage extends StatefulWidget {
  const NewPortfolioPage({super.key});

  @override
  State<NewPortfolioPage> createState() => _NewPortfolioPageState();
}

class _NewPortfolioPageState extends State<NewPortfolioPage> {
  bool editModeEnabled = true;
  bool? isPortfolioLoading = true;
  PortfolioResponse? portfolioResponse;

  @override
  void initState() {
    getPortfolio();

    super.initState();
  }

  void getPortfolio() {
    BlocProvider.of<HomeBloc>(context).add(PortfolioEvent());
  }

  List<String> listOfMonths = [
    "Janaury",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  Widget build(BuildContext context) {
    String? baseUrl = portfolioResponse?.data.baseFileUrl;

    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is PortfolioState) {
              handlePortfolioState(state);
            }
          },
          child: Scaffold(
              body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.3,
                          padding: EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: ColorConstants.WHITE,
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: <Color>[
                                  Color(0xfffc7804),
                                  ColorConstants.GRADIENT_RED
                                ]),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: ColorConstants.WHITE,
                                      )),
                                  Spacer(),

                                  IconButton(
                                      onPressed: () {
                                        AlertsWidget.showCustomDialog(
                                            context: context,
                                            title:
                                                '${Strings.of(context)?.leavingSoSoon}',
                                            text:
                                                '${Strings.of(context)?.areYouSureYouWantToExit}',
                                            icon:
                                                'assets/images/circle_alert_fill.svg',
                                            onOkClick: () async {
                                              UserSession.clearSession();
                                              await Hive.deleteFromDisk();
                                              Preference.clearPref()
                                                  .then((value) {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    NextPageRoute(
                                                        ChooseLanguage(
                                                      showEdulystLogo: true,
                                                    )),
                                                    (route) => false);
                                              });
                                            });
                                      },
                                      icon: Icon(
                                        Icons.share,
                                        color: ColorConstants.WHITE,
                                      )),
                                 
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(
                                                                      20))),
                                                  context: context,
                                                  builder: (context) {
                                                    return FractionallySizedBox(
                                                      heightFactor: 0.4,
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Row(
                                                              children: [
                                                                Spacer(),
                                                                IconButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  icon: Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            ListTile(
                                                              leading: SvgPicture
                                                                  .asset(
                                                                      'assets/images/camera.svg'),
                                                              title: new Text(
                                                                'View or edit profile picture',
                                                                style: Styles
                                                                    .regular(
                                                                        size:
                                                                            14),
                                                              ),
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                            ListTile(
                                                              leading: SvgPicture
                                                                  .asset(
                                                                      'assets/images/portfolio_video.svg'),
                                                              title: new Text(
                                                                'Add profile video',
                                                                style: Styles
                                                                    .regular(
                                                                        size:
                                                                            14),
                                                              ),
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '${Preference.getString(Preference.PROFILE_IMAGE)}',
                                                filterQuality:
                                                    FilterQuality.low,
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 40,
                                            top: 40,
                                            child: InkWell(
                                              onTap: () {
                                                // showBottomSheet(context);
                                                /*Navigator.push(
                                      context,
                                      NextPageRoute(ChangeImage()));*/
                                              },
                                              child: Container(
                                                height: 30.0,
                                                width: 30.0,
                                                padding: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  border: Border.all(
                                                      width: 0,
                                                      color:
                                                          Colors.transparent),
                                                  color: Color(0xfffc7804),
                                                ),
                                                child: SvgPicture.asset(
                                                    'assets/images/profile_play.svg'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                '${Preference.getString(Preference.FIRST_NAME)}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                style: Styles.bold(
                                                    size: 18,
                                                    color:
                                                        ColorConstants.WHITE)),
                                            Text(
                                                '${Preference.getString(Preference.USER_HEADLINE)}',
                                                style: Styles.regular(
                                                    size: 12,
                                                    color:
                                                        ColorConstants.WHITE)),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/images/person_location.svg'),
                                                Text(
                                                    '${Preference.getString(Preference.LOCATION)}',
                                                    style: Styles.regular(
                                                        size: 12,
                                                        color: ColorConstants
                                                            .WHITE)),
                                                Spacer(),
                                                SizedBox(
                                                    width: 18,
                                                    child: Transform.scale(
                                                        scale: 1.2,
                                                        child: InkWell(
                                                          onTap: () async {
                                                            await showModalBottomSheet(
                                                              backgroundColor: 
                                                             ColorConstants
                                                                            .WHITE ,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                context:
                                                                    context,
                                                                enableDrag:
                                                                    true,
                                                                isScrollControlled:
                                                                    true,
                                                                builder:
                                                                    (context) {
                                                                  return FractionallySizedBox(
                                                                    heightFactor:
                                                                        0.7,
                                                                    child: Container(
                                                                        height: height(
                                                                            context),
                                                                        color: ColorConstants
                                                                            .WHITE,
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                8.0),
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                10),
                                                                        child:
                                                                            EditProfilePage()),
                                                                  );
                                                                }).then((value) => getPortfolio());
                                                          },
                                                          child: SvgPicture.asset(
                                                              'assets/images/edit.svg'),
                                                        )))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${Preference.getString(Preference.ABOUT_ME)}',
                            style: Styles.regular(
                                size: 12, color: Color(0xff5A5F73)),
                          ),
                        ),
                        
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SvgPicture.asset('assets/images/call.svg'),
                                SizedBox(width: 1),
                                SvgPicture.asset('assets/images/email.svg'),
                                VerticalDivider(
                                  color: Color(0xffECECEC),
                                  width: 10,
                                  thickness: 2,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                SvgPicture.asset('assets/images/linkedin.svg'),
                                SvgPicture.asset('assets/images/behance.svg'),
                                SvgPicture.asset('assets/images/insta.svg'),
                                SvgPicture.asset('assets/images/dribble.svg'),
                                SvgPicture.asset('assets/images/pintrest.svg'),
                                SvgPicture.asset(
                                    'assets/images/vertical_menu.svg'),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Positioned(
                        left: 25,
                        right: 25,
                        top: 170,
                        child: Container(
                          height: 100,
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              color: ColorConstants.WHITE,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff898989).withOpacity(0.1),
                                    offset: Offset(0, 4.0),
                                    blurRadius: 11)
                              ],
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Rank',
                                      style: Styles.regular(size: 12),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            height: 30,
                                            child: SvgPicture.asset(
                                                'assets/images/leaderboard.svg')),
                                        // SizedBox(width: 2),
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
                                            '1',
                                            style: Styles.bold(size: 24),
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      'out of 500 Students',
                                      style: Styles.regular(
                                          size: 10, color: Color(0xff5A5F73)),
                                    )
                                  ],
                                ),
                                SizedBox(width: 20),
                                VerticalDivider(
                                  color: Color(0xffECECEC),
                                  width: 10,
                                  thickness: 2,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                SizedBox(width: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Points',
                                      style: Styles.regular(size: 12),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            height: 30,
                                            child: SvgPicture.asset(
                                                'assets/images/coin.svg')),
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
                                            '50',
                                            style: Styles.bold(size: 24),
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      'gained from 5 activities',
                                      style: Styles.regular(
                                          size: 10, color: Color(0xff5A5F73)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
                Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.94,
                      child: Divider()),
                ),
                
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        NextPageRoute(ViewResume(
                          resumeId: portfolioResponse?.data.resume.first.id,
                          resumUrl:
                              '$baseUrl${portfolioResponse?.data.resume.first.url}',
                        
                        )));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/resume.svg'),
                      SizedBox(width: 6),
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
                          'View Resume',
                          style: Styles.bold(size: 14),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                dividerLine(),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Skills Level & Badges',
                                style: Styles.semibold(size: 16),
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_rounded)
                            ],
                          ),
                          Divider(),
                          SizedBox(
                            height: height(context) * 0.15,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Image.asset(
                                  'assets/images/temp/ux_design.png',
                                  width: 100,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  'assets/images/temp/prototype.png',
                                  width: 100,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  'assets/images/temp/informational.png',
                                  width: 100,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  'assets/images/temp/information.png',
                                  width: 100,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  'assets/images/temp/linux.png',
                                  width: 100,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  'assets/images/temp/linuxy.png',
                                  width: 100,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  'assets/images/temp/information.png',
                                  width: 100,
                                ),
                              ],
                            ),
                          ),
                          dividerLine(),
                          Row(
                            children: [
                              Text(
                                'Portfolio',
                                style: Styles.semibold(size: 16),
                              ),
                              Spacer(),
                              InkWell(
                                  onTap: (() async {

 Navigator.of(context).push( PageRouteBuilder(
  transitionDuration: Duration(milliseconds: 600),
  reverseTransitionDuration: Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) =>  AddPortfolio(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  )).then((value) => getPortfolio());

                                  }),
                                  child: Icon(Icons.add)),
                              SizedBox(
                                width: 8,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        NextPageRoute(PortfolioList(
                                            baseUrl: portfolioResponse
                                                ?.data.baseFileUrl,
                                            portfolioList: portfolioResponse
                                                ?.data.portfolio)));
                                  },
                                  icon: Icon(Icons.arrow_forward_ios_rounded)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Divider(),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: isPortfolioLoading == false
                                ? ListView.builder(
                                    itemCount: portfolioResponse
                                        ?.data.portfolio.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: CachedNetworkImage(
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                          downloadProgress) {
                                                    return SvgPicture.asset(
                                                      'assets/images/default_user.svg',
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.3,
                                                    );
                                                  },
                                                  imageUrl:
                                                      '${portfolioResponse?.data.baseFileUrl}${portfolioResponse?.data.portfolio[index].imageName}',
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3,
                                                  fit: BoxFit.cover,
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.3,
                                                      padding:
                                                          EdgeInsets.all(14),
                                                      decoration: BoxDecoration(
                                                          color: Color(
                                                              0xffD5D5D5)),
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                '${portfolioResponse?.data.portfolio[index].portfolioTitle}',
                                                style: Styles.bold(),
                                              ),
                                              Text(
                                                  '${portfolioResponse?.data.portfolio[index].desc}',
                                                  style: Styles.semibold(
                                                      size: 12,
                                                      color:
                                                          Color(0xff929BA3))),
                                            ],
                                          ),
                                        ))
                                : Text('no portfolio found '),
                          ),
                          dividerLine(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Competitions',
                                  style: Styles.bold(size: 16),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios_outlined),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Divider(),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Divider(),
                          ),
                          SizedBox(
                            height: height(context) * 0.35,
                            child: ListView.builder(
                                itemCount: 3,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, int) => Container(
                                      padding: EdgeInsets.only(bottom: 8),
                                      margin: EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: ColorConstants.GREY_4)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8)),
                                            child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://picsum.photos/seed/picsum/300/300',
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.65,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25,
                                                fit: BoxFit.cover),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              'Ui Design Test Series',
                                              style: Styles.bold(),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Row(
                                              children: [
                                                Text('Rank : 20',
                                                    style: Styles.semibold(
                                                        size: 12,
                                                        color:
                                                            Color(0xff929BA3))),
                                                SizedBox(width: 8),
                                                SvgPicture.asset(
                                                  'assets/images/coin.svg',
                                                  width: width(context) * 0.04,
                                                ),
                                                Text(' • ',
                                                    style: Styles.semibold(
                                                        size: 12,
                                                        color:
                                                            Color(0xff929BA3))),
                                                Text('120 Points Earned',
                                                    style: Styles.semibold(
                                                        size: 12,
                                                        color:
                                                            Color(0xff929BA3))),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          dividerLine(),
                          Row(
                            children: [
                              Text(
                                'Education',
                                style: Styles.semibold(size: 16),
                              ),
                              Spacer(),
                              InkWell(
                                  onTap: (() async {

 Navigator.of(context).push( PageRouteBuilder(
  transitionDuration: Duration(milliseconds: 600),
  reverseTransitionDuration: Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) =>  AddEducation(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  )).then((value) => getPortfolio());

                                    
                            
                                  }),
                                  child: Icon(Icons.add)),
                              SizedBox(
                                width: 8,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        NextPageRoute(EducationList(
                                          baseUrl: portfolioResponse
                                              ?.data.baseFileUrl,
                                          education:
                                              portfolioResponse?.data.education
                                                  as List<CommonProfession>,
                                        )));
                                  },
                                  icon: Icon(Icons.arrow_forward_ios_rounded))
                            ],
                          ),
                        ])),
                // education list
                isPortfolioLoading == false
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: portfolioResponse?.data.education.length,
                        itemBuilder: (context, index) {
                          String startDateString =
                              "${portfolioResponse?.data.education[index].startDate}";
                          String endDateString =
                              "${portfolioResponse?.data.education[index].endDate}";
                          DateTime startDate =
                              DateFormat("dd/MM/yyyy").parse(startDateString);
                          DateTime endDate =
                              DateFormat("dd/MM/yyyy").parse(endDateString);
                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '${portfolioResponse?.data.baseFileUrl}${portfolioResponse?.data.education[index].imageName}',
                                          height: width(context) * 0.3,
                                          width: width(context) * 0.3,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) {
                                            return Container(
                                              padding: EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                  color: Color(0xffD5D5D5)),
                                              child: SvgPicture.asset(
                                                'assets/images/default_education.svg',
                                                height: 40,
                                                width: 40,
                                                color: ColorConstants.GREY_5,
                                                allowDrawingOutsideViewBox:
                                                    true,
                                              ),
                                            );
                                          },
                                          placeholder: (BuildContext context,
                                              loadingProgress) {
                                            return Container(
                                              padding: EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                  color: Color(0xffD5D5D5)),
                                              child: SvgPicture.asset(
                                                'assets/images/default_education.svg',
                                                height: 40,
                                                width: 40,
                                                color: ColorConstants.GREY_5,
                                                allowDrawingOutsideViewBox:
                                                    true,
                                              ),
                                            );
                                          },
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: width(context)*0.5,
                                          child: Text(
                                            '${portfolioResponse?.data.education[index].title}',
                                            style: Styles.bold(size: 16),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        SizedBox(
                                          width: width(context)*0.5,
                                          child: Text(
                                            maxLines:2,
                                            
                                            '${portfolioResponse?.data.education[index].institute}',
                                            style: Styles.regular(size: 14),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              '${startDate.day} ${listOfMonths[startDate.month]} - ',
                                              style: Styles.regular(size: 14),
                                            ),
                                            Text(
                                              '${endDate.day} ${listOfMonths[endDate.month]}',
                                              style: Styles.regular(size: 14),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ReadMoreText(
                                  viewMore: 'View more',
                                  text:
                                      '${portfolioResponse?.data.education[index].description}',
                                  color: Color(0xff929BA3),
                                ),
                                if (index !=
                                    portfolioResponse?.data.education.length)
                                  Divider(),
                              ],
                            ),
                          );
                        })
                    : Text('no portfolio found '),

                if (isPortfolioLoading == false) ...[
                  dividerLine(),
                  if (isPortfolioLoading == false)
                    getCertificateWidget(
                        portfolioResponse?.data.certificate, context),
                  dividerLine(),
                  getExperience(portfolioResponse?.data.experience, context),
                  dividerLine(),
                  getRecentActivites(),
                  dividerLine(),
                  getExtraActivitesWidget(
                      portfolioResponse?.data.extraActivities, context),
                ],
              ])))),
    );
  }

  Widget getRecentActivites() {
    return Column(
      children: [
        topRow('Recent Activites', addAction :  () {}, arrowAction : (){}, showAddButton: false),
        SizedBox(
          height: height(context) * 0.5,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              postCard(
                  imageUrl:
                      'https://images.unsplash.com/photo-1674708059513-5f77494844db?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1M3x8fGVufDB8fHx8&auto=format&fit=crop&w=900&q=60'),
              postCard(
                  imageUrl:
                      'https://images.unsplash.com/photo-1661961110372-8a7682543120?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80')
            ],
          ),
        ),
      ],
    );
  }

  Widget postCard({imageUrl}) {
    return Container(
      width: width(context) * 0.75,
      height: height(context) * 0.35,
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          border: Border.all(color: ColorConstants.DIVIDER),
          borderRadius: BorderRadius.circular(8),
          color: ColorConstants.WHITE),
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            ClipOval(
              child: Image.network(
                'https://lh5.googleusercontent.com/aRaK_2uiz9r1mk7xAIPIAqK3BEQkrRwMOwSybswjXVZpFWsAuMfpWzDEw2QmzurGHpo7Rs-oHyNlt40KQe3Xu-xjqRrdP3rG9A1cJbAUmIE_XmYAJumf-mDI62cRf9mgcHG6T4OH',
                width: width(context) * 0.13,
                height: width(context) * 0.13,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('Annie Richards'), Text('1 hr')],
            ),
          ],
        ),
        SizedBox(
          height: 6,
        ),
        ReadMoreText(
            text:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sitstas vat at egestas venenatis ut.'),
        SizedBox(
          height: 20,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            '$imageUrl',
            width: width(context) * 0.65,
            height: height(context) * 0.25,
            fit: BoxFit.cover,
          ),
        )
      ]),
    );
  }

  Widget getCertificateWidget(
      List<CommonProfession>? certificateList, context) {
    return Column(
      children: [
        topRow('Certificates',  arrowAction: (){
          Navigator.push(context, NextPageRoute(CertificateList()));
        },addAction:  () async {
    
     Navigator.of(context).push( PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 600),
    reverseTransitionDuration: Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) =>  AddCertificate(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
    
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    )).then((value) => getPortfolio());
          // await showModalBottomSheet(
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(20)),
          //     context: context,
          //     enableDrag: true,
          //     isScrollControlled: true,
          //     builder: (context) {
          //       return FractionallySizedBox(
          //         heightFactor: 0.7,
          //         child: Container(
          //             height: height(context),
          //             padding: const EdgeInsets.all(8.0),
          //             margin: const EdgeInsets.only(top: 10),
          //             child: AddCertificate()),
          //       );
          //     }).then((value) => getPortfolio());
        }),
        Container(
          padding: EdgeInsets.all(8),
          height: height(context) * 0.43,
          child: ListView.builder(
              itemCount: certificateList?.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String startDateString =
                    "${portfolioResponse?.data.education[index].startDate}";
          
                DateTime startDate =
                    DateFormat("dd/MM/yyyy").parse(startDateString);
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width(context) * 0.7,
                        height: width(context) * 0.45,
                        child: CachedNetworkImage(
                          width: width(context) * 0.7,
                          height: width(context) * 0.45,
                          imageUrl:
                              '${portfolioResponse?.data.baseFileUrl}${certificateList?[index].imageName}',
                          errorWidget: (context, url, data) => Image.asset(
                            "assets/images/certificate_dummy.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text('${certificateList?[index].title}',
                          style: Styles.bold(size: 18)),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${listOfMonths[startDate.month]} ${startDate.day}',
                        // '${certificateList?[index].startDate ?? 'Sep 21'}',
                        style: Styles.regular(),
                      ),
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget getExperience(List<CommonProfession>? experience, context) {
    return Column(
      children: [
        topRow('Experience',arrowAction: (){
          // Navigator.push(context, NextPageRoute(Experti));
        } , addAction:  () {
               Navigator.of(context).push( PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 600),
    reverseTransitionDuration: Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) =>  AddExperience(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
    
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    )).then((value) => getPortfolio());
        //   showModalBottomSheet(
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(20)),
        //       context: context,
        //       enableDrag: true,
        //       isScrollControlled: true,
        //       builder: (context) {
        //         return FractionallySizedBox(
        //           heightFactor: 0.7,
        //           child: Container(
        //               height: height(context),
        //               padding: const EdgeInsets.all(8.0),
        //               margin: const EdgeInsets.only(top: 10),
        //               child: AddExperience()),
        //         );
        //       });
         }),
        Container(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: experience?.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                String startDateString =
                    "${portfolioResponse?.data.education[index].startDate}";
                String endDateString =
                    "${portfolioResponse?.data.education[index].endDate}";
                DateTime startDate =
                    DateFormat("dd/MM/yyyy").parse(startDateString);
                DateTime endDate =
                    DateFormat("dd/MM/yyyy").parse(endDateString);
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width(context) * 0.3,
                            height: height(context) * 0.1,
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${portfolioResponse?.data.baseFileUrl}${experience?[index].imageName}',
                              errorWidget: (context, url, data) => Image.asset(
                                "assets/images/certificate_dummy.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: width(context) * 0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${experience?[index].title}',
                                  style: Styles.bold(),
                                ),
                                Text(
                                  '${experience?[index].institute}',
                                  style: Styles.regular(),
                                ),
                                Text(
                                  'Internship • ${calculateTimeDifferenceBetween(startDate, endDate)} • ${startDate.day} ${listOfMonths[startDate.month].substring(0, 3)} - ${endDate.day} ${listOfMonths[endDate.month].substring(0, 3)}',
                                  style: Styles.regular(size: 14),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ReadMoreText(
                        text: '${experience?[index].description}',
                        color: ColorConstants.GREY_3,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Divider(),
                      )
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget getExtraActivitesWidget(
      List<CommonProfession>? extraActivities, context) {
    return Column(
      children: [
        topRow('Extra Curricular Activities',arrowAction: (){
          Navigator.push(context, NextPageRoute(ExtraActivitiesList(activities: [],)));
        } ,addAction:  () {
            Navigator.of(context).push( PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 600),
    reverseTransitionDuration: Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) =>  AddActivities(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
    
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    )).then((value) => getPortfolio());
          // showModalBottomSheet(
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(20)),
          //     context: context,
          //     enableDrag: true,
          //     isScrollControlled: true,
          //     builder: (context) {
          //       return FractionallySizedBox(
          //         heightFactor: 0.7,
          //         child: Container(
          //             height: height(context),
          //             padding: const EdgeInsets.all(8.0),
          //             margin: const EdgeInsets.only(top: 10),
          //             child: AddActivities()),
          //       );
          //     });
        }),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: ListView.builder(
              itemCount: extraActivities?.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width(context) * 0.2,
                            height: width(context) * 0.2,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${portfolioResponse?.data.baseFileUrl}${extraActivities?[index].imageName}",
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) => Container(
                                  width: width(context) * 0.2,
                                  height: width(context) * 0.2,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: ColorConstants.DIVIDER,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: SvgPicture.asset(
                                      'assets/images/extra.svg')),
                            ),
                          ),
                          SizedBox(width: 6),
                          SizedBox(
                            width: width(context) * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${extraActivities?[index].title}',
                                  style: Styles.bold(size: 16),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  '${extraActivities?[index].institute}',
                                  style: Styles.regular(size: 14),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text('${extraActivities?[index].title}'),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      ReadMoreText(
                        viewMore: 'View more',
                        text: '${extraActivities?[index].description}',
                        color: Color(0xff929BA3),
                      ),
                      if (index != extraActivities?.length) Divider()
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget dividerLine() {
    return const Divider(
      thickness: 18,
      color: Color(0xffF2F2F2),
    );
  }

  Widget skillProgess(String title, int rating, double percent) {
    String? position;
    String? image = 'assets/images/';
    switch (rating) {
      case 5:
        position = 'LEADER';
        image += 'leader.svg';
        break;

      case 4:
        position = 'EXPERT';
        image += 'expert.svg';
        break;

      case 3:
        position = 'MASTER';
        image += 'master.svg';

        break;

      case 2:
        position = 'Learner';
        image += 'learner.svg';

        break;

      case 1:
        position = 'NOVICE';
        image += 'novice.svg';

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
                  Stack(
                    children: [
                      Transform.translate(
                        offset: Offset(-1, 9),
                        child: SvgPicture.asset(
                          'assets/images/half_circle.svg',
                          width: 78,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 60,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  Opacity(
                                    opacity: i < rating ? 1 : 0.5,
                                    child: SvgPicture.asset(
                                      'assets/images/star_portfolio_unselected.svg',
                                      width: 10,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
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

  void handlePortfolioState(PortfolioState state) {
    var portfolioState = state;
    setState(() async {
      switch (portfolioState.apiState) {
        case ApiStatus.LOADING:
          Log.v("PortfolioState Loading....................");
          isPortfolioLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("PortfolioState Success....................");
          portfolioResponse = portfolioState.response;
          Preference.setString(
              Preference.FIRST_NAME, '${portfolioState.response?.data.name}');
          Preference.setString(Preference.PROFILE_IMAGE,
              '${portfolioState.response?.data.image}');
          Preference.setString(Preference.PROFILE_VIDEO,
              '${portfolioState.response?.data.profileVideo}');

          Preference.setString(Preference.PROFILE_VIDEO,
              '${portfolioState.response?.data.profileVideo}');

          Preference.setString(Preference.ABOUT_ME,
              '${portfolioState.response?.data.portfolioProfile.first.aboutMe}');

          Preference.setString(Preference.USER_HEADLINE,
              '${portfolioState.response?.data.portfolioProfile.first.headline}');
          Preference.setString(Preference.LOCATION,
              '${portfolioState.response?.data.portfolioProfile.first.city}, ${portfolioState.response?.data.portfolioProfile.first.country}');
          isPortfolioLoading = false;
          setState(() {});
          break;

        case ApiStatus.ERROR:
          isPortfolioLoading = false;
          Log.v("PortfolioState Error..........................");
          Log.v(
              "PortfolioState Error..........................${portfolioState.error}");

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  Widget topRow(String title,{required Function addAction,required Function arrowAction, bool showAddButton = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          if (!showAddButton)
            SizedBox(
              height: 10,
            ),
          Row(
            children: [
              Text(
                '$title',
                style: Styles.bold(size: 16),
              ),
              Spacer(),
              if (showAddButton)
                IconButton(
                    onPressed: () {
                      addAction();
                    },
                    icon: Icon(Icons.add)),
              InkWell(
                onTap: (() {
                  arrowAction();
                }),
                child: Icon(Icons.arrow_forward_ios_outlined)),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  String calculateTimeDifferenceBetween(DateTime startDate, DateTime endDate) {
    int seconds = endDate.difference(startDate).inSeconds;
    if (seconds < 60) {
      if (seconds.abs() < 4) return '${Strings.of(context)?.justNow}';
      return '${seconds.abs()} ${Strings.of(context)?.s}';
    } else if (seconds >= 60 && seconds < 3600)
      return '${startDate.difference(endDate).inMinutes.abs()} ${Strings.of(context)?.m}';
    else if (seconds >= 3600 && seconds < 86400)
      return '${startDate.difference(endDate).inHours.abs()} ${Strings.of(context)?.h}';
    else {
      // convert day to month
      int days = startDate.difference(endDate).inDays.abs();
      if (days < 30 && days > 7) {
        return '${(startDate.difference(endDate).inDays ~/ 7).abs()} ${Strings.of(context)?.w}';
      }
      if (days > 30) {
        int month = (startDate.difference(endDate).inDays ~/ 30).abs();
        return '$month ${Strings.of(context)?.mos}';
      } else
        return '${startDate.difference(endDate).inDays.abs()} ${Strings.of(context)?.d}';
    }
  }
}
