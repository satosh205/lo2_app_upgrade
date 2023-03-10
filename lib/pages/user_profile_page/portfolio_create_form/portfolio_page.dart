import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/competition_response.dart';
import 'package:masterg/data/models/response/home_response/new_portfolio_response.dart';
import 'package:masterg/data/models/response/home_response/portfolio_competition_response.dart';
import 'package:masterg/data/models/response/home_response/top_score.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/ghome/widget/read_more.dart';
import 'package:masterg/pages/singularis/competition/competition_detail.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_certificate.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_education.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_experience.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_extra_act.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_portfolio.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/certificate_list.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/competition_list.dart';
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
import 'package:masterg/utils/video_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../utils/dynamic_links/page/courses_page.dart';
import '../../../utils/dynamic_links/path_constant.dart';
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
  // bool? isPortfolioLoading = false;
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

  ///Dynamic Lick Code Start-----
  String? _linkMessage;
  bool _isCreatingLink = false;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  ///Dynamic Code end-------

  @override
  void initState() {
    getPortfolio();
    getPortfolioCompetition();
    topScoringUser();

    ///Dynamic Link
    //initDynamicLinks();
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
    "January",
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

  // void _showPopupMenu(Offset offset) async {
  //   final screenSize = MediaQuery.of(context).size;
  //   double left = offset.dx;
  //   double top = offset.dy;
  //   double right = screenSize.width - offset.dx;
  //   double bottom = screenSize.height - offset.dy;
  //   await showMenu(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(
  //         Radius.circular(20.0),
  //       ),
  //     ),
  //     context: context,
  //     position: RelativeRect.fromLTRB(left, top, right, bottom),
  //     items: [
  //       if (portfolioResponse?.data.portfolioSocial.first.linkedin != "") ...[
  //         PopupMenuItem<String>(
  //           onTap: () {
  //             WidgetsBinding.instance.addPostFrameCallback((_) {

  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) {
  //                     return CommonWebView(
  //                       url: portfolioResponse
  //                           ?.data.portfolioSocial.first.linkedin,
  //                     );
  //                   },
  //                 ),
  //               );
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               Image.asset('assets/images/linkedin.png'),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 10.0),
  //                 child: const Text(
  //                   'Linkedin',
  //                 ),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //       if (portfolioResponse?.data.portfolioSocial.first.facebook != "") ...[
  //         PopupMenuItem<String>(
  //           onTap: () {
  //             WidgetsBinding.instance.addPostFrameCallback((_) {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) {
  //                     return CommonWebView(
  //                       url: portfolioResponse
  //                           ?.data.portfolioSocial.first.facebook,
  //                     );
  //                   },
  //                 ),
  //               );
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               Image.asset('assets/images/facebook_p.png'),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 10.0),
  //                 child: const Text('Facebook'),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //       if (portfolioResponse?.data.portfolioSocial.first.bee != "") ...[
  //         PopupMenuItem<String>(
  //           onTap: () {
  //             WidgetsBinding.instance.addPostFrameCallback((_) {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) {
  //                     return CommonWebView(
  //                       url: portfolioResponse?.data.portfolioSocial.first.bee,
  //                     );
  //                   },
  //                 ),
  //               );
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               Image.asset('assets/images/behance_p.png'),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 10.0),
  //                 child: const Text('Bee'),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //       if (portfolioResponse?.data.portfolioSocial.first.dribble != "") ...[
  //         PopupMenuItem<String>(
  //           onTap: () {
  //             WidgetsBinding.instance.addPostFrameCallback((_) {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) {
  //                     return CommonWebView(
  //                       url: portfolioResponse
  //                           ?.data.portfolioSocial.first.dribble,
  //                     );
  //                   },
  //                 ),
  //               );
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               Image.asset('assets/images/linkedin.png'),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 10.0),
  //                 child: const Text('Dribble'),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //       if (portfolioResponse?.data.portfolioSocial.first.insta != "") ...[
  //         PopupMenuItem<String>(
  //           onTap: () {
  //             WidgetsBinding.instance.addPostFrameCallback((_) {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) {
  //                     return CommonWebView(
  //                       url:
  //                           portfolioResponse?.data.portfolioSocial.first.insta,
  //                     );
  //                   },
  //                 ),
  //               );
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               Image.asset('assets/images/instagram_p.png'),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 10.0),
  //                 child: const Text('Instagram'),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //       if (portfolioResponse?.data.portfolioSocial.first.twitter != "") ...[
  //         PopupMenuItem<String>(
  //           onTap: () {
  //             WidgetsBinding.instance.addPostFrameCallback((_) {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) {
  //                     return CommonWebView(
  //                       url: portfolioResponse
  //                           ?.data.portfolioSocial.first.twitter,
  //                     );
  //                   },
  //                 ),
  //               );
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               Image.asset('assets/images/twitter_p.png'),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 10.0),
  //                 child: const Text('Twitter'),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //       if (portfolioResponse?.data.portfolioSocial.first.pinterest != "") ...[
  //         PopupMenuItem<String>(
  //           onTap: () {
  //             WidgetsBinding.instance.addPostFrameCallback((_) {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) {
  //                     return CommonWebView(
  //                       url: portfolioResponse
  //                           ?.data.portfolioSocial.first.pinterest,
  //                     );
  //                   },
  //                 ),
  //               );
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               Image.asset('assets/images/pinterest_p.png'),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 10.0),
  //                 child: const Text('Pinterest'),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //       if (portfolioResponse?.data.portfolioSocial.first.siteUrl != "") ...[
  //         PopupMenuItem<String>(
  //           onTap: () {
  //             WidgetsBinding.instance.addPostFrameCallback((_) {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) {
  //                     return CommonWebView(
  //                       url: portfolioResponse
  //                           ?.data.portfolioSocial.first.siteUrl,
  //                     );
  //                   },
  //                 ),
  //               );
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               Image.asset('assets/images/globe_p.png'),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 10.0),
  //                 child: const Text('Site Url'),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //     ],
  //     elevation: 10.0,
  //   );
  // }

  //TODO: Dynamic Link Code Start
  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;

      if (queryParams.isNotEmpty) {
        String? productId = queryParams["id"];
        Navigator.pushNamed(context, dynamicLinkData.link.path,
            arguments: {"productId": int.parse(productId!)});
      } else {
        Navigator.pushNamed(
          context,
          dynamicLinkData.link.path,
        );
      }
    }).onError((error) {
      print(error.message);
    });
  }

  Future<void> _createDynamicLink(bool short, String link) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: kUriPrefix,
      link: Uri.parse(kUriPrefix + link),
      androidParameters: const AndroidParameters(
        packageName: 'com.singulariswow',
        minimumVersion: 0,
      ),
    );

    Uri url;
    if (short) {
      print('short======');
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
      print(url.toString());
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
      print('_linkMessage====${_linkMessage}');
    });
  }
  //TODO: Dynamic Link Code End---------

  @override
  Widget build(BuildContext context) {
    //String? baseUrl = portfolioResponse?.data.baseFileUrl;
    String? baseUrl = 'https://singularis.learningoxygen.com/portfolio/';
    // return Scaffold(body: Text('hello'));

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
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    flexibleSpace: Container(
                      decoration: const BoxDecoration(
                        color: ColorConstants.WHITE,
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              ColorConstants.GRADIENT_ORANGE,
                              ColorConstants.GRADIENT_RED
                            ]),
                      ),
                    )),
              ),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.27,
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
                                      height: 5,
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
                                              String shareUrl =
                                                  '${baseUrl.split('/portfolio').first}/' +
                                                      'portfolio-detail?user_id=${Preference.getInt(Preference.USER_ID)}';
                                              print(shareUrl);
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

                                              _createDynamicLink(
                                                  true, kNewCoursesPageLink);
                                              //_createDynamicLink(false, kNewCoursesPageLink);
                                              //kNewCoursesPageLink

                                              /* Navigator.push(
                                                  context,
                                                  NextPageRoute(CoursesPage()));*/
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
                                                                      Navigator.pop(
                                                                          context);
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
                                                                      Navigator.pop(
                                                                          context);
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

                                                  //singh11
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
                                                          : "Add a headline",
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
                                                      SvgPicture.asset(
                                                          'assets/images/person_location.svg'),
                                                      SizedBox(
                                                        width: width(context) *
                                                            0.6,
                                                        child: Text(
                                                            '${Preference.getString(Preference.LOCATION) ?? 'Add your location'}',
                                                            maxLines: 1,
                                                            // overflow: TextOverflow.ellipsis,
                                                            style: Styles.regular(
                                                                size: 12,
                                                                color:
                                                                    ColorConstants
                                                                        .WHITE)),
                                                      ),
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
                              Container(
                                color: ColorConstants.WHITE,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 20),
                                  child: Text(
                                    '${Preference.getString(Preference.ABOUT_ME) ?? 'Tell something about yourself to everyone...'}',
                                    textAlign: TextAlign.center,
                                    style: Styles.regular(
                                        size: 12, color: Color(0xff5A5F73)),
                                  ),
                                ),
                              ),
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
                                        Preference.getString(Preference.PHONE) != '0' ? InkWell(
                                          onTap: () async {
                                            await launch(
                                                "tel:${Preference.getString(Preference.PHONE)}");
                                          },
                                          child: SvgPicture.asset(
                                              'assets/images/call.svg'),
                                        ) : Icon(Icons.call, color: ColorConstants.GREY_6,),
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
                                        portfolioResponse?.data
                                                        .portfolioSocial ==
                                                    null ||
                                                portfolioResponse
                                                        ?.data
                                                        .portfolioSocial
                                                        .length ==
                                                    0
                                            ? Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/images/linkedin_un.svg'),
                                                  SizedBox(width: 14),
                                                  /*SvgPicture.asset(
                                                      'assets/images/facebook_un.svg'),
                                                  SizedBox(width: 14),*/
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
                                            : ShowSocailLinks(
                                                portfolioSocial:
                                                    portfolioResponse?.data
                                                        .portfolioSocial.first,
                                              ),

                                        //show here social widget

                                        // Row(
                                        //     children: [
                                        //       Row(
                                        //         children: [
                                        //           portfolioResponse
                                        //                       ?.data
                                        //                       .portfolioSocial
                                        //                       .first
                                        //                       .linkedin !=
                                        //                   ""
                                        //               ? InkWell(
                                        //                   onTap: () async {
                                        //                     Navigator.push(
                                        //                         context,
                                        //                         NextPageRoute(
                                        //                             CommonWebView(
                                        //                           url: portfolioResponse
                                        //                               ?.data
                                        //                               .portfolioSocial
                                        //                               .first
                                        //                               .linkedin,
                                        //                         ))).then((isSuccess) {
                                        //                       if (isSuccess ==
                                        //                           true) {
                                        //                         Navigator.pop(
                                        //                             context,
                                        //                             true);
                                        //                       }
                                        //                     });
                                        //                   },
                                        //                   child: Padding(
                                        //                     padding:
                                        //                         const EdgeInsets
                                        //                                 .only(
                                        //                             right:
                                        //                                 14.0),
                                        //                     child: SvgPicture
                                        //                         .asset(
                                        //                             'assets/images/linkedin.svg'),
                                        //                   ),
                                        //                 )
                                        //               : SizedBox(),

                                        //           portfolioResponse
                                        //                       ?.data
                                        //                       .portfolioSocial
                                        //                       .first
                                        //                       .insta !=
                                        //                   ""
                                        //               ? InkWell(
                                        //                   onTap: () {
                                        //                     Navigator.push(
                                        //                         context,
                                        //                         NextPageRoute(
                                        //                             CommonWebView(
                                        //                           url: portfolioResponse
                                        //                               ?.data
                                        //                               .portfolioSocial
                                        //                               .first
                                        //                               .insta,
                                        //                         ))).then((isSuccess) {
                                        //                       if (isSuccess ==
                                        //                           true) {
                                        //                         Navigator.pop(
                                        //                             context,
                                        //                             true);
                                        //                       }
                                        //                     });
                                        //                   },
                                        //                   child: Padding(
                                        //                     padding:
                                        //                         const EdgeInsets
                                        //                                 .only(
                                        //                             right:
                                        //                                 14.0),
                                        //                     child: SvgPicture
                                        //                         .asset(
                                        //                             'assets/images/insta.svg'),
                                        //                   ),
                                        //                 )
                                        //               : SizedBox(),

                                        //           portfolioResponse
                                        //                       ?.data
                                        //                       .portfolioSocial
                                        //                       .first
                                        //                       .twitter !=
                                        //                   ""
                                        //               ? InkWell(
                                        //                   onTap: () {
                                        //                     Navigator.push(
                                        //                         context,
                                        //                         NextPageRoute(
                                        //                             CommonWebView(
                                        //                           url: portfolioResponse
                                        //                               ?.data
                                        //                               .portfolioSocial
                                        //                               .first
                                        //                               .twitter,
                                        //                         ))).then((isSuccess) {
                                        //                       if (isSuccess ==
                                        //                           true) {
                                        //                         Navigator.pop(
                                        //                             context,
                                        //                             true);
                                        //                       }
                                        //                     });
                                        //                   },
                                        //                   child: Padding(
                                        //                     padding:
                                        //                         const EdgeInsets
                                        //                                 .only(
                                        //                             right:
                                        //                                 0.0),
                                        //                     child: SvgPicture
                                        //                         .asset(
                                        //                             'assets/images/twitter.svg'),
                                        //                   ),
                                        //                 )
                                        //               : SizedBox(),

                                        //           portfolioResponse
                                        //                       ?.data
                                        //                       .portfolioSocial
                                        //                       .first
                                        //                       .bee !=
                                        //                   ""
                                        //               ? InkWell(
                                        //                   onTap: () {
                                        //                     Navigator.push(
                                        //                         context,
                                        //                         NextPageRoute(
                                        //                             CommonWebView(
                                        //                           url: portfolioResponse
                                        //                               ?.data
                                        //                               .portfolioSocial
                                        //                               .first
                                        //                               .dribble,
                                        //                         ))).then((isSuccess) {
                                        //                       if (isSuccess ==
                                        //                           true) {
                                        //                         Navigator.pop(
                                        //                             context,
                                        //                             true);
                                        //                       }
                                        //                     });
                                        //                   },
                                        //                   child: Padding(
                                        //                     padding:
                                        //                         const EdgeInsets
                                        //                                 .only(
                                        //                             right:
                                        //                                 14.0),
                                        //                     child: SvgPicture
                                        //                         .asset(
                                        //                             'assets/images/behance.svg'),
                                        //                   ),
                                        //                 )
                                        //               : SizedBox(),
                                        //           //SizedBox(width: 14),
                                        //         ],
                                        //       ),
                                        //       Row(
                                        //         children: [
                                        //           portfolioResponse
                                        //                       ?.data
                                        //                       .portfolioSocial
                                        //                       .first
                                        //                       .linkedin ==
                                        //                   ""
                                        //               ? Padding(
                                        //                   padding:
                                        //                       const EdgeInsets
                                        //                               .only(
                                        //                           right:
                                        //                               14.0),
                                        //                   child: SvgPicture
                                        //                       .asset(
                                        //                           'assets/images/linkedin_un.svg'),
                                        //                 )
                                        //               : SizedBox(),
                                        //           //SizedBox(width: 14),

                                        //           portfolioResponse
                                        //                       ?.data
                                        //                       .portfolioSocial
                                        //                       .first
                                        //                       .insta ==
                                        //                   ""
                                        //               ? Padding(
                                        //                   padding:
                                        //                       const EdgeInsets
                                        //                               .only(
                                        //                           right:
                                        //                               14.0),
                                        //                   child: SvgPicture
                                        //                       .asset(
                                        //                           'assets/images/insta_un.svg'),
                                        //                 )
                                        //               : SizedBox(),

                                        //           //SizedBox(width: 14),

                                        //           portfolioResponse
                                        //                       ?.data
                                        //                       .portfolioSocial
                                        //                       .first
                                        //                       .twitter ==
                                        //                   ""
                                        //               ? Padding(
                                        //                   padding:
                                        //                       const EdgeInsets
                                        //                               .only(
                                        //                           right:
                                        //                               14.0),
                                        //                   child: SvgPicture
                                        //                       .asset(
                                        //                           'assets/images/twitter_un.svg'),
                                        //                 )
                                        //               : SizedBox(),
                                        //           //SizedBox(width: 14),

                                        //           portfolioResponse
                                        //                       ?.data
                                        //                       .portfolioSocial
                                        //                       .first
                                        //                       .bee ==
                                        //                   ""
                                        //               ? SvgPicture.asset(
                                        //                   'assets/images/behance_un.svg')
                                        //               : SizedBox(),
                                        //           SizedBox(width: 3),
                                        //         ],
                                        //       ),
                                        //     ],
                                        //   ),

                                        /*SvgPicture.asset(
                                            'assets/images/pintrest.svg'),*/
                                        // portfolioResponse?.data.portfolioSocial
                                        //             .length !=
                                        //         0
                                        //     ? GestureDetector(
                                        //         onTapDown:
                                        //             (TapDownDetails detail) {
                                        //           _showPopupMenu(
                                        //             detail.globalPosition,
                                        //           );
                                        //         },
                                        //         child: SvgPicture.asset(
                                        //             'assets/images/vertical_menu.svg'),
                                        //       )
                                        //     : SizedBox(),
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
                              top: MediaQuery.of(context).size.height * 0.22,
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
                                                  userRank?.data?.length != 0
                                                      ? '${userRank?.data?.first?.rank ?? '00'}'
                                                      : '00',
                                                  style: Styles.bold(size: 26),
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            userRank?.data?.length != 0
                                                ? 'out of ${userRank?.data?.first?.rankOutOf ?? '0'} Students'
                                                : 'compete to gain rank',
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
                                              SizedBox(
                                                width: 4,
                                              ),
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
                                                  userRank?.data?.length != 0
                                                      ? '${userRank?.data?.first?.score ?? '00'}'
                                                      : '00',
                                                  style: Styles.bold(size: 24),
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            userRank?.data?.length != 0
                                                ? 'gained from ${userRank?.data?.first?.rankOutOf ?? '00'} activities'
                                                : 'gained from -- activities',
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
                      Center(
                        child: Container(
                          color: Color(0xffF3F3F3),
                          height: 1.5,
                          width: width(context) * 0.9,
                        ),
                      ),
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

                      //TODO: Skills Level Badges
                      Container(
                          // margin: EdgeInsets.only(top: dividerMarginTop),
                          color: ColorConstants.WHITE,
                          // padding: EdgeInsets.symmetric(
                          //   vertical: 6,
                          // ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.symmetric(horizontal: 8),
                                //   child: Row(
                                //     children: [
                                //       Text(
                                //         'Skills Level & Badges',
                                //         style: Styles.semibold(size: 16),
                                //       ),
                                //       Spacer(),
                                //       Icon(Icons.arrow_forward_ios_rounded)
                                //     ],
                                //   ),
                                // ),
                                // Divider(),
                                // SizedBox(
                                //     height: height(context) * 0.2,
                                //     width: width(context),
                                //     child: Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: Column(
                                //         children: [
                                //           SvgPicture.asset(
                                //             'assets/images/skill_star.svg',
                                //             width: 40,
                                //           ),
                                //           RichText(
                                //             text: new TextSpan(
                                //               text: 'Complete ',
                                //               style: Styles.DMSansregular(),
                                //               children: <TextSpan>[
                                //                 new TextSpan(
                                //                   text: 'Skill Assessments  ',
                                //                   style: TextStyle(
                                //                       fontSize: 16,
                                //                       color: Colors.red),
                                //                 ),
                                //                 new TextSpan(
                                //                   text:
                                //                       'to \n    gain skills and earn badges',
                                //                 ),
                                //               ],
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     )
                                //     //   child: ListView(
                                //     //     scrollDirection: Axis.horizontal,
                                //     //     children: [
                                //     //       Image.asset(
                                //     //         'assets/images/temp/ux_design.png',
                                //     //         width: 100,
                                //     //       ),
                                //     //       SizedBox(
                                //     //         width: 5,
                                //     //       ),
                                //     //       Image.asset(
                                //     //         'assets/images/temp/prototype.png',
                                //     //         width: 100,
                                //     //       ),
                                //     //       SizedBox(
                                //     //         width: 5,
                                //     //       ),
                                //     //       Image.asset(
                                //     //         'assets/images/temp/informational.png',
                                //     //         width: 100,
                                //     //       ),
                                //     //       SizedBox(
                                //     //         width: 5,
                                //     //       ),
                                //     //       Image.asset(
                                //     //         'assets/images/temp/information.png',
                                //     //         width: 100,
                                //     //       ),
                                //     //       SizedBox(
                                //     //         width: 5,
                                //     //       ),
                                //     //       Image.asset(
                                //     //         'assets/images/temp/linux.png',
                                //     //         width: 100,
                                //     //       ),
                                //     //       SizedBox(
                                //     //         width: 5,
                                //     //       ),
                                //     //       Image.asset(
                                //     //         'assets/images/temp/linuxy.png',
                                //     //         width: 100,
                                //     //       ),
                                //     //       SizedBox(
                                //     //         width: 5,
                                //     //       ),
                                //     //       Image.asset(
                                //     //         'assets/images/temp/information.png',
                                //     //         width: 100,
                                //     //       ),
                                //     //     ],
                                //     //   ),
                                //     ),

                                dividerLine(),

                                Container(
                                  // margin: EdgeInsets.only(top: dividerMarginTop),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 10),
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
                                                            milliseconds: 350),
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
                                      if (isPortfolioLoading == false &&
                                          portfolioResponse
                                                  ?.data.portfolio.length !=
                                              0)
                                        IconButton(
                                            onPressed: () {
                                              if (portfolioResponse
                                                      ?.data.portfolio.length !=
                                                  0)
                                                Navigator.push(
                                                    context,
                                                    NextPageRoute(PortfolioList(
                                                        baseUrl:
                                                            portfolioResponse
                                                                ?.data
                                                                .baseFileUrl,
                                                        portfolioList:
                                                            portfolioResponse
                                                                ?.data
                                                                .portfolio)));
                                            },
                                            icon: Icon(Icons
                                                .arrow_forward_ios_rounded)),
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
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: Styles.bold(
                                                                    size: 14,
                                                                    color: Color(
                                                                        0xff0E1638)),
                                                              )),
                                                          SizedBox(height: 4),
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
                                      // Spacer(),
                                      // if (isPortfolioLoading == false &&
                                      //     competition?.data.length != 0)
                                      //   IconButton(
                                      //     onPressed: () {
                                      //       // Navigator.push(
                                      //       //     context,
                                      //       //     MaterialPageRoute(
                                      //       //         builder: (context) =>
                                      //       //             CompetitionListPortfolio(
                                      //       //                 competitionList:
                                      //       //                     competition
                                      //       //                         ?.data)));
                                      //     },
                                      //     icon: Icon(
                                      //         Icons.arrow_forward_ios_outlined),
                                      //   ),
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
                                isPortfolioLoading == false
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        height: competition?.data.length != 0
                                            ? height(context) * 0.28
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
                                                            // try {
                                                            //   Navigator.push(
                                                            //       context,
                                                            //       NextPageRoute(
                                                            //           CompetitionDetail(
                                                            //         competition: Competition(
                                                            //             id: competition
                                                            //                 ?.data[
                                                            //                     index]
                                                            //                 .pId,
                                                            //             name: competition
                                                            //                 ?.data[
                                                            //                     index]
                                                            //                 .pName,
                                                            //             image: competition
                                                            //                 ?.data[
                                                            //                     index]
                                                            //                 .pImage,
                                                            //             gScore: int.parse(
                                                            //                 '${competition?.data[index].gScore ?? '0'}'),
                                                            //             description:
                                                            //                 "",
                                                            //             startDate: competition
                                                            //                 ?.data[index]
                                                            //                 .startDate),
                                                            //       )));
                                                            // } catch (e, stacktrace) {
                                                            //   print(stacktrace);
                                                            // }
                                                          },
                                                          child: Container(
                                                            width:
                                                                width(context) *
                                                                    0.7,
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
                                                                          0.2,
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          SizedBox(),
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
                                                                SizedBox(height: 6,),
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
                                                                          ' ???  ',
                                                                          style: Styles.semibold(
                                                                              size: 12,
                                                                              color: Color(0xff929BA3))),
                                                                      SvgPicture
                                                                          .asset(
                                                                        'assets/images/coin.svg',
                                                                        width: width(context) *
                                                                            0.03,
                                                                      ),
                                                                      Text(
                                                                          '  ${competition?.data[index].gScore ?? 0} Points Earned',
                                                                          style: Styles.semibold(
                                                                              size: 12,
                                                                              color: ColorConstants.ORANGE)),
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
                                // dividerLine(),
                              ])),

                      SizedBox(
                        height: 20,
                      ),
                      topRow('Education',
                          showArrow: portfolioResponse?.data.education.length !=
                              0, arrowAction: () {
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
                                    duration: Duration(milliseconds: 350),
                                    reverseDuration:
                                        Duration(milliseconds: 350),
                                    type: PageTransitionType.bottomToTop,
                                    child: AddEducation()))
                            .then((value) => getPortfolio());
                      }),

                      /// education list
                      isPortfolioLoading == false
                          ? educationList(portfolioResponse?.data.education
                              as List<CommonProfession>)
                          // Container(
                          //     color: ColorConstants.WHITE,
                          //     child: portfolioResponse?.data.education.length !=
                          //             0
                          //         ? ListView.builder(
                          //             shrinkWrap: true,
                          //             physics: ScrollPhysics(),
                          //             itemCount: min(
                          //                 2,
                          //                 portfolioResponse!
                          //                     .data.education.length),
                          //             itemBuilder: (context, index) {
                          //               int len = min(
                          //                   2,
                          //                   portfolioResponse!
                          //                       .data.education.length);
                          //               DateTime endDate = DateTime.now();

                          //               if (portfolioResponse?.data
                          //                           .education[index].endDate !=
                          //                       null ||
                          //                   portfolioResponse?.data
                          //                           .education[index].endDate !=
                          //                       '') {
                          //                 String endDateString =
                          //                     "${portfolioResponse?.data.education[index].endDate}";
                          //                 endDate = DateFormat("yyyy-MM-dd")
                          //                     .parse(endDateString);
                          //               }
                          //               String startDateString =
                          //                   "${portfolioResponse?.data.education[index].startDate}";

                          //               DateTime startDate =
                          //                   DateFormat("yyyy-MM-dd")
                          //                       .parse(startDateString);

                          //               return Container(
                          //                 width: width(context) * 0.3,
                          //                 color: ColorConstants.WHITE,
                          //                 margin: EdgeInsets.symmetric(
                          //                     horizontal: 8, vertical: 0),
                          //                 child: Column(
                          //                   crossAxisAlignment:
                          //                       CrossAxisAlignment.start,
                          //                   children: [
                          //                     if (index != 0)
                          //                       SizedBox(
                          //                         height: 18,
                          //                       ),
                          //                     Row(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.start,
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment.start,
                          //                       children: [
                          //                         ClipRRect(
                          //                             borderRadius:
                          //                                 BorderRadius.circular(
                          //                                     8),
                          //                             child: CachedNetworkImage(
                          //                               imageUrl:
                          //                                   '${portfolioResponse?.data.baseFileUrl}${portfolioResponse?.data.education[index].imageName}',
                          //                               height: width(context) *
                          //                                   0.2,
                          //                               width: width(context) *
                          //                                   0.2,
                          //                               fit: BoxFit.cover,
                          //                               errorWidget: (context,
                          //                                   url, error) {
                          //                                 return Container(
                          //                                   padding:
                          //                                       EdgeInsets.all(
                          //                                           14),
                          //                                   decoration:
                          //                                       BoxDecoration(
                          //                                           color: Color(
                          //                                               0xffD5D5D5)),
                          //                                   child: SvgPicture
                          //                                       .asset(
                          //                                     'assets/images/default_education.svg',
                          //                                     height: 40,
                          //                                     width: 40,
                          //                                     color:
                          //                                         ColorConstants
                          //                                             .GREY_5,
                          //                                     allowDrawingOutsideViewBox:
                          //                                         true,
                          //                                   ),
                          //                                 );
                          //                               },
                          //                               placeholder: (BuildContext
                          //                                       context,
                          //                                   loadingProgress) {
                          //                                 return Container(
                          //                                   padding:
                          //                                       EdgeInsets.all(
                          //                                           14),
                          //                                   decoration:
                          //                                       BoxDecoration(
                          //                                           color: Color(
                          //                                               0xffD5D5D5)),
                          //                                   child: SvgPicture
                          //                                       .asset(
                          //                                     'assets/images/default_education.svg',
                          //                                     height: 40,
                          //                                     width: 40,
                          //                                     color:
                          //                                         ColorConstants
                          //                                             .GREY_5,
                          //                                     allowDrawingOutsideViewBox:
                          //                                         true,
                          //                                   ),
                          //                                 );
                          //                               },
                          //                             )),
                          //                         SizedBox(
                          //                           width: 10,
                          //                         ),
                          //                         Column(
                          //                           crossAxisAlignment:
                          //                               CrossAxisAlignment
                          //                                   .start,
                          //                           mainAxisAlignment:
                          //                               MainAxisAlignment
                          //                                   .spaceEvenly,
                          //                           children: [
                          //                             SizedBox(
                          //                               width: width(context) *
                          //                                   0.71,
                          //                               child: Text(
                          //                                 '${portfolioResponse?.data.education[index].title}',
                          //                                 maxLines: 2,
                          //                                 style: Styles.bold(
                          //                                     size: 14),
                          //                               ),
                          //                             ),
                          //                             SizedBox(height: 4),
                          //                             SizedBox(
                          //                               width: width(context) *
                          //                                   0.71,
                          //                               child: Text(
                          //                                 maxLines: 2,
                          //                                 '${portfolioResponse?.data.education[index].institute}',
                          //                                 style: Styles.regular(
                          //                                     size: 14),
                          //                               ),
                          //                             ),
                          //                             SizedBox(height: 4),
                          //                             Row(
                          //                               children: [
                          //                                 Text(
                          //                                   '${listOfMonths[startDate.month - 1].substring(0, 3)} ${startDate.year.toString().substring(2, 4)} - ',
                          //                                   style:
                          //                                       Styles.regular(
                          //                                           size: 14),
                          //                                 ),
                          //                                 if (portfolioResponse
                          //                                             ?.data
                          //                                             .education[
                          //                                                 index]
                          //                                             .endDate !=
                          //                                         null ||
                          //                                     portfolioResponse
                          //                                             ?.data
                          //                                             .education[
                          //                                                 index]
                          //                                             .endDate !=
                          //                                         '')
                          //                                   Text(
                          //                                     '${listOfMonths[endDate.month - 1].substring(0, 3)} ${endDate.year.toString().substring(2, 4)}',
                          //                                     style: Styles
                          //                                         .regular(
                          //                                             size: 14),
                          //                                   ),
                          //                               ],
                          //                             )
                          //                           ],
                          //                         )
                          //                       ],
                          //                     ),
                          //                     SizedBox(
                          //                       height: 10,
                          //                     ),
                          //                     SizedBox(
                          //                       child: ReadMoreText(
                          //                         viewMore: 'View more',
                          //                         text:
                          //                             '${portfolioResponse?.data.education[index].description}',
                          //                         color: Color(0xff929BA3),
                          //                       ),
                          //                     ),
                          //                     SizedBox(
                          //                       height: 22,
                          //                     ),
                          //                     if (index + 1 != len) Divider(),
                          //                   ],
                          //                 ),
                          //               );
                          //             })
                          //         : educationListShimmer(0),
                          //   )

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
                      getRecentActivites(
                          portfolioResponse?.data.recentActivity, context),
                      dividerLine(),
                      getExtraActivitesWidget(
                          portfolioResponse?.data.extraActivities, context),
                    ],
                    //]
                  )))),
    );
  }

  //portfolioResponse?.data.education.length == 0

  Widget getRecentActivites(List<RecentActivity>? recentActivites, context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          topRow('Recent Activites',
              showArrow: recentActivites?.length != 0,
              addAction: () {}, arrowAction: () {
            if (recentActivites?.length != 0)
              Navigator.push(
                  context,
                  NextPageRoute(RecentActivitiesPage(),
                      isMaintainState: false));
          }, showAddButton: false),
          isPortfolioLoading == false
              ? recentActivites?.length != 0
                  ? SizedBox(
                      height: height(context) * 0.5,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: min(3, recentActivites!.length),
                          itemBuilder: (context, index) {
                            // return Text('${recentActivites[index].createdAt}   ');
                            return postCard(recentActivites[index]);
                          }),
                      // child: ListView(
                      //   shrinkWrap: true,

                      //   scrollDirection: Axis.horizontal,
                      //   children: [
                      //     postCard(
                      //         imageUrl:
                      //             'https://images.unsplash.com/photo-1674708059513-5f77494844db?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1M3x8fGVufDB8fHx8&auto=format&fit=crop&w=900&q=60'),
                      //     postCard(
                      //         imageUrl:
                      //             'https://images.unsplash.com/photo-1661961110372-8a7682543120?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80')
                      //   ],
                      // ),
                    )
                  : recentActivitiesListShimmer(0)
              : recentActivitiesListShimmer(1),
        ],
      ),
    );
  }

  Widget postCard(RecentActivity recentActivites) {
    var now = DateTime.now();
    var past = DateTime.parse("${recentActivites.createdAt}");

    var difference = now.difference(past);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            NextPageRoute(
                RecentActivitiesPage(
                  animateToIndex: recentActivites.reserved != 'reels' ? 1 : 0,
                ),
                isMaintainState: false));
      },
      child: Container(
        width: width(context) * 0.75,
        height: height(context) * 0.35,
        padding: EdgeInsets.symmetric(horizontal: 12),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            border: Border.all(color: ColorConstants.DIVIDER),
            borderRadius: BorderRadius.circular(8),
            color: ColorConstants.WHITE),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recentActivites.reserved != 'reels')
                SizedBox(
                  height: 20,
                ),
              if (recentActivites.reserved != 'reels')
                Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        '${recentActivites.profileImage}',
                        errorBuilder: (context, url, error) {
                          return SvgPicture.asset(
                            'assets/images/default_user.svg',
                            width: width(context) * 0.13,
                            height: width(context) * 0.13,
                            allowDrawingOutsideViewBox: true,
                          );
                        },
                        width: width(context) * 0.13,
                        height: width(context) * 0.13,
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width(context) * 0.5,
                          child: Text(
                            '${recentActivites.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text('${calculateTimeDifferenceBetween(past, now)}')
                        // Text('${difference.inDays}')
                      ],
                    ),
                  ],
                ),
              if (recentActivites.reserved != 'reels')
                SizedBox(
                  height: 6,
                ),
              if (recentActivites.reserved != 'reels')
                ReadMoreText(
                  text: '${recentActivites.description}',
                ),
              if (recentActivites.reserved != 'reels')
                SizedBox(
                  height: 20,
                ),
              recentActivites.reserved != 'reels'
                  ? recentActivites.resourcePath!.contains('png') ||
                          recentActivites.resourcePath!.contains('jpeg') ||
                          recentActivites.resourcePath!.contains('jpg')
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            '${recentActivites.resourcePath}',
                            width: width(context) * 0.65,
                            height: height(context) * 0.3,
                            fit: BoxFit.cover,
                          ))
                      : Container(
                          height: recentActivites.reserved != 'reels'
                              ? height(context) * 0.33
                              : height(context) * 0.43,
                          child: VideoPlayerWidget(
                            videoUrl: '${recentActivites.resourcePath}',
                            // maitanceAspectRatio: true,
                          ),
                        )
                  : SizedBox(
                      height: height(context) * 0.44,
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                '${recentActivites.resourcePathThumbnail}',
                                width: width(context) * 0.65,
                                height: height(context) * 0.44,
                                fit: BoxFit.cover,
                              )),
                          Center(
                            child: SvgPicture.asset(
                              'assets/images/play.svg',
                              height: 40.0,
                              width: 40.0,
                              allowDrawingOutsideViewBox: true,
                            ),
                          ),
                          Positioned(
                              bottom: 10,
                              left: 10,
                              child: Text('${recentActivites.viewCount} views',
                                  style: Styles.regular(
                                      size: 12, color: ColorConstants.WHITE)))
                        ],
                      ),
                    )

              // ClipRect(
              //     child: AspectRatio(
              //       aspectRatio: 4 / 4,
              //       child: FlickVideoPlayer(
              //           // flickVideoWithControls: FlickPortraitControls(),
              //           flickManager: FlickManager(
              //         autoPlay: false,
              //         videoPlayerController: VideoPlayerController.network(
              //           '${recentActivites.resourcePath}',
              //         ),
              //       )),
              //     ),
              //   )

              // CustomVideoPlayer(
              //                                     // sendflickManager:
              //                                     //     (FlickManager value) {},
              //                                     url: recentActivites.resourcePath,
              //                                     isLocalVideo: false,
              //                                     likeCount:0,
              //                                     viewCount: 0,
              //                                     commentCount:
              //                                         0,
              //                                     //height:  videoHeight,
              //                                     height: min(
              //                                         height(context) * 0.3,
              //                                         MediaQuery.of(context)
              //                                                 .size
              //                                                 .height -
              //                                             MediaQuery.of(context)
              //                                                     .size
              //                                                     .height *
              //                                                 0.25),
              //                                     index: 0,
              //                                     desc: recentActivites.description,
              //                                     userName: recentActivites.name,
              //                                     profilePath: recentActivites.profileImage,
              //                                     time:"nice"
              //                                         // calculateTimeDifferenceBetween(
              //                                         //     DateTime.parse(date
              //                                         //         .toString()
              //                                         //         .substring(0, 19)),
              //                                         //     now),

              //                                   ),
            ]),
      ),
    );
  }

  Widget getCertificateWidget(
      List<CommonProfession>? certificateList, context) {
    certificateList?.sort((b, a) => a.startDate.compareTo(b.startDate));
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          topRow('Certificates', showArrow: certificateList?.length != 0,
              arrowAction: () {
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
                        duration: Duration(milliseconds: 350),
                        reverseDuration: Duration(milliseconds: 350),
                        type: PageTransitionType.bottomToTop,
                        child: AddCertificate()))
                .then((value) => getPortfolio());
          }),
          isPortfolioLoading == false
              ? Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(right: 10),
                  height: certificateList?.length != 0
                      ? height(context) * 0.33
                      : height(context) * 0.15,
                  child: certificateList?.length != 0
                      ? ListView.builder(
                          itemCount: certificateList?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            String startDateString =
                                "${portfolioResponse?.data.certificate[index].startDate}";

                            DateTime startDate =
                                DateFormat("yyyy-MM-dd").parse(startDateString);
                            return InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    context: context,
                                    enableDrag: true,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return FractionallySizedBox(
                                        heightFactor: 0.9,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '${portfolioResponse?.data.baseFileUrl}${certificateList?[index].imageName}',
                                          width: double.infinity,
                                          height: double.infinity,
                                          errorWidget: (context, url, data) =>
                                              Image.asset(
                                            "assets/images/certificate_dummy.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                width: width(context) * 0.7,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        width: width(context) * 0.7,
                                        height: width(context) * 0.45,
                                        child: CachedNetworkImage(
                                          width: width(context) * 0.7,
                                          height: width(context) * 0.45,
                                          imageUrl:
                                              '${portfolioResponse?.data.baseFileUrl}${certificateList?[index].imageName}',
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, data) =>
                                              Image.asset(
                                            "assets/images/certificate_dummy.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text('${certificateList?[index].title}',
                                        maxLines: 2,
                                        style: Styles.bold(size: 14)),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      '${listOfMonths[startDate.month - 1].substring(0, 3)} ${startDate.year.toString().substring(2, 4)}',
                                      // '${certificateList?[index].startDate ?? 'Sep 21'}',
                                      style: Styles.regular(),
                                    ),
                                  ],
                                ),
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
    experience?.sort((a, b) => a.endDate.compareTo(b.endDate));
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          topRow('Experience', showArrow: experience?.length != 0,
              arrowAction: () {
            if (experience?.length != 0)
              Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 350),
                          reverseDuration: Duration(milliseconds: 350),
                          type: PageTransitionType.bottomToTop,
                          child: ExperienceList(
                              baseUrl: portfolioResponse?.data.baseFileUrl,
                              experience: experience)))
                  .then((value) => getPortfolio());
          }, addAction: () {
            Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 350),
                        reverseDuration: Duration(milliseconds: 350),
                        type: PageTransitionType.bottomToTop,
                        child: AddExperience()))
                .then((value) => getPortfolio());
          }),
          isPortfolioLoading == false
              ? Container(
                  padding: EdgeInsets.all(8),
                  child: experience?.length != 0
                      ? ListView.builder(
                          itemCount: min(2, int.parse('${experience?.length}')),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
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
                            String type =
                                '${experience?[index].employmentType.replaceAll('_', '')}';
                            type = type[0].toUpperCase() + type.substring(1);

                            return Transform.translate(
                              offset: Offset(0, -10),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: SizedBox(
                                            width: width(context) * 0.2,
                                            height: width(context) * 0.2,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  '${portfolioResponse?.data.baseFileUrl}${experience?[index].imageName}',
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, data) =>
                                                      Image.asset(
                                                "assets/images/certificate_dummy.png",
                                                fit: BoxFit.cover,
                                              ),
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
                                                style: Styles.bold(size: 14),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '${experience?[index].institute}',
                                                style: Styles.regular(size: 12),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              experience?[index]
                                                              .currentlyWorkHere ==
                                                          'true' ||
                                                      experience?[index]
                                                              .currentlyWorkHere ==
                                                          'on'
                                                  ? Text(
                                                      '$type  ???  ${listOfMonths[startDate.month - 1].substring(0, 3)} ${startDate.year.toString().substring(2, 4)}  -  Present',
                                                      style: Styles.regular(
                                                          size: 12),
                                                    )
                                                  : Text(
                                                      '$type ??? ${calculateTimeDifferenceBetween(startDate, endDate)} ??? ${listOfMonths[startDate.month - 1].substring(0, 3)} ${startDate.year.toString().substring(2, 4)}  -  ' +
                                                          ' ${listOfMonths[endDate.month - 1].substring(0, 3)} ${endDate.year.toString().substring(2, 4)}',
                                                      style: Styles.regular(
                                                          size: 12),
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
                                    if (index + 1 !=
                                        min(2,
                                            int.parse('${experience?.length}')))
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: Divider(),
                                      )
                                  ],
                                ),
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
    extraActivities?.sort((a, b) => b.startDate.compareTo(a.startDate));

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          topRow('Extra Curricular Activities',
              showArrow: extraActivities?.length != 0, arrowAction: () {
            if (extraActivities?.length != 0)
              // Navigator.push(
              //     context,
              //     NextPageRoute());
              Navigator.push(
                  context,
                  PageTransition(
                      duration: Duration(milliseconds: 350),
                      reverseDuration: Duration(milliseconds: 350),
                      type: PageTransitionType.bottomToTop,
                      child: ExtraActivitiesList(
                        baseUrl: '${portfolioResponse?.data.baseFileUrl}',
                        activities: extraActivities!,
                      ))).then((value) => getPortfolio());
          }, addAction: () {
            Navigator.push(
                    context,
                    PageTransition(
                        duration: Duration(milliseconds: 350),
                        reverseDuration: Duration(milliseconds: 350),
                        type: PageTransitionType.bottomToTop,
                        child: AddActivities()))
                .then((value) => getPortfolio());
          }),
          isPortfolioLoading == false
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: extraActivities?.length != 0
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: min(2, extraActivities!.length),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            String startDateString =
                                "${extraActivities[index].startDate}";

                            DateTime startDate =
                                DateFormat("yyyy-MM-dd").parse(startDateString);

                            return Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: index != 0 ? 10 : 6,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width(context) * 0.2,
                                        height: width(context) * 0.2,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "${portfolioResponse?.data.baseFileUrl}${extraActivities[index].imageName}",
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              enabled: true,
                                              child: Container(
                                                width: width(context) * 0.2,
                                                height: width(context) * 0.2,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Container(
                                                    width: width(context) * 0.2,
                                                    height:
                                                        width(context) * 0.2,
                                                    padding: EdgeInsets.all(8),
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
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        width: width(context) * 0.7,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Transform.translate(
                                              offset: Offset(0, -3),
                                              child: Text(
                                                '${extraActivities[index].title}',
                                                style: Styles.bold(size: 14),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              '${extraActivities[index].institute}',
                                              style: Styles.regular(size: 14),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${extraActivities[index].curricularType}   ??? ',
                                                  style:
                                                      Styles.regular(size: 14),
                                                ),
                                                Text(
                                                  '  ${Utility.ordinal(startDate.day)} ${listOfMonths[startDate.month - 1]} ${startDate.year}',
                                                  style:
                                                      Styles.regular(size: 14),
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (index != extraActivities.length) Divider()
                                ],
                              ),
                            );
                          })
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
          Log.v("PortfolioStatedone ...................");

          portfolioResponse = portfolioState.response;

     if('${portfolioState.response?.data.name}' != '')     Preference.setString(
              Preference.FIRST_NAME, '${portfolioState.response?.data.name}');
          // if (portfolioState.response?.data.image.contains(
          //         '${Preference.getString(Preference.PROFILE_IMAGE)}') ==
          //     true) {
          //   Preference.setString(Preference.PROFILE_IMAGE,
          //       '${portfolioState.response?.data.image}');
          // }

       if('${portfolioState.response?.data.image}' != '')     Preference.setString(Preference.PROFILE_IMAGE,
              '${portfolioState.response?.data.image}');

          Preference.setString(Preference.PROFILE_VIDEO,
              '${portfolioState.response?.data.profileVideo}');
          Preference.setInt(Preference.PROFILE_PERCENT,
              portfolioState.response!.data.profileCompletion);

          if (portfolioState.response?.data.portfolioProfile.isNotEmpty ==
              true) {
            Preference.setString(Preference.ABOUT_ME,
                '${portfolioState.response?.data.portfolioProfile.first.aboutMe}');

            Preference.setString(Preference.USER_HEADLINE,
                '${portfolioState.response?.data.portfolioProfile.first.headline}');
            Preference.setString(Preference.LOCATION,
                '${portfolioState.response?.data.portfolioProfile.first.city}, ${portfolioState.response?.data.portfolioProfile.first.country}');
          }
          Log.v("PortfolioState Success....................");
          setState(() {
            isPortfolioLoading = false;
          });
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
          Log.v("Portfolio TopScoring Loading....................");
          //isPortfolioLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("PortfolioState TopScoring Success....................");

          userRank = portfolioState.response;

          isPortfolioLoading = false;
          setState(() {});
          break;

        case ApiStatus.ERROR:
          isPortfolioLoading = false;
          Log.v("TopScoring Error..........................");
          Log.v(
              "TopScoring Error..........................${portfolioState.error}");

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
          //isPortfolioLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("PortfolioState Competition Success....................");
          competition = portfolioState.response;

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

  Widget topRow(String title,
      {required Function addAction,
      required Function arrowAction,
      bool showAddButton = true,
      bool showArrow = false}) {
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
                if (showArrow)
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
        return '$month Months';
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
              // print('portfolio List');
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
        : InkWell(
            onTap: () {
              // Navigator.pop(context, '/g-competitions');
              // Navigator.push(context, NextPageRoute(Scaffold(body: Competetion(fromDasboard: true,),)));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/comp_emp.png'),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Participate in '),
                  ),
                  ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              ColorConstants.GRADIENT_RED,
                              Color(0xfffc7804),
                            ]).createShader(bounds);
                      },
                      child: Text('Competitions', style: Styles.bold())),
                ],
              ),
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
              Navigator.pop(context, '/g-carvaan');
              // print('portfolio List');
              //  Navigator.push(
              //       context,
              //       NextPageRoute(RecentActivitiesPage(),
              //           isMaintainState: false));
              // Navigator.push(context, MaterialPageRoute(builder: (context)=> CommunityDashboard()));
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
                  Positioned(
                    left: 20,
                    right: 20,
                    child: Column(
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
                              'You have not done any community activity yet,',
                              style: Styles.semibold(
                                  size: 14, color: Color(0xff0E1638))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                          ),
                          child: ShaderMask(
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
                              child: Text('Explore Community',
                                  style: Styles.bold(
                                    size: 14,
                                  ))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget educationList(List<CommonProfession> education) {
    education.sort((a, b) => b.endDate.compareTo(a.endDate));

    return Container(
      color: ColorConstants.WHITE,
      child: education.length != 0
          ? ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: min(2, portfolioResponse!.data.education.length),
              itemBuilder: (context, index) {
                int len = min(2, portfolioResponse!.data.education.length);
                DateTime endDate = DateTime.now();

                if (portfolioResponse?.data.education[index].endDate != null ||
                    portfolioResponse?.data.education[index].endDate != '') {
                  String endDateString = "${education[index].endDate}";
                  endDate = DateFormat("yyyy-MM-dd").parse(endDateString);
                }
                String startDateString = "${education[index].startDate}";

                DateTime startDate =
                    DateFormat("yyyy-MM-dd").parse(startDateString);

                return Container(
                  width: width(context) * 0.3,
                  color: ColorConstants.WHITE,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index != 0)
                        SizedBox(
                          height: 18,
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${portfolioResponse?.data.baseFileUrl}${education[index].imageName}',
                                height: width(context) * 0.2,
                                width: width(context) * 0.2,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  return Container(
                                    padding: EdgeInsets.all(14),
                                    decoration:
                                        BoxDecoration(color: Color(0xffD5D5D5)),
                                    child: SvgPicture.asset(
                                      'assets/images/default_education.svg',
                                      height: 40,
                                      width: 40,
                                      color: ColorConstants.GREY_5,
                                      allowDrawingOutsideViewBox: true,
                                    ),
                                  );
                                },
                                placeholder:
                                    (BuildContext context, loadingProgress) {
                                  return Container(
                                    padding: EdgeInsets.all(14),
                                    decoration:
                                        BoxDecoration(color: Color(0xffD5D5D5)),
                                    child: SvgPicture.asset(
                                      'assets/images/default_education.svg',
                                      height: 40,
                                      width: 40,
                                      color: ColorConstants.GREY_5,
                                      allowDrawingOutsideViewBox: true,
                                    ),
                                  );
                                },
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: width(context) * 0.71,
                                child: Text(
                                  '${education[index].title}',
                                  maxLines: 2,
                                  style: Styles.bold(size: 14),
                                ),
                              ),
                              SizedBox(height: 4),
                              SizedBox(
                                width: width(context) * 0.71,
                                child: Text(
                                  maxLines: 2,
                                  '${education[index].institute}',
                                  style: Styles.regular(size: 14),
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '${listOfMonths[startDate.month - 1].substring(0, 3)} ${startDate.year.toString().substring(2, 4)} - ',
                                    style: Styles.regular(size: 14),
                                  ),
                                  if (portfolioResponse
                                              ?.data.education[index].endDate !=
                                          null ||
                                      portfolioResponse
                                              ?.data.education[index].endDate !=
                                          '')
                                    Text(
                                      '${listOfMonths[endDate.month - 1].substring(0, 3)} ${endDate.year.toString().substring(2, 4)}',
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
                      SizedBox(
                        child: ReadMoreText(
                          viewMore: 'View more',
                          text: '${education[index].description}',
                          color: Color(0xff929BA3),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      if (index + 1 != len) Divider(),
                    ],
                  ),
                );
              })
          : educationListShimmer(0),
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

  /*void callBackUpdateFunction(String ){

  }*/

}

class ShowSocailLinks extends StatefulWidget {
  final PortfolioSocial? portfolioSocial;

  const ShowSocailLinks({Key? key, this.portfolioSocial}) : super(key: key);

  @override
  State<ShowSocailLinks> createState() => _ShowSocailLinksState();
}

class _ShowSocailLinksState extends State<ShowSocailLinks> {
  @override
  Widget build(BuildContext context) {
    dynamic data = widget.portfolioSocial?.toJson();
    List<String> socialKey = [];
    List<String> socialValue = [];
    List<String> socialKeyUnselected = [];
    List<String> socialValueUnselected = [];

    for (final key in data.keys) {
      if (key != 'mob_num' &&
          key != 'email' &&
          key != 'mob_num_hidden' &&
          key != 'email_hidden' &&
          key != 'id' &&
          key != 'other') {
        if (data[key] != null && data[key].toString().isNotEmpty) {
          print('print key $key');
          socialKey.insert(0, '$key');
          socialValue.insert(0, '${data[key]}');
        } else {
          print('print key insside $key');
          socialKeyUnselected.insert(0, '$key');
          socialValueUnselected.insert(0, '${data[key]}');
        }
      }
    }

    return SizedBox(
      height: height(context) * 0.1,
      child: Row(
        children: [
          ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: min(4, socialKey.length),
              itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CommonWebView(
                              url: socialValue[index],
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                        height: 20,
                        margin: EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                            'assets/images/${socialKey[index]}' + '.svg')),
                  )),
          ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: max(0, 4 - socialKey.length),
              itemBuilder: (context, index) => Container(
                  height: 20,
                  margin: EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    'assets/images/${socialKeyUnselected[index]}' + '.svg',
                    color: ColorConstants.GREY_4,
                  ))),
          GestureDetector(
            onTapDown: (TapDownDetails detail) {
              print('open mneu');
              _showPopupMenu(detail.globalPosition, socialKey, socialValue,
                  socialKeyUnselected, socialValueUnselected);
            },
            child: SvgPicture.asset('assets/images/vertical_menu.svg'),
          )
        ],
      ),
    );
  }

  void _showPopupMenu(Offset offset, socialKey, socialValue,
      socialKeyUnselected, socialValueUnselected) async {
    final screenSize = MediaQuery.of(context).size;
    double left = offset.dx;
    double top = offset.dy;
    double right = screenSize.width - offset.dx;
    double bottom = screenSize.height - offset.dy;
    print('gggggg 1');
    List<PopupMenuItem> selectedMenuList = List.generate(
        max(0, socialKey.length - 4),
        (index) => PopupMenuItem(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CommonWebView(
                          url: socialValue[index + 4],
                        );
                      },
                    ),
                  );
                },
                child: Row(
                  children: [
                    Container(
                        height: 25,
                        margin: EdgeInsets.only(right: 6),
                        child: SvgPicture.asset(
                            'assets/images/${socialKey[index + 4]}' + '.svg')),
                    Text(
                      '${socialKey[index + 4]}'.capital(),
                      style: Styles.regular(),
                    )
                  ],
                ),
              ),
              value: '${socialKey[index + 4]}',
            ));
    print('gggggg 2');

    List<PopupMenuItem> unselectedMenuList = List.generate(
        max(0, socialKeyUnselected.length - max(0, 4 - socialKey.length)),
        (index) => PopupMenuItem(
              child: Row(
                children: [
                  Container(
                      height: 25,
                      margin: EdgeInsets.only(right: 6),
                      child: SvgPicture.asset(
                        'assets/images/${socialKeyUnselected[index + max(0, 4 - socialKey.length)]}' +
                            '.svg',
                        color: ColorConstants.GREY_4,
                      )),
                  Text(
                    '${socialKeyUnselected[index + max(0, 4 - socialKey.length)]}'
                        .capital(),
                  )
                ],
              ),
              value:
                  '${socialValueUnselected[index + max(0, 4 - socialKey.length)]}',
            ));
    print('gggggg 3');

    List<PopupMenuItem> finalList = [
      ...selectedMenuList,
      ...unselectedMenuList
    ];
    await showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, bottom),
      items: finalList,
      // items: socialKey.length > 4
      //     ?
      //     : ,
      elevation: 10.0,
    );
  }
}

extension on String {
  String capital() {
    return this[0].toUpperCase() + this.substring(1);
  }
}
