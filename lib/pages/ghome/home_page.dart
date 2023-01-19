// ignore_for_file: unused_import

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/data/api/api_constants.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/providers/announcement_detail_provider.dart';
import 'package:masterg/data/providers/video_player_provider.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/analytics_pages/analytic_page.dart';
import 'package:masterg/pages/gcarvaan/post/gcarvaan_post_page.dart';
import 'package:masterg/pages/ghome/g_school.dart';
import 'package:masterg/pages/ghome/ghome.dart';
import 'package:masterg/pages/reels/reels_dashboard_page.dart';
import 'package:masterg/pages/singularis/competition.dart';
import 'package:masterg/pages/singularis/dashboard.dart';
import 'package:masterg/pages/singularis/dashboard_temp.dart';
import 'package:masterg/pages/singularis/job/job_dashboard_page.dart';
import 'package:masterg/pages/swayam_pages/announcemnt_page.dart';
import 'package:masterg/pages/swayam_pages/library_page.dart';
import 'package:masterg/pages/swayam_pages/profile_page.dart';
import 'package:masterg/pages/swayam_pages/sign_up_screen.dart';
import 'package:masterg/pages/swayam_pages/training_home_page.dart';
import 'package:masterg/pages/swayam_pages/training_provider.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/pages/user_profile_page/portfolio_page.dart';
import 'package:masterg/pages/user_profile_page/user_profile_page.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/config.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/check_connection.dart';
import '../custom_pages/custom_widgets/NextPageRouting.dart';

class homePage extends StatefulWidget {
  final index;
  List<MultipartFile>? fileToUpload;
  bool? isReelsPost;
  String? desc;
  List<String?>? filesPath;
  bool isFromCreatePost;
  List<Menu>? bottomMenu;

  homePage(
      {Key? key,
      this.index = 0,
      this.fileToUpload,
      this.isReelsPost,
      this.desc,
      this.filesPath,
      this.bottomMenu,
      this.isFromCreatePost = false})
      : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var currentIndex = 0;
  String? profileImage = '';

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  initState() {
    super.initState();
    // Utility().checkInternet(context);

    currentIndex = widget.index;

    profileImage = Preference.getString(Preference.PROFILE_IMAGE);
  }

  void refreshData() {
    profileImage = Preference.getString(Preference.PROFILE_IMAGE);
  }

  onGoBack(dynamic value) {
    //refreshData();

    setState(() {
      profileImage = Preference.getString(Preference.PROFILE_IMAGE);
    });
  }

