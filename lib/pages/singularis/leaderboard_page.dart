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
  const LeaderboardPage({Key? key,  this.fromDashboard = false, }) : super(key: key);

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
              leading:  IconButton(
                onPressed: (){Navigator.pop(context);},
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
                    child: isLeaderboardLoading == true ?  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        leadercard('Saksham', 2, 10, 2),
                        leadercard('Ajay', 2, 2, 1),
                        leadercard('Abhishek', 2, 2, 3),
                      ],
                    ) : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                         leadercard('Saksham', 2, 10, 2),
                        leadercard('Ajay', 2, 2, 1),
                        leadercard('Abhishek', 2, 2, 3),
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
                                  child: Text("1."),
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
                          title: Text("Ajay"),
                          subtitle: Text("2 Activities"),
                          trailing: SizedBox(
                            width: width(context) * 0.15,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/coin.svg',
                                  width: width(context) * 0.07,
                                ),
                                  const SizedBox(
              width: 4,
            ),
                                Text("50"),
                              ],
                            ),
                          ),
                        ),
                      )),
             isLeaderboardLoading == false ?       Column(
               children: [
                //  Container(
                //         color: Colors.white,
                //         margin: EdgeInsets.symmetric(vertical: 16),
                //         child: ListView.builder(
                //             itemCount: leaderboardResponse?.data.length,
                //             shrinkWrap: true,
                //             itemBuilder: (BuildContext context, int index) =>
                //                 userCard(name : leaderboardResponse?.data[index].name, profileImg: leaderboardResponse?.data[index].profileImage,index:  index + 1 , coin:  leaderboardResponse?.data[index].gScore, totalAct: 2)),
                //       ),
                      SizedBox(height: 10,),

                      userCard(name : "Saksham", profileImg: leaderboardResponse?.data[0].profileImage,index:  2 , coin:  10, totalAct: 2),
                      SizedBox(height: 10,),
                      userCard(name : 'Abhishek', profileImg: leaderboardResponse?.data[0].profileImage,index:  3 , coin:  2, totalAct: 2),

                      
               ],
             ) : Text('Leaderboard Loading'),
                ],
              ),
            ),
          ),
        ));
  }


  Widget userCard({String? name, String?  profileImg,  int? index, int? coin, int? totalAct}){


return Container(
  color: ColorConstants.WHITE,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ListTile(
                        leading: SizedBox(
                          width: width(context) * 0.2,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("$index."),
                              ),
                              SizedBox(
              width:  50,
              height:  50,
              child: SvgPicture.asset('assets/images/default_user.svg')),
                              // CircleAvatar(
                              //     backgroundImage: NetworkImage(
                              //         "$profileImg")),
                            ],
                          ),
                        ),
                        title: Text("$name"),
                        subtitle: Text(
                                "${totalAct ?? 0} Activities"),
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
                                padding: const EdgeInsets.only(
                                    right: 8.0, top: 18),
                                child: InkWell(
                                  onTap: () {
                                   Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PointHistory()));
                                  },
                                  child: Text(
                                    "${coin ?? 0}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                       
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
       rank == 1 ? ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: SizedBox(
                                        width: 100,
                                        child: Image.network(
                                            '${Preference.getString(Preference.PROFILE_IMAGE)}'),
                                      ),
                                    ):  ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: SizedBox(
              width: rank == 1 ? 100 : 70,
              height: rank == 1 ? 100 : 70,
              child: SvgPicture.asset('assets/images/default_user.svg'))),
        const SizedBox(
          height: 5,
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
              width: 4,
            ),
            Text("$activityCount"),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
