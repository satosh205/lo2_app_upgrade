import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/data/api/api_constants.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/providers/video_player_provider.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/gcarvaan/post/gcarvaan_post_page.dart';
import 'package:masterg/pages/ghome/g_school.dart';
import 'package:masterg/pages/ghome/ghome.dart';
import 'package:masterg/pages/reels/reels_dashboard_page.dart';
import 'package:masterg/pages/user_profile_page/user_profile_page.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/config.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
      )
    };

    var iconsUnSelected = {
      '/g-home': 'assets/images/unselected_ghome.svg',
      '/g-school': 'assets/images/unselected_gschool.svg',
      '/g-reels': 'assets/images/unselected_greels.svg',
      '/g-carvaan': 'assets/images/unselected_gcarvaan.svg',
      '/sic-council': 'assets/images/my_council.svg',
    };

    var iconSeleted = {
      '/g-home': 'assets/images/selected_ghome.svg',
      '/g-school': 'assets/images/selected_gschool.svg',
      '/g-reels': 'assets/images/selected_greels.svg',
      '/g-carvaan': 'assets/images/selected_gcarvaan.svg',
      '/sic-council': 'assets/images/my_council.svg',
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
        //   // Add a ListView to the drawer. This ensures the user can scroll
        //   // through the options in the drawer if there isn't enough vertical
        //   // space to fit everything.
        //   child: ListView(
        //     // Important: Remove any padding from the ListView.
        //     padding: EdgeInsets.zero,
        //     children: [
        //       SizedBox(
        //         height: 50,
        //       ),
        //       ListTile(
        //         contentPadding: EdgeInsets.zero,
        //         leading: CircleAvatar(
        //             backgroundImage:
        //                 NetworkImage(UserSession.userImageUrl ?? ""),
        //             radius: 30.0),
        //         title: Text(
        //           '${UserSession.firstName}',
        //           style: Styles.textExtraBold(color: (ColorConstants.WHITE)),
        //         ),
        //         subtitle: Text(
        //           UserSession.email ?? '',
        //           style: Styles.textExtraBold(
        //               size: 12, color: (ColorConstants.WHITE)),
        //         ),
        //         onTap: () {},
        //       ),
        //       Divider(height: 20),
        //       ListTile(
        //         title: const Text('FAQs'),
        //         onTap: () {
        //           Navigator.push(context, NextPageRoute(FaqPage()));
        //         },
        //       ),
        //     ],
        //   ),
        // ),

        appBar: widget.bottomMenu![currentIndex].url != '/g-reels'
            ? AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return UserProfilePage();
                        })).then(onGoBack);
                      },
                      child: Transform.scale(
                        scale: 1,
                        child: profileImage != null && profileImage != ''
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(profileImage!))
                            : SvgPicture.asset(
                                'assets/images/profileIcon.svg',
                                height: 40.0,
                                width: 40.0,
                                allowDrawingOutsideViewBox: true,
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
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
          height: MediaQuery.of(context).size.height * 0.11,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedItemColor: ColorConstants().primaryColor(),
            unselectedItemColor: Colors.blue,
            items: [
              for (int i = 0; i < widget.bottomMenu!.length; i++)
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      currentIndex ==
                              widget.bottomMenu!.indexOf(widget.bottomMenu![i])
                          ? SvgPicture.asset(
                              '${iconSeleted['${widget.bottomMenu?[i].url}']}',
                              color: ColorConstants().primaryColor(),
                              // allowDrawingOutsideViewBox: true,
                            )
                          : SvgPicture.asset(
                              '${iconsUnSelected['${widget.bottomMenu?[i].url}']}',
                              color: ColorConstants.BLACK,
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
