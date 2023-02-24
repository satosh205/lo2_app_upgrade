import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/pages/gcarvaan/post/gcarvaan_post_page.dart';
import 'package:masterg/pages/reels/reels_dashboard_page.dart';
import 'package:masterg/pages/singularis/recentactivities/recent_activities_reels_page.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:provider/provider.dart';

import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../data/providers/video_player_provider.dart';
import '../../../utils/Styles.dart';

class RecentActivitiesPage extends StatefulWidget {
  const RecentActivitiesPage({Key? key}) : super(key: key);

  @override
  State<RecentActivitiesPage> createState() => _RecentActivitiesPageState();
}

class _RecentActivitiesPageState extends State<RecentActivitiesPage> {

  bool selectedFlag = false;

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<VideoPlayerProvider>(
          create: (context) => VideoPlayerProvider(true),
        ),
      ],
      child: Consumer<VideoPlayerProvider>(
          builder: (context, menuProvider, child) => BlocManager(
            initState: (context) {},
            child: BlocListener<HomeBloc, HomeState>(
              listener: (context, state) async{},
              child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                        backgroundColor: ColorConstants.WHITE,
                        elevation: 0,
                        leading: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: Color(0xff0E1638),
                            )),
                        title: Text(
                          'Recent Activities',
                          style: Styles.semibold(),
                        )),
                    body: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 130, top: 10.0, bottom: 30.0),
                            child: ButtonsTabBar(
                              backgroundColor: Colors.white,
                              borderColor: ColorConstants.GRADIENT_RED,
                              unselectedBackgroundColor: Colors.white,
                              labelStyle: TextStyle(color: ColorConstants.selected, fontWeight: FontWeight.bold),
                              unselectedLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              borderWidth: 1,
                              unselectedBorderColor: ColorConstants.GREY_3,
                              radius: 100,
                              tabs: [
                                Tab(
                                  //icon: Icon(Icons.directions_car),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                    child: Text('Community'),
                                  ),
                                ),
                                Tab(
                                  //icon: Icon(Icons.directions_transit),
                                  //text: "Reels",
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                    child: Text('Reels'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                GCarvaanPostPage(
                                    fileToUpload: null,
                                    desc: null,
                                    filesPath: null,
                                    formCreatePost: false,
                                    recentActivities: true,
                                    fromUserActivity: true,
                                    ),
                                RecentActivitiesReelsPage(),
                                //ReelsDashboardPage(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ),
      ),
    );

    /*return Scaffold(
      backgroundColor: ColorConstants.WHITE,
      appBar: AppBar(
          backgroundColor: ColorConstants.WHITE,
          elevation: 0,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xff0E1638),
              )),
          title: Text(
            'Recent Activities',
            style: Styles.semibold(),
          )),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 150, top: 10.0, bottom: 30.0),
              child: ButtonsTabBar(
                backgroundColor: Colors.white,
                borderColor: ColorConstants.GRADIENT_RED,
                unselectedBackgroundColor: Colors.white,
                labelStyle: TextStyle(color: ColorConstants.selected, fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                borderWidth: 1,
                unselectedBorderColor: ColorConstants.GREY_3,
                radius: 100,
                tabs: [
                  Tab(
                    //icon: Icon(Icons.directions_car),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text('Community'),
                    ),
                  ),
                  Tab(
                    //icon: Icon(Icons.directions_transit),
                    //text: "Reels",
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text('Reels'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GCarvaanPostPage(
                    fileToUpload: null,
                    desc: null,
                    filesPath: null,
                    formCreatePost: false,
                    recentActivities: true),
                  ReelsDashboardPage(),
                ],
              ),
            ),
          ],
        ),
      )
    );*/
  }

}
