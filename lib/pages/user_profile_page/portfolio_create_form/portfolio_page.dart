import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/competition_response.dart';
import 'package:masterg/data/models/response/home_response/new_portfolio_response.dart';
import 'package:masterg/data/models/response/home_response/portfolio_competition_response.dart';
import 'package:masterg/data/models/response/home_response/top_score.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/auth_pages/choose_language.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/pdf_view_page.dart';
import 'package:masterg/pages/ghome/widget/read_more.dart';
import 'package:masterg/pages/singularis/competition/competition_detail.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_certificate.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_education.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_experience.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_extra_act.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_portfolio.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/certificate_list.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/education_list.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/experience_list.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/extra_activities_list.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/social_page.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/view_edit_profile_image.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/view_resume.dart';
import 'package:masterg/pages/user_profile_page/portfolio_detail.dart';
import 'package:masterg/pages/user_profile_page/portfolio_list.dart';

import 'package:masterg/pages/user_profile_page/singularis_profile_edit.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/size_constants.dart';
import 'package:page_transition/page_transition.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../utils/utility.dart';
import '../../custom_pages/custom_widgets/CommonWebView.dart';
import '../../singularis/recentactivities/recent_activities_page.dart';

class NewPortfolioPage extends StatefulWidget {
  const NewPortfolioPage({super.key});

  @override
  State<NewPortfolioPage> createState() => _NewPortfolioPageState();
}

class _NewPortfolioPageState extends State<NewPortfolioPage> {
  bool editModeEnabled = true;
  bool? isPortfolioLoading = true;
  bool? isCompetitionLoading = true;
  PortfolioResponse? portfolioResponse;
  PortfolioCompetitionResponse? competition;
  TopScoringResponse? userRank;
  double dividerMarginTop = 12.0;
  File? pickedFile;
  List<File> pickedList = [];
  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 10;
  String? _tempDir;
  String? filePath;

  @override
  void initState() {
    getPortfolio();
    getPortfolioCompetition();
    topScoringUser();

    super.initState();
  }

  void getPortfolio() {
    BlocProvider.of<HomeBloc>(context).add(PortfolioEvent());
  }

  void topScoringUser() {
    BlocProvider.of<HomeBloc>(context).add(
        TopScoringUserEvent(userId: Preference.getInt(Preference.USER_ID)));
  }