  @override
  Widget build(BuildContext context) {
    _getDrawerLayout(BuildContext context) {
      return Drawer(
          child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width - 50,
          padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 40),
          color: ColorConstants.WHITE,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(UserSession.userImageUrl ?? ""),
                    radius: 20.0),
                title: Text(
                  UserSession.userName ?? '',
                  style: Styles.textExtraBold(
                      color: (ColorConstants.PRIMARY_COLOR)),
                ),
                subtitle: Text(
                  UserSession.email ?? '',
                  style: Styles.textExtraBold(size: 12),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: ColorConstants.PRIMARY_COLOR,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      NextPageRoute(SignUpScreen(
                        isFromProfile: true,
                      )));
                },
              ),
              // _size(height: 10),

              // _getSwayamMenu(),
            ],
          ),
        ),
      ));
    }

    var pages = {
      '/g-home': GHome(),
      // '/g-dashboard': const DashboardPage(),
      '/g-dashboard': Competetion(),
      // '/g-school': const Competetion(),
      '/g-school': const GSchool(),
      '/g-reels': ReelsDashboardPage(),
      // '/g-reels': JobDashboardPage(),
      '/g-carvaan': GCarvaanPostPage(
        fromDashboard: false,
        fileToUpload: widget.fileToUpload,
        desc: widget.desc,
        filesPath: widget.filesPath,
        formCreatePost: widget.isFromCreatePost,
      ),
      '/training': ChangeNotifierProvider<TrainingProvider>(
          create: (context) => TrainingProvider(TrainingService(ApiService())),
          child: TrainingHomePage(
            drawerWidget: _getDrawerLayout(context),
          )),
      '/announcements': ChangeNotifierProvider<AnnouncementDetailProvider>(
          create: (context) =>
              AnnouncementDetailProvider(TrainingService(ApiService())),
          child: AnnouncementPage(
            isViewAll: true,
            drawerWidget: _getDrawerLayout(context),
          )),
      '/analytics': AnalyticPage(
        isViewAll: true,
        drawerWidget: _getDrawerLayout(context),
      ),
      '/library': LibraryPage(
        isViewAll: true,
      ),
      '/my-space-settings': ProfilePage(drawerWidget: _getDrawerLayout(context))
    };

    /*var iconUnSelected = {
      '/g-home': 'assets/images/unselected_ghome.svg',
      '/g-school': 'assets/images/unselected_gschool.svg',
      '/g-reels': 'assets/images/unselected_greels.svg',
      '/g-carvaan': 'assets/images/unselected_gcarvaan.svg',
      '/sic-council': 'assets/images/my_council.svg',
      '/training': 'assets/images/trainings.svg',
      '/announcements': 'assets/images/announcements.svg',
      '/analytics': 'assets/images/analytics.svg',
      '/library': 'assets/images/library.svg',
      '/my-space-settings': 'assets/images/mySpaceSettings.svg'
    };*/

    /*var iconSelected = {
      '/g-home': 'assets/images/selected_ghome.svg',
      '/g-school': 'assets/images/selected_gschool.svg',
      '/g-reels': 'assets/images/selected_greels.svg',
      '/g-carvaan': 'assets/images/selected_gcarvaan.svg',
      '/sic-council': 'assets/images/my_council.svg',
      '/training': 'assets/images/selectedTrainings.svg',
      '/announcements': 'assets/images/selectedAnnouncements.svg',
      '/analytics': 'assets/images/selectedAnalytics.svg',
      '/library': 'assets/images/selectedLibrary.svg',
      '/my-space-settings': 'assets/images/selectedMySpaceSettings.svg'
    };*/

    var iconUnSelected = {
      '/g-dashboard': 'assets/images/un_dashboard.svg',
      '/g-home': 'assets/images/un_community.svg',
      '/g-school': 'assets/images/un_learn.svg',
      '/g-reels': 'assets/images/un_trends.svg',
      '/g-carvaan': 'assets/images/un_careers.svg',
      '/sic-council': 'assets/images/my_council.svg',
      '/training': 'assets/images/trainings.svg',
      '/announcements': 'assets/images/announcements.svg',
      '/analytics': 'assets/images/analytics.svg',
      '/library': 'assets/images/library.svg',
      '/my-space-settings': 'assets/images/mySpaceSettings.svg'
    };

    var iconSelected = {
      '/g-dashboard': 'assets/images/s_dashboards.svg',
      '/g-home': 'assets/images/s_community.svg',
      '/g-school': 'assets/images/s_learn.svg',
      '/g-reels': 'assets/images/s_trends.svg',
      '/g-carvaan': 'assets/images/s_careers.svg',
      '/sic-council': 'assets/images/my_council.svg',
      '/training': 'assets/images/selectedTrainings.svg',
      '/announcements': 'assets/images/selectedAnnouncements.svg',
      '/analytics': 'assets/images/selectedAnalytics.svg',
      '/library': 'assets/images/selectedLibrary.svg',
      '/my-space-settings': 'assets/images/selectedMySpaceSettings.svg'
    };

    if (widget.isFromCreatePost) {
      pages['/g-carvaan'] = GCarvaanPostPage(
        fileToUpload: widget.fileToUpload,
        desc: widget.desc,
        filesPath: widget.filesPath,
        formCreatePost: widget.isFromCreatePost,
      );
      widget.fileToUpload = null;
      widget.desc = null;
      widget.filesPath = null;
      widget.isFromCreatePost = false;
    } else {
      widget.fileToUpload = null;
      widget.desc = null;
      widget.filesPath = null;
      widget.isFromCreatePost = false;
      pages['/g-carvaan'] = GCarvaanPostPage(
        fileToUpload: null,
        desc: null,
        filesPath: null,
        formCreatePost: widget.isFromCreatePost,
      );
    }

    String appBarImagePath = 'assets/images/${APK_DETAILS['logo_url']}';

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<VideoPlayerProvider>(
            create: (context) => VideoPlayerProvider(true),
          ),
          ChangeNotifierProvider<MenuListProvider>(
            create: (context) => MenuListProvider(widget.bottomMenu!),
          ),
        ],
        child: Consumer<MenuListProvider>(
            builder: (context, menuProvider, child) => Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: ColorConstants.GREY,

                  appBar: widget.bottomMenu![menuProvider.getCurrentIndex()]
                                  .url !=
                              '/g-reels' &&
                          APK_DETAILS['package_name'] !=
                              "com.at.perfetti_swayam"
                      ?  PreferredSize(
                        preferredSize:  Size.fromHeight(100),
                          child: Container(
                            height: 100,
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: <Color>[
                                    Color(0xfffc7804),
                                    Color(0xffff2252)
                                  ]),
                            ),

                            child: Center(
                              child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return UserProfilePage();
                                    })).then(onGoBack);
                                  },
                                  child: Transform.scale(
                                    scale: 1,
                                    child:
                                        profileImage != null && profileImage != ''
                                            ? CircleAvatar(
                                                onBackgroundImageError: (_, __) {
                                                  setState(() {
                                                    profileImage = '';
                                                  });
                                                },
                                                backgroundImage: NetworkImage(
                                                  profileImage!,
                                                ))
                                            : SvgPicture.asset(
                                                'assets/images/default_user.svg',
                                                height: 40.0,
                                                width: 40.0,
                                                allowDrawingOutsideViewBox: true,
                                              ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                    '${Preference.getString(Preference.FIRST_NAME)}',
                                    style:
                                        Styles.bold(
                                          size: 22,
                                          color: ColorConstants.WHITE))
                              ],
                          ),
                            )
                          ),
                          // leading: IconButton(
                          //   onPressed: () async {},
                          //   icon: appBarImagePath.split('.').last == 'svg'
                          //       ? SvgPicture.asset(
                          //           appBarImagePath,
                          //           fit: BoxFit.contain,
                          //         )
                          //       : Image.asset(
                          //           appBarImagePath,
                          //           fit: BoxFit.contain,
                          //         ),
                          // ),
                          // title: ,
                          // backgroundColor: ColorConstants().primaryColor(),
                          // elevation: 0.0,
                          // centerTitle: true,
                        )
                      : PreferredSize(
                          child: SizedBox(), preferredSize: Size.zero),

                  body: pages[
                      widget.bottomMenu![menuProvider.getCurrentIndex()].url],
                  //bottom Navigator bar
                  bottomNavigationBar: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.10,
                    child: BottomNavigationBar(
                      // backgroundColor: Colors.red,

                      type: BottomNavigationBarType.fixed,
                      currentIndex: menuProvider.getCurrentIndex(),
                      selectedItemColor: ColorConstants().primaryColor(),
                      items: [
                        for (int i = 0; i < widget.bottomMenu!.length; i++)
                          BottomNavigationBarItem(
                            icon: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 3),
                                menuProvider.getCurrentIndex() ==
                                        widget.bottomMenu!
                                            .indexOf(widget.bottomMenu![i])
                                    ? SvgPicture.asset(
                                        '${iconSelected['${widget.bottomMenu![i].url}']}',
                                        // color: APK_DETAILS['package_name'] !=
                                        //         'com.at.masterg'
                                        //     ? ColorConstants().primaryColor()
                                        //     : null,
                                        allowDrawingOutsideViewBox: true,
                                      )
                                    : SvgPicture.asset(
                                        '${iconUnSelected['${widget.bottomMenu![i].url}']}',
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  '${widget.bottomMenu![i].label}',
                                  style: Styles.regular(
                                      size: 12,
                                      color: menuProvider.getCurrentIndex() ==
                                              widget.bottomMenu!.indexOf(
                                                  widget.bottomMenu![i])
                                          ? ColorConstants().primaryColor()
                                          : Colors.black.withOpacity(0.8)),
                                ),
                              ],
                            ),
                            label: '',
                          ),
                      ],
                      onTap: (index) {
                        if (widget.bottomMenu![index].linkType != 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                        appBar: AppBar(
                                          backgroundColor:
                                              ColorConstants().primaryColor(),
                                          elevation: 0.0,
                                          leading: IconButton(
                                            icon: const Icon(Icons.arrow_back),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        body: WebView(
                                          javascriptMode:
                                              JavascriptMode.unrestricted,
                                          initialUrl:
                                              '${ApiConstants().PRODUCTION_BASE_URL()}${widget.bottomMenu![index].url}?cred=${UserSession.userToken}',
                                        ),
                                      )));
                        } else {
                          setState(() {
                            currentIndex = index;
                            menuProvider.updateCurrentIndex(
                                widget.bottomMenu![index].url!);
                          });
                        }
                      },
                    ),
                  ),
                )));
  }
}
