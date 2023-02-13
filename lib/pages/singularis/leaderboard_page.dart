import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/leaderboard_resp.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/singularis/point_history.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

import '../../data/models/response/home_response/leaderboard_resp.dart';

class LeaderboardPage extends StatefulWidget {
  final bool fromDashboard;
  const LeaderboardPage({
    Key? key,
    this.fromDashboard = false,
  }) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  bool? isLeaderboardLoading = true;
  LeaderboardResponse? leaderboardResponse;

  @override
  void initState() {
    // getLeaderboard();
    getLeaderboardList();
    super.initState();
  }

  void getLeaderboardList() {
    BlocProvider.of<HomeBloc>(context).add(LeaderboardEvent(
        id: 2166, type: 'competition', skipotherUser: 0, skipcurrentUser: 0));
  }

  // void getLeaderboard() {
  //   BlocProvider.of<HomeBloc>(context).add(LeaderboardEvent(
  //       id: 2166, type: 'competition', skipotherUser: 0, skipcurrentUser: 0));
  // }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) async {
            if (state is LeaderboardState) {
              handleLeaderboardResponse(state);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorConstants.WHITE,
              elevation: 0.0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                        ColorConstants.GRADIENT_RED.withOpacity(0.4),
                        ColorConstants.GRADIENT_ORANGE.withOpacity(0.4)
                      ]),
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              title: Text(
                "Leaderboard",
                style: Styles.bold(),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            ColorConstants.GRADIENT_RED.withOpacity(0.4),
                            ColorConstants.GRADIENT_ORANGE.withOpacity(0.4)
                          ]),
                    ),
                    height: height(context) * 0.35,
                    width: width(context),
                    child: isLeaderboardLoading == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              leadercard(null, 'Saksham', 2, 10, 2),
                              leadercard(null, 'Ajay', 2, 2, 1),
                              leadercard(null, 'Abhishek', 2, 2, 3),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              leadercard(
                                  '${leaderboardResponse?.data[1].profileImage}',
                                  '${leaderboardResponse?.data[1].name}',
                                  int.parse(
                                      '${leaderboardResponse?.data[1].totalActivities}'),
                                  '${leaderboardResponse?.data[1].gScore}',
                                  2),
                              leadercard(
                                  '${leaderboardResponse?.data[0].profileImage}',
                                  '${leaderboardResponse?.data[0].name}',
                                  int.parse(
                                      '${leaderboardResponse?.data[0].totalActivities}'),
                                  '${leaderboardResponse?.data[0].gScore}',
                                  1),
                              leadercard(
                                  '${leaderboardResponse?.data[2].profileImage}',
                                  '${leaderboardResponse?.data[2].name}',
                                  int.parse(
                                      '${leaderboardResponse?.data[2].totalActivities}'),
                                  '${leaderboardResponse?.data[2].gScore}',
                                  3),
                            ],
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Text(
                          "Your Position",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: ColorConstants.GRADIENT_RED),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 13,
                              offset: Offset(0, 4),
                              color: ColorConstants.BLACK.withOpacity(0.2)),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          leading: SizedBox(
                            width: width(context) * 0.2,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text("1. "),
                                ),

                                // ClipRRect(
                                //       borderRadius: BorderRadius.circular(200),
                                //       child: SizedBox(
                                //         width: 100,
                                //         child: Image.network(
                                //             '${Preference.getString(Preference.PROFILE_IMAGE)}'),
                                //       ),
                                //     )
                                CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "${Preference.getString(Preference.PROFILE_IMAGE)}")),
                              ],
                            ),
                          ),
                          title: Text("${leaderboardResponse?.data.where((e) => e.id == Preference.getInt(Preference.USER_ID)).isEmpty == true ? Preference.getString(Preference.FIRST_NAME)
                              :leaderboardResponse?.data.where((e) => e.id == Preference.getInt(Preference.USER_ID)).first.name}"),
                          //title: Text("${leaderboardResponse?.data.where((e) => e.id == Preference.getInt(Preference.USER_ID)).first.name}"),
                          //subtitle: Text("${leaderboardResponse?.data.where((e) => e.id == Preference.getInt(Preference.USER_ID)).first.totalActivities} Activities"),
                          subtitle: Text("${leaderboardResponse?.data.where((e) => e.id == Preference.getInt(Preference.USER_ID)).isEmpty == true ? '0' :
                          leaderboardResponse?.data.where((e) => e.id == Preference.getInt(Preference.USER_ID)).first.totalActivities} Activities"),
                          trailing: SizedBox(
                            width: width(context) * 0.18,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/coin.svg',
                                  width: width(context) * 0.07,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                //Text("${leaderboardResponse?.data.where((e) => e.id == Preference.getInt(Preference.USER_ID)).first.gScore ?? 0}"),
                                Text("${leaderboardResponse?.data.where((e) => e.id == Preference.getInt(Preference.USER_ID)).isEmpty == true ? '0'

                                    : leaderboardResponse?.data.where((e) => e.id == Preference.getInt(Preference.USER_ID)).first.gScore ?? 0}"),
                              ],
                            ),
                          ),
                        ),
                      )),
                  isLeaderboardLoading == false && leaderboardResponse
                                        ?.data.length != 0
                      ? Column(
                          children: [
                             Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(vertical: 16),
                                    child: ListView.builder(
                                        itemCount: min(0, leaderboardResponse
                                        !.data.length - 3),
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext context, int index) {
                                          index = index + 3;
                                          return userCard(name : leaderboardResponse?.data[index].name, profileImg: leaderboardResponse?.data[index].profileImage,index:  index + 1 , coin:  leaderboardResponse?.data[index].gScore, totalAct: 2);
                                        }
                                            ),
                                  ),
                            SizedBox(
                              height: 10,
                            ),

                            // userCard(
                            //     name: "Saksham",
                            //     profileImg:
                            //         leaderboardResponse?.data[0].profileImage,
                            //     index: 2,
                            //     coin: 10,
                            //     totalAct: 2),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // userCard(
                            //     name: 'Abhishek',
                            //     profileImg:
                            //         leaderboardResponse?.data[0].profileImage,
                            //     index: 3,
                            //     coin: 2,
                            //     totalAct: 2),
                          ],
                        )
                      : Container(
                        margin: EdgeInsets.only(top: height(context) * 0.4),
                        child: Text('Leaderboard Loading', style: Styles.regular(),)),
                ],
              ),
            ),
          ),
        ));
  }

  Widget userCard(
      {String? name,
      String? profileImg,
      int? index,
      dynamic coin,
      int? totalAct}) {
    return Container(
      color: ColorConstants.WHITE,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ListTile(
              leading: SizedBox(
                width: width(context) * 0.2,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("$index.",  style: Styles.semibold(size: 14),),
                    ),
                    // SizedBox(
                    //     width: 50,
                    //     height: 50,
                    //     child: SvgPicture.asset('assets/images/default_user.svg')),
                    CircleAvatar(
                        backgroundImage: NetworkImage(
                            "$profileImg")),
                  ],
                ),
              ),
              title: Text("$name", style: Styles.semibold(size: 14),),
              subtitle: Text("${totalAct ?? 0} Activities",     style: Styles.regular(size: 10, color: Color(0xff5A5F73)),),
              trailing: SizedBox(
                height: height(context) * 0.2,
                width: width(context) * 0.25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SvgPicture.asset(
                      'assets/images/coin.svg',
                      width: width(context) * 0.07,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 18),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PointHistory()));
                        },
                        child: Text(
                          "${coin ?? 0}",
                          style: Styles.semibold(size: 12),
                        ),
                      ),
                    )
                  ],
                ),
              )),
              Divider()
        ],
      ),
    );
  }

  void handleLeaderboardResponse(LeaderboardState state) {
    var leaderBoardState = state;
    setState(() {
      switch (leaderBoardState.apiState) {
        case ApiStatus.LOADING:
          Log.v("LeaderboardLoading....................");
          isLeaderboardLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("LraderboardState....................");
          // Log.v(state.response!.data!.list.toString());

          // LeaderboardResponse = state.response!.data;
          // joyContentListView = LeaderboardResponse;
          leaderboardResponse = leaderBoardState.response;

          isLeaderboardLoading = false;
          break;
        case ApiStatus.ERROR:
          isLeaderboardLoading = false;
          Log.v("Error..........................");
          Log.v(
              "ErrorHome......................${leaderBoardState.response?.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  Widget leadercard(String? image, String title, dynamic activityCount,
      dynamic coinCount, int rank) {
    String? url;
    switch (rank) {
      case 1:
        url = 'assets/images/leader_first.svg';
        break;
      case 2:
        url = 'assets/images/leader_second.svg';
        break;
      case 3:
        url = 'assets/images/leader_third.svg';
        break;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SvgPicture.asset('$url', width: rank == 1 ? 50 : 30),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  width: 3,
                  color: rank == 1
                      ? Color(0xffF2A91E)
                      : rank == 2
                          ? Color(0xffCACACA)
                          : Color(0xffE0997A))),
          child: image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: SizedBox(
                    width: rank == 1 ? 100 : 70,
                    child: Image.network(image),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: SizedBox(
                      width: rank == 1 ? 100 : 70,
                      height: rank == 1 ? 100 : 70,
                      child:
                          SvgPicture.asset('assets/images/default_user.svg'))),
        ),
        const SizedBox(
          height: 5,
        ),
        Text('$title',
            style: Styles.semibold(
              size: 12,
              color: ColorConstants.DASHBOARD_APPLY_COLOR,
            )),
        Text("Rank $rank",
            style: Styles.semibold(
              size: 12,
              color: ColorConstants.GRADIENT_RED,
            )),
        Text(
          "$activityCount Activities",
          style: Styles.regular(size: 10, color: Color(0xff5A5F73)),
        ),
        Row(
          children: [
            SvgPicture.asset(
              'assets/images/coin.svg',
              width: width(context) * 0.05,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              "$activityCount",
              style: Styles.regular(size: 12),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
