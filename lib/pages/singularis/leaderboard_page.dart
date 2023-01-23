import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/leaderboard_resp.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:http/http.dart' as http;

import '../../data/models/response/home_response/leaderboard_resp.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  bool? isLeaderboardLoading;
  LeaderboardResponse? leaderboardResponse;

  @override
  void initState() {
    getLeaderboard();
    getLeaderboardList();
    super.initState();
  }

  void getLeaderboardList() {
    BlocProvider.of<HomeBloc>(context).add(LeaderboardEvent(
        id: 2166, type: 'competition', skipotherUser: 0, skipcurrentUser: 0));
  }

  void getLeaderboard() {
    BlocProvider.of<HomeBloc>(context).add(LeaderboardEvent(
        id: 2166, type: 'competition', skipotherUser: 0, skipcurrentUser: 0));
  }

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
              leading: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        leadercard('Lorem Ipsum', 2, 2, 2),
                        leadercard('Lorem Ipsumdolor', 2, 2, 1),
                        leadercard('Lorem Ipsum', 2, 2, 3),
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
                                  child: Text("13."),
                                ),
                                CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSa69_HGc_i3MXKCPZzCfAjBZC4bXJsn0rS0Ufe6H-ctZz5FbIVaPkd1jCPTpKwPruIT3Q&usqp=CAU")),
                              ],
                            ),
                          ),
                          title: Text("Shresth Bhadani"),
                          subtitle: Text("22 Activities"),
                          trailing: Text("800"),
                        ),
                      )),
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: ListView.builder(
                        itemCount: 2,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) =>
                            userCard('prince', index + 1, 800)),
                  ),
                ],
              ),
            ),
          ),
        ));
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

  Widget userCard(
    String name,
    int activityCount,
    int coinCount,
  ) {
    return Container(
        height: height(context) * 0.6,
        width: width(context) * 0.7,
        child: isLeaderboardLoading == false
            ? ListView.builder(
                itemCount: leaderboardResponse?.data.length,
                itemBuilder: ((context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ListTile(
                        leading: SizedBox(
                          width: width(context) * 0.2,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("${leaderboardResponse?.status}"),
                              ),
                              // https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSa69_HGc_i3MXKCPZzCfAjBZC4bXJsn0rS0Ufe6H-ctZz5FbIVaPkd1jCPTpKwPruIT3Q&usqp=CAU
                              CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "${leaderboardResponse?.data[index].profileImage}")),
                            ],
                          ),
                        ),
                        title: Text("${leaderboardResponse?.data[index].name}"),
                        subtitle: isLeaderboardLoading != true
                            ? Text(
                                "${leaderboardResponse?.data[index].totalActivities} Activities")
                            : Text("no data now"),
                        trailing: Expanded(
                          child: SizedBox(
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, top: 18),
                                  child: Text(
                                    "800",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                        // SvgPicture.asset(
                        //   'assets/images/coin.svg',
                        //   width: width(context) * 0.05,
                        // ),
                        ),
                  );
                }))
            : Text("null"));
  }

  Widget leadercard(String title, int activityCount, int coinCount, int rank) {
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
        ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: SizedBox(
              width: rank == 1 ? 100 : 50,
              height: rank == 1 ? 100 : 50,
              child: Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSa69_HGc_i3MXKCPZzCfAjBZC4bXJsn0rS0Ufe6H-ctZz5FbIVaPkd1jCPTpKwPruIT3Q&usqp=CAU"),
            )),
        const SizedBox(
          height: 10,
        ),
        Text(
          '$title',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
        Text(
          "Rank $rank",
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.red, fontSize: 20),
        ),
        Text("$activityCount Activities"),
        Row(
          children: [
            SvgPicture.asset(
              'assets/images/coin.svg',
              width: width(context) * 0.05,
            ),
            const SizedBox(
              height: 10,
            ),
            Text("$activityCount"),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
