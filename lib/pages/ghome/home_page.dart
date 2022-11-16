import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
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
import 'package:masterg/pages/swayam_pages/announcemnt_page.dart';
import 'package:masterg/pages/swayam_pages/library_page.dart';
import 'package:masterg/pages/swayam_pages/profile_page.dart';
import 'package:masterg/pages/swayam_pages/training_course.dart';
import 'package:masterg/pages/swayam_pages/training_home_page.dart';
import 'package:masterg/pages/swayam_pages/training_provider.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/pages/user_profile_page/user_profile_page.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/config.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    var pages = {
      '/g-home': GHome(),
      '/g-school': const GSchool(),
      '/g-reels': ReelsDashboardPage(),
      '/g-carvaan': GCarvaanPostPage(
        fileToUpload: widget.fileToUpload,
        desc: widget.desc,
        filesPath: widget.filesPath,
        formCreatePost: widget.isFromCreatePost,
      ),
      '/training': ChangeNotifierProvider<TrainingProvider>(
          create: (context) => TrainingProvider(TrainingService(ApiService())),
          child: TrainingHomePage(
            drawerWidget: SizedBox(),
          )),
      '/announcements': ChangeNotifierProvider<AnnouncementDetailProvider>(
          create: (context) =>
              AnnouncementDetailProvider(TrainingService(ApiService())),
          child: AnnouncementPage(
            isViewAll: true,
            drawerWidget: SizedBox(),
          )),
      '/analytics': AnalyticPage(isViewAll: true),
      '/library': LibraryPage(
        isViewAll: true,
      ),
      '/my-space-settings': ProfilePage()
    };

    var iconsUnSelected = {
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
    };

    var iconSeleted = {
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
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorConstants.GREY,
        // drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        // child: ListView(
        // Important: Remove any padding from the ListView.
        // padding: EdgeInsets.zero,
        // children: [
        //   SizedBox(
        //     height: 50,
        //   ),
        //   ListTile(
        //     title: const Text('AnalyticPage'),
        //     onTap: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (BuildContext context) => ProfilePage()));
        //     },
        //   ),
        //   Divider(height: 20),
        // ListTile(
        //   title: const Text('Idea Factory'),
        //   onTap: () {
        //     Navigator.push(
        //         context,
        //         NextPageRoute(FeedBackPage(
        //           isViewAll: true,
        //         )));
        //   },
        // ),
        // Divider(height: 20),
        // ListTile(
        //   title: const Text('Profile 5'),
        //   onTap: () {
        //     Navigator.push(context, NextPageRoute(ProfilePage()));
        //   },
        // ),
        // Divider(height: 20),
        // ListTile(
        //   title: const Text('Annouccment '),
        //   onTap: () {
        //     Navigator.push(context, NextPageRoute(TrainingCourses()));
        //   },
        // ),
        // Divider(height: 20),
        // ListTile(
        //   title: const Text('LibraryPage 4 '),
        //   onTap: () {
        //     Navigator.push(
        //         context,
        //         NextPageRoute(LibraryPage(
        //           isViewAll: true,
        //         )));
        //   },
        // ),
        // ],
        // ),
        // ),

        appBar: widget.bottomMenu![currentIndex].url != '/g-reels' &&
                APK_DETAILS['package_name'] != "com.at.perfetti_swayam"
            ? AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () async{
                    // _scaffoldKey.currentState?.openDrawer();
                   var box = Hive.box("content");
      // List<Menu> resp = box.get('bottomMenu');
      // dynamic resp =  Data.fromJson(box.get('bottomMenu'));
      await Future.delayed(Duration(seconds: 2));
      print('the response is ${box.get('bottomMenu')}');
            // resp.menu?.sort((a, b) => a.inAppOrder!.compareTo(b.inAppOrder!));


      // Navigator.pushAndRemoveUntil(
      //     context,
      //     NextPageRoute(
      //         homePage(
      //           bottomMenu: resp.menu,
      //         ),
      //         isMaintainState: true),
      //     (route) => false);
                    
                  },
                  // icon: Image.asset(
                  //         'assets/images/edulyst_logo_appbar.png',

                  //         fit: BoxFit.contain,
                  //       ),
                  icon: appBarImagePath.split('.').last == 'svg'
                      ? SvgPicture.asset(
                          appBarImagePath,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          appBarImagePath,
                          fit: BoxFit.contain,
                        ),
                ),
                title: Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    InkWell(
                      onTap: () {
                        // print('the path is $appBarImagePath');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return UserProfilePage();
                        })).then(onGoBack);
                      },
                      child: Transform.scale(
                        scale: 1,
                        child: profileImage != null && profileImage != ''
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
                  ],
                ),
                backgroundColor: ColorConstants().primaryColor(),
                elevation: 0.0,
                centerTitle: true,
              )
            : PreferredSize(child: SizedBox(), preferredSize: Size.zero),

        body: pages[widget.bottomMenu![currentIndex].url],

        //bottom Navigator bar
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).size.height * 0.10,
          child: BottomNavigationBar(
            // backgroundColor: Colors.red,
          
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedItemColor: ColorConstants().primaryColor(),
            unselectedItemColor: Colors.blue,
            items: [
              
              for (int i = 0; i < widget.bottomMenu!.length; i++)
                BottomNavigationBarItem(
                  
                  icon: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 3),
                      currentIndex ==
                              widget.bottomMenu!.indexOf(widget.bottomMenu![i])
                          ? SvgPicture.asset(
                              '${iconSeleted['${widget.bottomMenu?[i].url}']}',
                              color: APK_DETAILS['package_name'] !=
                                      'com.at.masterg'
                                  ? ColorConstants().primaryColor()
                                  : null,
                              allowDrawingOutsideViewBox: false,
                            )
                          : SvgPicture.asset(
                              '${iconsUnSelected['${widget.bottomMenu?[i].url}']}',
                              allowDrawingOutsideViewBox: true,
                            ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        '${widget.bottomMenu![i].label}',
                        style: Styles.regular(
                            size: 12,
                            color: currentIndex ==
                                    widget.bottomMenu!
                                        .indexOf(widget.bottomMenu![i])
                                ? ColorConstants().primaryColor()
                                : Colors.black.withOpacity(0.8)
                                
                                
                                ),
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
                                javascriptMode: JavascriptMode.unrestricted,
                                initialUrl:
                                    '${ApiConstants().PRODUCTION_BASE_URL()}${widget.bottomMenu![index].url}?cred=${UserSession.userToken}',
                              ),
                            )));
              } else {
                setState(() {
                  currentIndex = index;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