  void getPortfolioCompetition() {
    BlocProvider.of<HomeBloc>(context).add(PortfolioCompetitoinEvent());
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

  void _showPopupMenu(Offset offset) async {
    final screenSize = MediaQuery.of(context).size;
    double left = offset.dx;
    double top = offset.dy;
    double right = screenSize.width - offset.dx;
    double bottom = screenSize.height - offset.dy;
    await showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, bottom),
      items: [
        if (portfolioResponse?.data.portfolioSocial.first.linkedin != "") ...[
          PopupMenuItem<String>(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CommonWebView(
                        url: portfolioResponse
                            ?.data.portfolioSocial.first.linkedin,
                      );
                    },
                  ),
                );
              });
            },
            child: Row(
              children: [
                Image.asset('assets/images/linkedin_p.png'),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text(
                    'Linkedin',
                  ),
                ),
              ],
            ),
          )
        ],
        if (portfolioResponse?.data.portfolioSocial.first.facebook != "") ...[
          PopupMenuItem<String>(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CommonWebView(
                        url: portfolioResponse
                            ?.data.portfolioSocial.first.facebook,
                      );
                    },
                  ),
                );
              });
            },
            child: Row(
              children: [
                Image.asset('assets/images/facebook_p.png'),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text('Facebook'),
                ),
              ],
            ),
          )
        ],
        if (portfolioResponse?.data.portfolioSocial.first.bee != "") ...[
          PopupMenuItem<String>(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CommonWebView(
                        url: portfolioResponse?.data.portfolioSocial.first.bee,
                      );
                    },
                  ),
                );
              });
            },
            child: Row(
              children: [
                Image.asset('assets/images/behance_p.png'),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text('Bee'),
                ),
              ],
            ),
          )
        ],
        if (portfolioResponse?.data.portfolioSocial.first.dribble != "") ...[
          PopupMenuItem<String>(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CommonWebView(
                        url: portfolioResponse
                            ?.data.portfolioSocial.first.dribble,
                      );
                    },
                  ),
                );
              });
            },
            child: Row(
              children: [
                Image.asset('assets/images/linkedin_p.png'),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text('Dribble'),
                ),
              ],
            ),
          )
        ],
        if (portfolioResponse?.data.portfolioSocial.first.insta != "") ...[
          PopupMenuItem<String>(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CommonWebView(
                        url:
                            portfolioResponse?.data.portfolioSocial.first.insta,
                      );
                    },
                  ),
                );
              });
            },
            child: Row(
              children: [
                Image.asset('assets/images/instagram_p.png'),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text('Instagram'),
                ),
              ],
            ),
          )
        ],
        if (portfolioResponse?.data.portfolioSocial.first.twitter != "") ...[
          PopupMenuItem<String>(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CommonWebView(
                        url: portfolioResponse
                            ?.data.portfolioSocial.first.twitter,
                      );
                    },
                  ),
                );
              });
            },
            child: Row(
              children: [
                Image.asset('assets/images/twitter_p.png'),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text('Twitter'),
                ),
              ],
            ),
          )
        ],
        if (portfolioResponse?.data.portfolioSocial.first.pinterest != "") ...[
          PopupMenuItem<String>(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CommonWebView(
                        url: portfolioResponse
                            ?.data.portfolioSocial.first.pinterest,
                      );
                    },
                  ),
                );
              });
            },
            child: Row(
              children: [
                Image.asset('assets/images/pinterest_p.png'),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text('Pinterest'),
                ),
              ],
            ),
          )
        ],
        if (portfolioResponse?.data.portfolioSocial.first.siteUrl != "") ...[
          PopupMenuItem<String>(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CommonWebView(
                        url: portfolioResponse
                            ?.data.portfolioSocial.first.siteUrl,
                      );
                    },
                  ),
                );
              });
            },
            child: Row(
              children: [
                Image.asset('assets/images/globe_p.png'),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text('Site Url'),
                ),
              ],
            ),
          )
        ],
      ],
      elevation: 10.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    //String? baseUrl = portfolioResponse?.data.baseFileUrl;
    String? baseUrl = 'https://singularis.learningoxygen.com/portfolio/';

    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is PortfolioState) {
              handlePortfolioState(state);
            }
            if (state is PortfoilioCompetitionState) {
              handleCompetition(state);
            }
            if (state is TopScoringUserState) {
              handletopScoring(state);
            }
          },
          child: Scaffold(
              //backgroundColor: Color(0xffF2F2F2),
              body: SingleChildScrollView(
                  key: const PageStorageKey<String>('portfolioList'),
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
                                height: Preference.getString(
                                                Preference.FIRST_NAME)!
                                            .length >
                                        8
                                    ? MediaQuery.of(context).size.height * 0.35
                                    : MediaQuery.of(context).size.height * 0.3,
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
                                            onPressed: () async {
                                              String shareUrl = '$baseUrl' +
                                                  '/user-portfolio-webview?email=' +
                                                  '${Preference.getString(Preference.USER_EMAIL)}}';

                                              await Clipboard.setData(
                                                      ClipboardData(
                                                          text: shareUrl))
                                                  .then((value) =>
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            "Profile link copied"),
                                                      )));

                                              Share.share(shareUrl);
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
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
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
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    children: [
                                                                      Spacer(),
                                                                      IconButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  ListTile(
                                                                    leading: SvgPicture
                                                                        .asset(
                                                                            'assets/images/camera.svg'),
                                                                    title:
                                                                        new Text(
                                                                      'View or edit profile picture',
                                                                      style: Styles.regular(
                                                                          size:
                                                                              14),
                                                                    ),
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          NextPageRoute(UploadProfile(
                                                                            editVideo:
                                                                                false,
                                                                          )));
                                                                    },
                                                                  ),
                                                                  ListTile(
                                                                    leading: SvgPicture
                                                                        .asset(
                                                                            'assets/images/portfolio_video.svg'),
                                                                    title:
                                                                        new Text(
                                                                      'Add profile video',
                                                                      style: Styles.regular(
                                                                          size:
                                                                              14),
                                                                    ),
                                                                    onTap: () {
                                                                      // _initFilePiker();
                                                                      // Navigator.pop(context);

                                                                      Navigator.push(
                                                                          context,
                                                                          NextPageRoute(
                                                                              UploadProfile(editVideo: true)));
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },

                                                  //singh
                                                  child: ClipOval(
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          '${Preference.getString(Preference.PROFILE_IMAGE)}',
                                                      filterQuality:
                                                          FilterQuality.low,
                                                      width: SizeConstants
                                                          .USER_PROFILE_IMAGE_SIZE,
                                                      height: SizeConstants
                                                          .USER_PROFILE_IMAGE_SIZE,
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context,
                                                              error,
                                                              stackTrace) =>
                                                          SvgPicture.asset(
                                                        'assets/images/default_user.svg',
                                                        width: 50,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 40,
                                                  top: 40,
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (Preference.getString(
                                                                  Preference
                                                                      .PROFILE_VIDEO) !=
                                                              null &&
                                                          Preference.getString(
                                                                  Preference
                                                                      .PROFILE_VIDEO) !=
                                                              '')
                                                        Navigator.push(
                                                            context,
                                                            NextPageRoute(
                                                                UploadProfile(
                                                              playVideo: true,
                                                            )));
                                                      else
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              'No Profile video uploaded'),
                                                        ));
                                                    },
                                                    child: Container(
                                                      height: 30.0,
                                                      width: 30.0,
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        border: Border.all(
                                                            width: 0,
                                                            color: Colors
                                                                .transparent),
                                                        color:
                                                            Color(0xfffc7804),
                                                      ),
                                                      child: SvgPicture.asset(
                                                          'assets/images/profile_play.svg'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 14,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      '${Preference.getString(Preference.FIRST_NAME)}',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                      style: Styles.bold(
                                                          size: 18,
                                                          color: ColorConstants
                                                              .WHITE)),
                                                  Text(
                                                      Preference.getString(
                                                                  Preference
                                                                      .USER_HEADLINE) !=
                                                              null
                                                          ? '${Preference.getString(Preference.USER_HEADLINE)} '
                                                          : "",
                                                      style: Styles.regular(
                                                          size: 12,
                                                          color: ColorConstants
                                                              .WHITE)),
                                                  SizedBox(height: 4),
                                                  Row(
                                                    // mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Preference.getString(
                                                                  Preference
                                                                      .LOCATION) !=
                                                              null
                                                          ? SvgPicture.asset(
                                                              'assets/images/person_location.svg')
                                                          : SizedBox(),
                                                      Preference.getString(
                                                                  Preference
                                                                      .LOCATION) !=
                                                              null
                                                          ? SizedBox(
                                                              width: width(
                                                                      context) *
                                                                  0.6,
                                                              child: Text(
                                                                  '${Preference.getString(Preference.LOCATION)}',
                                                                  style: Styles.regular(
                                                                      size: 12,
                                                                      color: ColorConstants
                                                                          .WHITE)),
                                                            )
                                                          : SizedBox(),
                                                      Spacer(),
                                                      Transform.scale(
                                                          scale: 1.2,
                                                          child: InkWell(
                                                            onTap: () async {
                                                              await Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          duration: Duration(
                                                                              milliseconds:
                                                                                  600),
                                                                          reverseDuration: Duration(
                                                                              milliseconds:
                                                                                  600),
                                                                          type: PageTransitionType
                                                                              .bottomToTop,
                                                                          child:
                                                                              EditProfilePage()))
                                                                  .then((value) =>
                                                                      getPortfolio());
                                                            },
                                                            child: SvgPicture.asset(
                                                                'assets/images/edit.svg'),
                                                          ))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: ColorConstants.WHITE,
                                height: 50,
                              ),
                              Preference.getString(Preference.ABOUT_ME) != null
                                  ? Container(
                                      color: ColorConstants.WHITE,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${Preference.getString(Preference.ABOUT_ME)}',
                                          textAlign: TextAlign.center,
                                          style: Styles.regular(
                                              size: 12,
                                              color: Color(0xff5A5F73)),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              Container(
                                color: ColorConstants.WHITE,
                                child: Center(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await launch(
                                                "tel:${Preference.getString(Preference.PHONE)}");
                                          },
                                          child: SvgPicture.asset(
                                              'assets/images/call.svg'),
                                        ),
                                        SizedBox(width: 14),
                                        InkWell(
                                          onTap: () async {
                                            await launch(
                                                "mailto:${Preference.getString(Preference.USER_EMAIL)}");
                                          },
                                          child: SvgPicture.asset(
                                              'assets/images/email.svg'),
                                        ),
                                        SizedBox(width: 14),
                                        VerticalDivider(
                                          color: Color(0xffECECEC),
                                          width: 10,
                                          thickness: 2,
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                        SizedBox(width: 14),
                                        portfolioResponse?.data.portfolioSocial
                                                    .length ==
                                                0
                                            ? Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/images/linkedin_un.svg'),
                                                  SizedBox(width: 14),
                                                  SvgPicture.asset(
                                                      'assets/images/facebook_un.svg'),
                                                  SizedBox(width: 14),
                                                  SvgPicture.asset(
                                                      'assets/images/insta_un.svg'),
                                                  SizedBox(width: 14),
                                                  SvgPicture.asset(
                                                      'assets/images/twitter_un.svg'),
                                                  SizedBox(width: 14),
                                                  SvgPicture.asset(
                                                      'assets/images/behance_un.svg'),
                                                  SizedBox(width: 3),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  portfolioResponse
                                                              ?.data
                                                              .portfolioSocial
                                                              .first
                                                              .linkedin !=
                                                          ""
                                                      ? InkWell(
                                                          onTap: () async {
                                                            Navigator.push(
                                                                context,
                                                                NextPageRoute(
                                                                    CommonWebView(
                                                                  url: portfolioResponse
                                                                      ?.data
                                                                      .portfolioSocial
                                                                      .first
                                                                      .linkedin,
                                                                ))).then((isSuccess) {
                                                              if (isSuccess ==
                                                                  true) {
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              }
                                                            });
                                                          },
                                                          child: SvgPicture.asset(
                                                              'assets/images/linkedin.svg'),
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/images/linkedin_un.svg'),
                                                  // SizedBox(width: 14),

                                                  // portfolioResponse?.data.portfolioSocial.first.facebook != "" ?
                                                  // InkWell(
                                                  //   onTap: (){
                                                  //     Navigator.push(
                                                  //         context,
                                                  //         NextPageRoute(CommonWebView(
                                                  //           url: portfolioResponse?.data.portfolioSocial.first.facebook,
                                                  //         ))).then((isSuccess) {
                                                  //       if (isSuccess == true) {
                                                  //         Navigator.pop(context, true);
                                                  //       }
                                                  //     });
                                                  //   },
                                                  //   child: SvgPicture.asset(
                                                  //       'assets/images/facebook.svg'),
                                                  // )
                                                  // :SvgPicture.asset(
                                                  //     'assets/images/facebook_un.svg'),
                                                  SizedBox(width: 10),

                                                  portfolioResponse
                                                              ?.data
                                                              .portfolioSocial
                                                              .first
                                                              .insta !=
                                                          ""
                                                      ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                NextPageRoute(
                                                                    CommonWebView(
                                                                  url: portfolioResponse
                                                                      ?.data
                                                                      .portfolioSocial
                                                                      .first
                                                                      .insta,
                                                                ))).then((isSuccess) {
                                                              if (isSuccess ==
                                                                  true) {
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              }
                                                            });
                                                          },
                                                          child: SvgPicture.asset(
                                                              'assets/images/insta.svg'),
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/images/insta_un.svg'),
                                                  SizedBox(width: 14),

                                                  portfolioResponse
                                                              ?.data
                                                              .portfolioSocial
                                                              .first
                                                              .twitter !=
                                                          ""
                                                      ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                NextPageRoute(
                                                                    CommonWebView(
                                                                  url: portfolioResponse
                                                                      ?.data
                                                                      .portfolioSocial
                                                                      .first
                                                                      .twitter,
                                                                ))).then((isSuccess) {
                                                              if (isSuccess ==
                                                                  true) {
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              }
                                                            });
                                                          },
                                                          child: SvgPicture.asset(
                                                              'assets/images/twitter.svg'),
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/images/twitter_un.svg'),
                                                  SizedBox(width: 14),

                                                  portfolioResponse
                                                              ?.data
                                                              .portfolioSocial
                                                              .first
                                                              .dribble !=
                                                          ""
                                                      ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                NextPageRoute(
                                                                    CommonWebView(
                                                                  url: portfolioResponse
                                                                      ?.data
                                                                      .portfolioSocial
                                                                      .first
                                                                      .dribble,
                                                                ))).then((isSuccess) {
                                                              if (isSuccess ==
                                                                  true) {
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              }
                                                            });
                                                          },
                                                          child: SvgPicture.asset(
                                                              'assets/images/behance.svg'),
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/images/behance_un.svg'),
                                                  SizedBox(width: 3),
                                                ],
                                              ),

                                        /*SvgPicture.asset(
                                            'assets/images/pintrest.svg'),*/
                                        portfolioResponse?.data.portfolioSocial
                                                    .length !=
                                                0
                                            ? GestureDetector(
                                                onTapDown:
                                                    (TapDownDetails detail) {
                                                  _showPopupMenu(
                                                      detail.globalPosition);
                                                },
                                                child: SvgPicture.asset(
                                                    'assets/images/vertical_menu.svg'),
                                              )
                                            : SizedBox(),
                                        SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            if (portfolioResponse?.data
                                                    .portfolioSocial.length !=
                                                0)
                                              Navigator.push(
                                                  context,
                                                  NextPageRoute(SocialPage(
                                                      social: portfolioResponse
                                                          ?.data
                                                          .portfolioSocial
                                                          .first)));
                                            else
                                              Navigator.push(context,
                                                  NextPageRoute(SocialPage()));
                                          },
                                          child: SvgPicture.asset(
                                              'assets/images/add_icon_gradient.svg'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Positioned(
                              left: 25,
                              right: 25,
                              top: Preference.getString(Preference.FIRST_NAME)!
                                          .length >
                                      8
                                  ? 200
                                  : 170,
                              child: Container(
                                height: 100,
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: ColorConstants.WHITE,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xff898989)
                                              .withOpacity(0.1),
                                          offset: Offset(0, 4.0),
                                          blurRadius: 11)
                                    ],
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Rank',
                                            style: Styles.semibold(size: 12),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  height: 28,
                                                  width: 28,
                                                  child: SvgPicture.asset(
                                                      'assets/images/leaderboard.svg')),
                                              // SizedBox(width: 2),
                                              ShaderMask(
                                                blendMode: BlendMode.srcIn,
                                                shaderCallback: (Rect bounds) {
                                                  return LinearGradient(
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                      colors: <Color>[
                                                        Color(0xfffc7804),
                                                        ColorConstants
                                                            .GRADIENT_RED
                                                      ]).createShader(bounds);
                                                },
                                                child: Text(
                                                  userRank?.data.first.rank !=
                                                          null
                                                      ? '${userRank?.data.first.rank}'
                                                      : '0',
                                                  style: Styles.bold(size: 26),
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            userRank?.data.first.rank != null
                                                ? 'out of ${userRank?.data.first.rankOutOf} Students'
                                                : 'out of 0 Students',
                                            style: Styles.regular(
                                                size: 10,
                                                color: Color(0xff5A5F73)),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Points',
                                            style: Styles.semibold(size: 12),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  height: 28,
                                                  width: 28,
                                                  child: SvgPicture.asset(
                                                      'assets/images/coin.svg')),
                                              ShaderMask(
                                                blendMode: BlendMode.srcIn,
                                                shaderCallback: (Rect bounds) {
                                                  return LinearGradient(
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                      colors: <Color>[
                                                        Color(0xfffc7804),
                                                        ColorConstants
                                                            .GRADIENT_RED
                                                      ]).createShader(bounds);
                                                },
                                                child: Text(
                                                  userRank?.data.first.score !=
                                                          null
                                                      ? '${userRank?.data.first.score}'
                                                      : '0',
                                                  style: Styles.bold(size: 24),
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            'gained from 5 activities',
                                            style: Styles.regular(
                                                size: 10,
                                                color: Color(0xff5A5F73)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                        ],
                      ),
                      // Container(
                      //                         color: ColorConstants.WHITE,
                      //                         width: width(context),

                      //   child: Center(
                      //     child: SizedBox(
                      //         width: MediaQuery.of(context).size.width * 0.94,
                      //         child: Divider()),
                      //   ),
                      // ),

                      Container(
                        color: ColorConstants.WHITE,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () {
                            if (portfolioResponse?.data.resume.length == 0)
                              Navigator.push(
                                  context,
                                  NextPageRoute(ViewResume(
                                    resumeId: null,
                                    resumUrl: null,
                                  )));
                            else
                              Navigator.push(
                                  context,
                                  NextPageRoute(ViewResume(
                                    resumeId:
                                        portfolioResponse?.data.resume.first.id,
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
                                  portfolioResponse?.data.resume.length == 0
                                      ? 'Upload Resume'
                                      : 'View Resume',
                                  style: Styles.bold(size: 14),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      Container(
                          margin: EdgeInsets.only(top: dividerMarginTop),
                          color: ColorConstants.WHITE,
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Skills Level & Badges',
                                        style: Styles.semibold(size: 16),
                                      ),
                                      Spacer(),
                                      Icon(Icons.arrow_forward_ios_rounded)
                                    ],
                                  ),
                                ),
                                Divider(),
                                SizedBox(
                                    height: height(context) * 0.2,
                                    width: width(context),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/skill_star.svg',
                                            width: 40,
                                          ),
                                          RichText(
                                            text: new TextSpan(
                                              text: 'Complete ',
                                              style: Styles.DMSansregular(),
                                              children: <TextSpan>[
                                                new TextSpan(
                                                  text: 'Skill Assessments  ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red),
                                                ),
                                                new TextSpan(
                                                  text:
                                                      'to \n    gain skills and earn badges',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    //   child: ListView(
                                    //     scrollDirection: Axis.horizontal,
                                    //     children: [
                                    //       Image.asset(
                                    //         'assets/images/temp/ux_design.png',
                                    //         width: 100,
                                    //       ),
                                    //       SizedBox(
                                    //         width: 5,
                                    //       ),
                                    //       Image.asset(
                                    //         'assets/images/temp/prototype.png',
                                    //         width: 100,
                                    //       ),
                                    //       SizedBox(
                                    //         width: 5,
                                    //       ),
                                    //       Image.asset(
                                    //         'assets/images/temp/informational.png',
                                    //         width: 100,
                                    //       ),
                                    //       SizedBox(
                                    //         width: 5,
                                    //       ),
                                    //       Image.asset(
                                    //         'assets/images/temp/information.png',
                                    //         width: 100,
                                    //       ),
                                    //       SizedBox(
                                    //         width: 5,
                                    //       ),
                                    //       Image.asset(
                                    //         'assets/images/temp/linux.png',
                                    //         width: 100,
                                    //       ),
                                    //       SizedBox(
                                    //         width: 5,
                                    //       ),
                                    //       Image.asset(
                                    //         'assets/images/temp/linuxy.png',
                                    //         width: 100,
                                    //       ),
                                    //       SizedBox(
                                    //         width: 5,
                                    //       ),
                                    //       Image.asset(
                                    //         'assets/images/temp/information.png',
                                    //         width: 100,
                                    //       ),
                                    //     ],
                                    //   ),
                                    ),
                                dividerLine(),
                                Container(
                                  // margin: EdgeInsets.only(top: dividerMarginTop),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  color: ColorConstants.WHITE,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Portfolio',
                                        style: Styles.semibold(size: 16),
                                      ),
                                      Spacer(),
                                      InkWell(
                                          onTap: (() {
                                            Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        duration: Duration(
                                                            milliseconds: 600),
                                                        reverseDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    600),
                                                        type: PageTransitionType
                                                            .bottomToTop,
                                                        child: AddPortfolio()))
                                                .then(
                                                    (value) => getPortfolio());
                                          }),
                                          child: Icon(Icons.add)),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            if (portfolioResponse
                                                    ?.data.portfolio.length !=
                                                0)
                                              Navigator.push(
                                                  context,
                                                  NextPageRoute(PortfolioList(
                                                      baseUrl: portfolioResponse
                                                          ?.data.baseFileUrl,
                                                      portfolioList:
                                                          portfolioResponse
                                                              ?.data
                                                              .portfolio)));
                                          },
                                          icon: Icon(
                                              Icons.arrow_forward_ios_rounded)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Divider(),
                                ),
                                isPortfolioLoading == false
                                    ? SizedBox(
                                        height: portfolioResponse
                                                    ?.data.portfolio.length !=
                                                0
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                        child: portfolioResponse
                                                    ?.data.portfolio.length !=
                                                0
                                            ? ListView.builder(
                                                controller:
                                                    new ScrollController(
                                                        keepScrollOffset: true),
                                                itemCount: min(
                                                    4,
                                                    portfolioResponse!
                                                        .data.portfolio.length),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          NextPageRoute(
                                                              PortfolioDetail(
                                                            baseUrl:
                                                                '${portfolioResponse!.data.baseFileUrl}',
                                                            portfolio:
                                                                portfolioResponse!
                                                                        .data
                                                                        .portfolio[
                                                                    index],
                                                          )));
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            child:
                                                                CachedNetworkImage(
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                      downloadProgress) {
                                                                return Shimmer
                                                                    .fromColors(
                                                                  baseColor:
                                                                      Colors.grey[
                                                                          300]!,
                                                                  highlightColor:
                                                                      Colors.grey[
                                                                          100]!,
                                                                  enabled: true,
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.8,
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.3,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                );
                                                              },
                                                              imageUrl:
                                                                  '${portfolioResponse?.data.baseFileUrl}${portfolioResponse?.data.portfolio[index].imageName}',
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.8,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.3,
                                                              fit: BoxFit.cover,
                                                              errorWidget:
                                                                  (context, url,
                                                                      error) {
                                                                return Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.8,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.3,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              14),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          color:
                                                                              Color(0xffD5D5D5)),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(height: 8),
                                                          SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.8,
                                                              child: Text(
                                                                '${portfolioResponse?.data.portfolio[index].portfolioTitle}',
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: Styles.bold(
                                                                    size: 14,
                                                                    color: Color(
                                                                        0xff0E1638)),
                                                              )),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.8,
                                                            child: Text(
                                                                '${portfolioResponse?.data.portfolio[index].desc}',
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: Styles.regular(
                                                                    size: 12,
                                                                    color: Color(
                                                                        0xff929BA3))),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                })
                                            : portfolioListShimmer(0),
                                      )
                                    : portfolioListShimmer(1),
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Divider(),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Divider(),
                                ),
                                isCompetitionLoading == false
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        height: competition?.data.length != 0
                                            ? height(context) * 0.35
                                            : height(context) * 0.15,
                                        child: competition?.data.length != 0
                                            ? ListView.builder(
                                                itemCount:
                                                    competition?.data.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder:
                                                    (context, index) => InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                NextPageRoute(
                                                                    CompetitionDetail(
                                                                  competition:
                                                                      Competition(
                                                                    id: competition
                                                                        ?.data[
                                                                            index]
                                                                        .pId,
                                                                    name: competition
                                                                        ?.data[
                                                                            index]
                                                                        .pName,
                                                                    image: competition
                                                                        ?.data[
                                                                            index]
                                                                        .pImage,
                                                                    gScore: competition
                                                                            ?.data[index]
                                                                            .gScore ??
                                                                        0,
                                                                    description:
                                                                        "",
                                                                  ),
                                                                )));
                                                          },
                                                          child: Container(
                                                            width:
                                                                width(context) *
                                                                    0.85,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 8),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 8),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                border: Border.all(
                                                                    color: ColorConstants
                                                                        .GREY_4)),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              8),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              8)),
                                                                  child: CachedNetworkImage(
                                                                      imageUrl:
                                                                          '${competition?.data[index].pImage}',
                                                                      width: double
                                                                          .infinity,
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.25,
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                                  child:
                                                                      SizedBox(
                                                                    width: width(
                                                                            context) *
                                                                        0.84,
                                                                    child: Text(
                                                                      '${competition?.data[index].pName}',
                                                                      softWrap:
                                                                          true,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: Styles
                                                                          .bold(),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                          'Rank : ${competition?.data[index].rank ?? 0}',
                                                                          style: Styles.semibold(
                                                                              size: 12,
                                                                              color: Color(0xff929BA3))),
                                                                      SizedBox(
                                                                          width:
                                                                              8),
                                                                      Text(
                                                                          ' • ',
                                                                          style: Styles.semibold(
                                                                              size: 12,
                                                                              color: Color(0xff929BA3))),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          print(
                                                                              'nice ${Preference.getString(Preference.FIRST_NAME)}');
                                                                        },
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          'assets/images/coin.svg',
                                                                          width:
                                                                              width(context) * 0.02,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                          '${competition?.data[index].gScore ?? 0} Points Earned',
                                                                          style: Styles.semibold(
                                                                              size: 12,
                                                                              color: Color(0xff929BA3))),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ))
                                            : competitionListShimmer(0),
                                      )
                                    : competitionListShimmer(1),
                                SizedBox(
                                  height: 20,
                                ),
                                dividerLine(),
                              ])),
                      topRow('Education', arrowAction: () {
                        if (portfolioResponse?.data.education.length != 0)
                          Navigator.push(
                              context,
                              NextPageRoute(EducationList(
                                baseUrl: portfolioResponse?.data.baseFileUrl,
                                education: portfolioResponse?.data.education
                                    as List<CommonProfession>,
                              )));
                      }, addAction: () async {
                        await Navigator.push(
                                context,
                                PageTransition(
                                    duration: Duration(milliseconds: 600),
                                    reverseDuration:
                                        Duration(milliseconds: 600),
                                    type: PageTransitionType.bottomToTop,
                                    child: AddEducation()))
                            .then((value) => getPortfolio());
                      }),

                      /// education list
                      isPortfolioLoading == false
                          ? Container(
                              color: ColorConstants.WHITE,
                              child: portfolioResponse?.data.education.length !=
                                      0
                                  ? Transform.translate(
                                      offset: Offset(0, -20),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: ScrollPhysics(),
                                          itemCount: portfolioResponse
                                              ?.data.education.length,
                                          itemBuilder: (context, index) {
                                            DateTime endDate = DateTime.now();

                                            if (portfolioResponse
                                                        ?.data
                                                        .education[index]
                                                        .endDate !=
                                                    null ||
                                                portfolioResponse
                                                        ?.data
                                                        .education[index]
                                                        .endDate !=
                                                    '') {
                                              String endDateString =
                                                  "${portfolioResponse?.data.education[index].endDate}";
                                              endDate = DateFormat("yyyy-mm-dd")
                                                  .parse(endDateString);
                                            }
                                            String startDateString =
                                                "${portfolioResponse?.data.education[index].startDate}";

                                            DateTime startDate =
                                                DateFormat("yyyy-MM-dd")
                                                    .parse(startDateString);

                                            return Container(
                                              width: width(context) * 0.3,
                                              color: ColorConstants.WHITE,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (index != 0)
                                                    SizedBox(
                                                      height: 18,
                                                    ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                '${portfolioResponse?.data.baseFileUrl}${portfolioResponse?.data.education[index].imageName}',
                                                            height:
                                                                width(context) *
                                                                    0.2,
                                                            width:
                                                                width(context) *
                                                                    0.2,
                                                            fit: BoxFit.cover,
                                                            errorWidget:
                                                                (context, url,
                                                                    error) {
                                                              return Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            14),
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        0xffD5D5D5)),
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/images/default_education.svg',
                                                                  height: 40,
                                                                  width: 40,
                                                                  color:
                                                                      ColorConstants
                                                                          .GREY_5,
                                                                  allowDrawingOutsideViewBox:
                                                                      true,
                                                                ),
                                                              );
                                                            },
                                                            placeholder:
                                                                (BuildContext
                                                                        context,
                                                                    loadingProgress) {
                                                              return Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            14),
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        0xffD5D5D5)),
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/images/default_education.svg',
                                                                  height: 40,
                                                                  width: 40,
                                                                  color:
                                                                      ColorConstants
                                                                          .GREY_5,
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                width(context) *
                                                                    0.71,
                                                            child: Text(
                                                              '${portfolioResponse?.data.education[index].title}',
                                                              maxLines: 2,
                                                              style:
                                                                  Styles.bold(
                                                                      size: 14),
                                                            ),
                                                          ),
                                                          SizedBox(height: 4),
                                                          SizedBox(
                                                            width:
                                                                width(context) *
                                                                    0.71,
                                                            child: Text(
                                                              maxLines: 2,
                                                              '${portfolioResponse?.data.education[index].institute}',
                                                              style: Styles
                                                                  .regular(
                                                                      size: 14),
                                                            ),
                                                          ),
                                                          SizedBox(height: 4),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '${listOfMonths[startDate.month - 1].substring(0, 3)} ${startDate.day} - ',
                                                                style: Styles
                                                                    .regular(
                                                                        size:
                                                                            14),
                                                              ),
                                                              if (portfolioResponse
                                                                          ?.data
                                                                          .education[
                                                                              index]
                                                                          .endDate !=
                                                                      null ||
                                                                  portfolioResponse
                                                                          ?.data
                                                                          .education[
                                                                              index]
                                                                          .endDate !=
                                                                      '')
                                                                Text(
                                                                  '${listOfMonths[endDate.month].substring(0, 3)} ${endDate.day}',
                                                                  style: Styles
                                                                      .regular(
                                                                          size:
                                                                              14),
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
                                                  SizedBox(
                                                    child: ReadMoreText(
                                                      viewMore: 'View more',
                                                      text:
                                                          '${portfolioResponse?.data.education[index].description}',
                                                      color: Color(0xff929BA3),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 22,
                                                  ),
                                                  if (index + 1 !=
                                                      portfolioResponse?.data
                                                          .education.length)
                                                    Divider(),
                                                ],
                                              ),
                                            );
                                          }),
                                    )
                                  : educationListShimmer(0),
                            )
                          : educationListShimmer(1),

                      //if (isPortfolioLoading == false) ...[

                      /*if (isPortfolioLoading == false) ...[
                            getCertificateWidget(portfolioResponse?.data.certificate, context),
                          dividerLine(),
                          ] else ...[
                            certificatesListShimmer(1),
                          ],
                          if (isPortfolioLoading == false) ...[
                            getExperience(portfolioResponse?.data.experience, context),
                            dividerLine(),
                          ] else ...[
                            experienceListShimmer(1),
                          ],

                          if (isPortfolioLoading == false) ...[
                            getRecentActivites(),
                            dividerLine(),
                          ] else ...[
                            recentActivitiesListShimmer(1),
                          ],

                          if (isPortfolioLoading == false) ...[
                            dividerLine(),
                            getExtraActivitesWidget(portfolioResponse?.data.extraActivities, context),
                          ] else ...[
                            extraActivitiesListShimmer(1),
                          ],*/

                      dividerLine(),
                      getCertificateWidget(
                          portfolioResponse?.data.certificate, context),
                      dividerLine(),
                      getExperience(
                          portfolioResponse?.data.experience, context),
                      dividerLine(),
                      getRecentActivites(),
                      dividerLine(),
                      getExtraActivitesWidget(
                          portfolioResponse?.data.extraActivities, context),
                    ],
                    //]
                  )))),
    );
  }

  //portfolioResponse?.data.education.length == 0

  Widget getRecentActivites() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          topRow('Recent Activites', addAction: () {}, arrowAction: () {
            Navigator.push(context,
                NextPageRoute(RecentActivitiesPage(), isMaintainState: false));
          }, showAddButton: false),
          isPortfolioLoading == false
              ? SizedBox(
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
                )
              : recentActivitiesListShimmer(1),
        ],
      ),
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
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          topRow('Certificates', arrowAction: () {
            if (certificateList?.length != 0)
              Navigator.push(
                  context,
                  NextPageRoute(CertificateList(
                      baseUrl: '${portfolioResponse?.data.baseFileUrl}',
                      certificates: certificateList)));
          }, addAction: () async {
            await Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 600),
                        reverseDuration: Duration(milliseconds: 600),
                        type: PageTransitionType.bottomToTop,
                        child: AddCertificate()))
                .then((value) => getPortfolio());
          }),
          isPortfolioLoading == false
              ? Container(
                  padding: EdgeInsets.all(8),
                  height: certificateList?.length != 0
                      ? height(context) * 0.38
                      : height(context) * 0.15,
                  child: certificateList?.length != 0
                      ? ListView.builder(
                          itemCount: certificateList?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            String startDateString =
                                "${portfolioResponse?.data.certificate[index].startDate}";

                            DateTime startDate =
                                DateFormat("yyy-MM-dd").parse(startDateString);
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
                                      errorWidget: (context, url, data) =>
                                          Image.asset(
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
                                    '${listOfMonths[startDate.month - 1]} ${startDate.day}',
                                    // '${certificateList?[index].startDate ?? 'Sep 21'}',
                                    style: Styles.regular(),
                                  ),
                                ],
                              ),
                            );
                          })
                      : certificatesListShimmer(0),
                )
              : certificatesListShimmer(1)
        ],
      ),
    );
  }

  Widget getExperience(List<CommonProfession>? experience, context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          topRow('Experience', arrowAction: () {
            if (experience?.length != 0)
              Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 600),
                          reverseDuration: Duration(milliseconds: 600),
                          type: PageTransitionType.bottomToTop,
                          child: ExperienceList(
                              baseUrl: portfolioResponse?.data.baseFileUrl,
                              experience: experience)))
                  .then((value) => getPortfolio());
          }, addAction: () {
            Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 600),
                        reverseDuration: Duration(milliseconds: 600),
                        type: PageTransitionType.bottomToTop,
                        child: AddExperience()))
                .then((value) => getPortfolio());
          }),
          isPortfolioLoading == false
              ? Container(
                  padding: EdgeInsets.all(8),
                  child: experience?.length != 0
                      ? ListView.builder(
                          itemCount: experience?.length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            String startDateString =
                                "${experience?[index].startDate}";
                            print('startDateString ====${startDateString}');
                            //String endDateString = "${experience?[index].endDate}";
                            DateTime startDate =
                                DateFormat("yyyy-MM-dd").parse(startDateString);

                            DateTime endDate = DateTime.now();
                            if (experience?[index].endDate != '') {
                              String endDateString =
                                  "${experience?[index].endDate}";
                              endDate =
                                  DateFormat("yyyy-MM-dd").parse(endDateString);
                            }

                            return Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width(context) * 0.3,
                                        height: height(context) * 0.1,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '${portfolioResponse?.data.baseFileUrl}${experience?[index].imageName}',
                                          errorWidget: (context, url, data) =>
                                              Image.asset(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              '${experience?[index].employmentType} • ${calculateTimeDifferenceBetween(startDate, endDate)} • ${startDate.day} ${listOfMonths[startDate.month - 1].substring(0, 3)} - ${endDate.day} ${listOfMonths[endDate.month - 1].substring(0, 3)}',
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Divider(),
                                  )
                                ],
                              ),
                            );
                          })
                      : experienceListShimmer(0),
                )
              : experienceListShimmer(1)
        ],
      ),
    );
  }

  Widget getExtraActivitesWidget(
      List<CommonProfession>? extraActivities, context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          topRow('Extra Curricular Activities', arrowAction: () {
            if (extraActivities?.length != 0)
              Navigator.push(
                  context,
                  NextPageRoute(ExtraActivitiesList(
                    baseUrl: '${portfolioResponse?.data.baseFileUrl}',
                    activities: extraActivities!,
                  )));
          }, addAction: () {
            Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 600),
                        reverseDuration: Duration(milliseconds: 600),
                        type: PageTransitionType.bottomToTop,
                        child: AddActivities()))
                .then((value) => getPortfolio());
          }),
          isPortfolioLoading == false
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: extraActivities?.length != 0
                      ? Transform.translate(
                          offset: Offset(0, -20),
                          child: ListView.builder(
                              itemCount: min(2, extraActivities!.length),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                String startDateString =
                                    "${extraActivities[index].startDate}";

                                DateTime startDate = DateFormat("yyy-MM-dd")
                                    .parse(startDateString);

                                return Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: width(context) * 0.2,
                                            height: width(context) * 0.2,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${portfolioResponse?.data.baseFileUrl}${extraActivities[index].imageName}",
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Container(
                                                      width:
                                                          width(context) * 0.2,
                                                      height:
                                                          width(context) * 0.2,
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                          color: ColorConstants
                                                              .DIVIDER,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: SvgPicture.asset(
                                                          'assets/images/extra.svg')),
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          SizedBox(
                                            width: width(context) * 0.7,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${extraActivities[index].title}',
                                                  style: Styles.bold(size: 14),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  '${extraActivities[index].institute}',
                                                  style:
                                                      Styles.regular(size: 14),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        '${extraActivities[index].curricularType} • '),
                                                    Text(
                                                      '  ${startDate.day} ${listOfMonths[startDate.month - 1]} ',
                                                      style: Styles.regular(
                                                          size: 14),
                                                    ),
                                                  ],
                                                )
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
                                        text:
                                            '${extraActivities[index].description}',
                                        color: Color(0xff929BA3),
                                      ),
                                      if (index != extraActivities.length)
                                        Divider()
                                    ],
                                  ),
                                );
                              }),
                        )
                      : extraActivitiesListShimmer(0),
                )
              : extraActivitiesListShimmer(1)
        ],
      ),
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
          Log.v("PortfolioState Loading...................");
          isPortfolioLoading = true;
          break;
        case ApiStatus.SUCCESS:
          portfolioResponse = portfolioState.response;

          if (portfolioState.response?.data.name
                  .contains('${Preference.getString(Preference.FIRST_NAME)}') ==
              true) {
            Preference.setString(
                Preference.FIRST_NAME, '${portfolioState.response?.data.name}');
          } else if (portfolioState.response?.data.image.contains(
                  '${Preference.getString(Preference.PROFILE_IMAGE)}') ==
              true) {
            Preference.setString(Preference.PROFILE_IMAGE,
                '${portfolioState.response?.data.image}');
          }

          Preference.setString(Preference.PROFILE_VIDEO,
              '${portfolioState.response?.data.profileVideo}');

          if (portfolioState.response?.data.portfolioProfile.isNotEmpty ==
              true) {
            Preference.setString(Preference.ABOUT_ME,
                '${portfolioState.response?.data.portfolioProfile.first.aboutMe}');

            Preference.setString(Preference.USER_HEADLINE,
                '${portfolioState.response?.data.portfolioProfile.first.headline}');
            Preference.setString(Preference.LOCATION,
                '${portfolioState.response?.data.portfolioProfile.first.city}, ${portfolioState.response?.data.portfolioProfile.first.country}');
          }
          isPortfolioLoading = false;
          Log.v("PortfolioState Success....................");
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

  void handletopScoring(TopScoringUserState state) {
    var portfolioState = state;
    setState(() async {
      switch (portfolioState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Portfolio Competition Loading....................");
          isPortfolioLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("PortfolioState Competition Success....................");

          userRank = portfolioState.response;
          Preference.setString(
              Preference.FIRST_NAME, '${userRank?.data.first.name}');
          Preference.setString(
              Preference.PROFILE_IMAGE, '${userRank?.data.first.profileImage}');

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

  void handleCompetition(PortfoilioCompetitionState state) {
    var portfolioState = state;
    setState(() async {
      switch (portfolioState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Portfolio Competition Loading....................");
          isCompetitionLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("PortfolioState Competition Success....................");
          competition = portfolioState.response;

          isCompetitionLoading = false;
          setState(() {});
          break;

        case ApiStatus.ERROR:
          isCompetitionLoading = false;
          Log.v("PortfolioState Error..........................");
          Log.v(
              "PortfolioState Error..........................${portfolioState.error}");

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  Widget topRow(String title,
      {required Function addAction,
      required Function arrowAction,
      bool showAddButton = true}) {
    return Container(
      color: ColorConstants.WHITE,
      child: Padding(
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
                  style: Styles.bold(size: 14),
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

//TODO: Blank states and empty states Widget
  Widget portfolioListShimmer(var listLength) {
    return listLength == 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 13,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        : InkWell(
            onTap: () {
              print('portfolio List');
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/portfolio_emp_bg.png',
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/portfolio_emp.png',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                        ),
                        child: Text('Add your portfolio, projects here'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  Widget competitionListShimmer(int listLength) {
    return listLength == 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 13,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                    child: Container(
                      width: 130,
                      height: 13,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      enabled: true,
                      child: Container(
                        width: 100,
                        height: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/comp_emp.png'),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Participate in Competitions'),
                ),
                //Text('Competitions'),
              ],
            ),
          );
  }

  Widget educationListShimmer(var listLength) {
    return listLength == 1
        ? Container(
            //width: width(context) * 0.3,
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
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      enabled: true,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: width(context) * 0.5,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: true,
                            child: Container(
                              width: 100,
                              height: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: width(context) * 0.4,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: true,
                            child: Container(
                              width: 80,
                              height: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              enabled: true,
                              child: Container(
                                width: 40,
                                height: 13,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                enabled: true,
                                child: Container(
                                  width: 100,
                                  height: 13,
                                  color: Colors.grey,
                                ),
                              ),
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
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  enabled: true,
                  child: Container(
                    width: width(context) * 0.9,
                    height: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2 - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      print('Add your Education');
                    },
                    child: Image.asset('assets/images/edu_empty.png')),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Add your Education'),
                ),
                //Text('Competitions'),
              ],
            ),
          );
  }

  ///add new
  Widget certificatesListShimmer(int listLength) {
    return listLength == 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 13,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                    child: Container(
                      width: 130,
                      height: 13,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      enabled: true,
                      child: Container(
                        width: 100,
                        height: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        : Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.2 - 20,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/certi_emp.png'),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Add your Certificate'),
                ),
                //Text('Competitions'),
              ],
            ),
          );
  }

  Widget experienceListShimmer(var listLength) {
    return listLength == 1
        ? Container(
            //width: width(context) * 0.3,
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
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      enabled: true,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: width(context) * 0.5,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: true,
                            child: Container(
                              width: 100,
                              height: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: width(context) * 0.4,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: true,
                            child: Container(
                              width: 80,
                              height: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              enabled: true,
                              child: Container(
                                width: 40,
                                height: 13,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                enabled: true,
                                child: Container(
                                  width: 100,
                                  height: 13,
                                  color: Colors.grey,
                                ),
                              ),
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
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  enabled: true,
                  child: Container(
                    width: width(context) * 0.9,
                    height: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2 - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      print('Add your Education');
                    },
                    child: Image.asset('assets/images/exp_emp.png')),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Add your Work Experience'),
                ),
                //Text('Competitions'),
              ],
            ),
          );
  }

  Widget recentActivitiesListShimmer(var listLength) {
    return listLength == 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 0.2,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 13,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        : InkWell(
            onTap: () {
              print('portfolio List');
            },
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/recentactiv_bg.png',
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/recentactiv_emp.png',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                        ),
                        child: Text(
                            'You have not done any community activity yet, Explore Community'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  Widget extraActivitiesListShimmer(var listLength) {
    return listLength == 1
        ? Container(
            //width: width(context) * 0.3,
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
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      enabled: true,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: width(context) * 0.5,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: true,
                            child: Container(
                              width: 100,
                              height: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: width(context) * 0.4,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: true,
                            child: Container(
                              width: 80,
                              height: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              enabled: true,
                              child: Container(
                                width: 40,
                                height: 13,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                enabled: true,
                                child: Container(
                                  width: 100,
                                  height: 13,
                                  color: Colors.grey,
                                ),
                              ),
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
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  enabled: true,
                  child: Container(
                    width: width(context) * 0.9,
                    height: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2 - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      print('Add your Education');
                    },
                    child: Image.asset('assets/images/extraacti_emp.png')),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Add extra curricular activities'),
                ),
                //Text('Competitions'),
              ],
            ),
          );
  }

  void _initFilePiker() async {
    FilePickerResult? result;
    if (await Permission.storage.request().isGranted) {
      if (Platform.isIOS) {
        result = await FilePicker.platform.pickFiles(
            allowMultiple: false, type: FileType.video, allowedExtensions: []);
      } else {
        result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.video,
          //allowedExtensions: ['mp4']
        );
      }

      if (result != null) {
        if (File(result.paths[0]!).lengthSync() / 1000000 > 50.0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${Strings.of(context)?.imageVideoSizeLarge} 50MB'),
          ));
        } else {
          pickedList.add(File(result.paths[0]!));
        }
        pickedFile = pickedList.first;
        print('pickedFile ==== ${pickedFile}');

        if (result.paths.toString().contains('mp4')) {
          final thumbnail = await VideoThumbnail.thumbnailFile(
              video: result.paths[0].toString(),
              thumbnailPath: _tempDir,
              imageFormat: _format,
              quality: _quality);
          setState(() {
            final file = File(thumbnail!);
            filePath = file.path;
          });
        }
      }
    }
  }
}
