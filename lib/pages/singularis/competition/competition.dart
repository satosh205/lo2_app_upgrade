import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/competition_my_activity.dart';
import 'package:masterg/data/models/response/home_response/competition_response.dart';
import 'package:masterg/data/models/response/home_response/domain_filter_list.dart';
import 'package:masterg/data/models/response/home_response/domain_list_response.dart';
import 'package:masterg/data/models/response/home_response/portfolio_competition_response.dart';
import 'package:masterg/data/models/response/home_response/top_score.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/singularis/competition/competition_detail.dart';
import 'package:masterg/pages/singularis/competition/competition_my_activity.dart';
import 'package:masterg/pages/singularis/competition/competition_navigation/competition_my_activity.dart';
import 'package:masterg/pages/singularis/leaderboard_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

import '../../user_profile_page/portfolio_create_form/portfolio_page.dart';
// import 'package:phone_verification/phone_verification.dart';

class Competetion extends StatefulWidget {
  final bool? fromDasboard;
  const Competetion({Key? key, this.fromDasboard = false}) : super(key: key);

  @override
  _CompetetionState createState() => _CompetetionState();
}

class _CompetetionState extends State<Competetion> {
  // List<MProgram>? competitionList;
  CompetitionResponse? competitionResponse, popularCompetitionResponse;
  DomainListResponse? domainList;
  DomainFilterListResponse? domainFilterList;
  PortfolioCompetitionResponse? completedCompetition;
  CompetitionMyActivityResponse? myActivity;
  TopScoringResponse? userRank;
  bool? competitionLoading;
  bool? popularCompetitionLoading;

  List<String> difficulty = ['Easy', 'Medium', 'Hard'];
  String selectedDifficulty = '';
  int selectedIndex = 0;
  String seletedIds = '';
  List<int> selectedIdList = <int>[];

  @override
  void initState() {
    topScoringUser();
    getCompetitionList(false, '');
    getDomainList();

    // if (widget.fromDasboard == false) getPopularCompetitionList();

    super.initState();
  }

  void topScoringUser() {
    BlocProvider.of<HomeBloc>(context).add(
        TopScoringUserEvent(userId: Preference.getInt(Preference.USER_ID)));
  }

  void getCompetitionList(bool isFilter, String? ids) {
    BlocProvider.of<HomeBloc>(context).add(
        CompetitionListEvent(isPopular: false, isFilter: isFilter, ids: ids));
  }

  void getDomainList() {
    BlocProvider.of<HomeBloc>(context).add(DomainListEvent());
  }

  void getFilterList(String ids) {
    BlocProvider.of<HomeBloc>(context).add(DomainFilterListEvent(ids: ids));
  }

  @override
  Widget build(BuildContext context) {
    int percent = 30;
    double barThickness = MediaQuery.of(context).size.height * 0.012;
    double mobileWidth = MediaQuery.of(context).size.width - 50;
    double mobileHeight = MediaQuery.of(context).size.height;

    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is CompetitionListState) {
                _handlecompetitionListResponse(state);
              }
              if (state is DomainListState) {
                handleDomainListResponse(state);
              }
              // if (state is DomainFilterListState) {
              //   handleDomainFilterListResponse(state);
              // }
              if (state is TopScoringUserState) {
                handletopScoring(state);
              }
            },
            child: Container(
              color: ColorConstants.WHITE,
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    width: width(context),
                    height: height(context) * 0.1,
                    decoration: BoxDecoration(
                      color: ColorConstants.WHITE,
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            Color(0xfffc7804),
                            ColorConstants.GRADIENT_RED
                          ]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: (){
                               Navigator.push(context,
                                                NextPageRoute(NewPortfolioPage()));
                            },
                            child: SizedBox(
                              width: 45,
                              height: 45,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${Preference.getString(Preference.PROFILE_IMAGE)}',
                                  filterQuality: FilterQuality.low,
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width(context) * 0.02,
                          ),
                          Text(
                            '${Preference.getString(Preference.FIRST_NAME)}',
                            style: Styles.bold(
                                size: 18, color: ColorConstants.WHITE),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (widget.fromDasboard == false)
                    Container(
                      width: double.infinity,
                      height: mobileHeight * 0.20,
                      padding: EdgeInsets.only(top: 0),
                      decoration: BoxDecoration(
                        color: ColorConstants.WHITE,
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Color(0xfffc7804),
                              ColorConstants.GRADIENT_RED
                            ]),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                              left: mobileWidth * 0.09,
                              top: 8,
                              child: renderProgressBar(
                                  percentage(userRank?.data.first.rank ?? 0), barThickness, mobileWidth)),
                          Positioned(
                              left: mobileWidth * 0.02,
                              top: 30,
                              child: Text(
                                '${userRank?.data.first.rank ?? 0} Points',
                                style: Styles.regular(
                                    color: ColorConstants.WHITE, size: 12.5),
                              )),
                          Positioned(
                            left: mobileWidth * 0.06,
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: ColorConstants.WHITE, width: 2.5)),
                              child: Image.asset('assets/images/check.png'),
                            ),
                          ),
                          Positioned(
                              left: mobileWidth * 0.59,
                              top: 8,
                              child: renderBar(barThickness, mobileWidth)),
                          Positioned(
                              left: mobileWidth * 0.72,
                              top: 8,
                              child: renderBar(barThickness, mobileWidth)),
                          Positioned(
                              left: mobileWidth * 0.85,
                              top: 8,
                              child: renderBar(barThickness, mobileWidth)),
                          Positioned(
                              left: mobileWidth * 0.97,
                              top: 8,
                              child: renderBar(barThickness, mobileWidth,
                                  fullWidth: true)),
                          Positioned(
                              left: mobileWidth * 0.53,
                              top: 4,
                              child: renderEllipse('${nextValue(userRank?.data.first.rank ?? 0, 1)}')),
                          Positioned(
                              left: mobileWidth * 0.66,
                              top: 3.8,
                              child: renderEllipse('${nextValue(userRank?.data.first.rank ?? 0, 2)}')),
                          Positioned(
                              left: mobileWidth * 0.79,
                              top: 4,
                              child: renderEllipse('${nextValue(userRank?.data.first.rank ?? 0, 3)}')),
                          Positioned(
                              left: mobileWidth * 0.92,
                              top: 4,
                              child: renderEllipse('${nextValue(userRank?.data.first.rank ?? 0, 4)}')),
                          Positioned(
                              left: 10,
                              bottom: 40,
                              child: renderTopButton(
                                  'assets/images/leaderboard.png',
                                  'Your rank: ',
                                  '${userRank?.data.first.rank ?? 0}')),
                          Positioned(
                              right: 10,
                              bottom: 40,
                              child: renderTopButton(
                                  'assets/images/coin.png',
                                  'Points: ',
                                  '${userRank?.data.first.score ?? 0}')),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 30,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: ColorConstants.WHITE,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16))),
                            ),
                          )
                        ],
                      ),
                    ),

                  //show other content
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        if ((completedCompetition != null || myActivity != null) && myActivity!.data.length +
                                        completedCompetition!.data.length > 0)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('My Activities',
                                      style: Styles.regular(
                                        size: 14,
                                        color: ColorConstants.GREY_6,
                                      )),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              reverseDuration:
                                                  Duration(milliseconds: 300),
                                              type: PageTransitionType
                                                  .bottomToTop,
                                              child: CompetitionMyActivity(
                                                completedCompetition:
                                                    completedCompetition,
                                                myActivity: myActivity,
                                              )));
                                    },
                                    child: Text('View all',
                                        style: Styles.regular(
                                          size: 12,
                                          color: ColorConstants.GRADIENT_RED,
                                        )),
                                  )
                                ],
                              ),
                      if(myActivity!.data.length +
                                        completedCompetition!.data.length > 0)        SizedBox(
                                height: height(context) * 0.16,
                                child: ListView.builder(
                                    itemCount: myActivity!.data.length +
                                        completedCompetition!.data.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      if (index < myActivity!.data.length)
                                        return CompetitionMyAcitivityCard(
                                          id: myActivity?.data[index].id,
                                          desc: myActivity?.data[index].desc,
                                          score: myActivity?.data[index].gscore,
                                          date:
                                              myActivity?.data[index].starDate,
                                          conductedBy: myActivity
                                              ?.data[index].organizedBy,
                                          image: myActivity?.data[index].pImage,
                                          title: myActivity?.data[index].name,
                                          totalAct: myActivity
                                              ?.data[index].totalContents,
                                          doneAct: myActivity?.data[index]
                                              .totalActivitiesCompleted,
                                          difficulty: myActivity
                                              ?.data[index].competitionLevel,
                                          activityStatus: myActivity
                                                  ?.data[index]
                                                  .activityStatus ??
                                              '',
                                        );
                                      else {
                                        index = index - myActivity!.data.length;
                                        return Container(
                                          margin: EdgeInsets.only(left: 8),
                                          child: CompetitionMyAcitivityCard(
                                            image: completedCompetition
                                                ?.data[0].pImage,
                                            title: completedCompetition
                                                ?.data[0].name,
                                            totalAct: completedCompetition
                                                ?.data[0].totalActivities,
                                            doneAct: completedCompetition
                                                ?.data[0].completedActivity,
                                            id: completedCompetition
                                                ?.data[0].pId,
                                            score: completedCompetition
                                                ?.data[0].gScore,
                                            desc: completedCompetition
                                                ?.data[0].desc,
                                            date: completedCompetition
                                                ?.data[0].startDate,
                                            difficulty: completedCompetition
                                                ?.data[0].competitionLevel,
                                            conductedBy: completedCompetition
                                                ?.data[0].organizedBy,
                                            activityStatus: null,
                                            rank: completedCompetition
                                                ?.data[0].rank,
                                          ),
                                        );
                                      }
                                    }),
                              )
                            ],
                          ),

                        if (widget.fromDasboard == false)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Participate & Add to Your Portfolio',
                                    style: Styles.regular(
                                      size: 14,
                                      color: ColorConstants.GREY_6,
                                    )),
                                InkWell(
                                    onTap: () async {
                                      getFilterList(domainList!.data!.list[0].id
                                          .toString());

                                      await showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return StatefulBuilder(builder:
                                                (BuildContext context,
                                                    setState) {
                                              void
                                                  handleDomainFilterListResponse(
                                                      DomainFilterListState
                                                          state) {
                                                var popularCompetitionState =
                                                    state;
                                                setState(() {
                                                  switch (
                                                      popularCompetitionState
                                                          .apiState) {
                                                    case ApiStatus.LOADING:
                                                      Log.v(
                                                          "Loading....................");
                                                      popularCompetitionLoading =
                                                          true;
                                                      break;
                                                    case ApiStatus.SUCCESS:
                                                      Log.v(
                                                          "Filter list State....................");
                                                      domainFilterList =
                                                          state.response;
                                                      popularCompetitionLoading =
                                                          false;
                                                      setState(() {});

                                                      break;
                                                    case ApiStatus.ERROR:
                                                      Log.v(
                                                          "Filter list CompetitionListIDState ..........................${popularCompetitionState.error}");
                                                      popularCompetitionLoading =
                                                          false;
                                                      break;
                                                    case ApiStatus.INITIAL:
                                                      break;
                                                  }
                                                });
                                              }

                                              return BlocListener<HomeBloc,
                                                      HomeState>(
                                                  listener: (context, state) {
                                                    if (state
                                                        is DomainFilterListState) {
                                                      handleDomainFilterListResponse(
                                                          state);
                                                    }
                                                  },
                                                  child: FractionallySizedBox(
                                                    heightFactor: 0.7,
                                                    child: Container(
                                                      height: double.infinity,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          color: ColorConstants
                                                              .WHITE,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          12),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          8))),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Center(
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: ColorConstants
                                                                        .GREY_4,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                width: 48,
                                                                height: 5,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 8),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'Filter by',
                                                                    style: Styles
                                                                        .semibold(
                                                                            size:
                                                                                16),
                                                                  ),
                                                                  Spacer(),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .close))
                                                                ],
                                                              ),
                                                            ),
                                                            Divider(
                                                              color:
                                                                  ColorConstants
                                                                      .GREY_4,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              4),
                                                                      child:
                                                                          Text(
                                                                        'Domain',
                                                                        style: Styles.bold(
                                                                            size:
                                                                                14),
                                                                      )),
                                                                  Container(
                                                                    child: Wrap(
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      children: List.generate(
                                                                          domainList!.data!.list.length,
                                                                          (i) => InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    selectedIndex = i;
                                                                                    seletedIds = '';
                                                                                    selectedIdList = [];
                                                                                  });
                                                                                  getFilterList(domainList!.data!.list[i].id.toString());
                                                                                },
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(left: 10, right: 5),
                                                                                  child: Chip(
                                                                                    backgroundColor: i == selectedIndex ? ColorConstants.GREEN : Color(0xffF2F2F2),
                                                                                    label: Container(
                                                                                      child: Text(
                                                                                        '${domainList!.data!.list[i].name}',
                                                                                        style: Styles.semibold(size: 12, color: i == selectedIndex ? ColorConstants.WHITE : ColorConstants.BLACK),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              4),
                                                                      child:
                                                                          Text(
                                                                        'Job Roles',
                                                                        style: Styles.bold(
                                                                            size:
                                                                                14),
                                                                      )),
                                                                  if (domainFilterList !=
                                                                      null)
                                                                    Container(
                                                                      child:
                                                                          Wrap(
                                                                        direction:
                                                                            Axis.horizontal,
                                                                        children: List.generate(
                                                                            domainFilterList!.data!.list.length,
                                                                            (i) => InkWell(
                                                                                  onTap: () {
                                                                                    seletedIds += domainFilterList!.data!.list[i].id.toString() + ',';
                                                                                    if (selectedIdList.contains(domainFilterList!.data!.list[i].id)) {
                                                                                      selectedIdList.remove(domainFilterList!.data!.list[i].id);
                                                                                    } else {
                                                                                      selectedIdList.add(domainFilterList!.data!.list[i].id);
                                                                                    }
                                                                                    print(selectedIdList);

                                                                                    setState(() {});
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 10, right: 5),
                                                                                    child: Chip(
                                                                                      backgroundColor: selectedIdList.contains(domainFilterList!.data!.list[i].id) ? ColorConstants.GREEN : Color(0xffF2F2F2),
                                                                                      label: Container(
                                                                                        child: Text('${domainFilterList!.data!.list[i].title}',
                                                                                            style: Styles.regular(
                                                                                              size: 12,
                                                                                              color: selectedIdList.contains(domainFilterList!.data!.list[i].id) ? ColorConstants.WHITE : ColorConstants.BLACK,
                                                                                            )),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                      ),
                                                                    ),
                                                                  Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              4),
                                                                      child:
                                                                          Text(
                                                                        'Difficulty',
                                                                        style: Styles.bold(
                                                                            size:
                                                                                14),
                                                                      )),
                                                                  Container(
                                                                    child: Wrap(
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      children: List.generate(
                                                                          difficulty.length,
                                                                          (i) => InkWell(
                                                                                onTap: () {
                                                                                  if (selectedDifficulty == difficulty[i])
                                                                                    selectedDifficulty = '';
                                                                                  else
                                                                                    selectedDifficulty = difficulty[i];
                                                                                  setState(() {});
                                                                                },
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(left: 10, right: 5),
                                                                                  child: Chip(
                                                                                    backgroundColor: selectedDifficulty == difficulty[i] ? ColorConstants.GREEN : Color(0xffF2F2F2),
                                                                                    label: Container(
                                                                                      child: Text('${difficulty[i]}',
                                                                                          style: Styles.regular(
                                                                                            size: 12,
                                                                                            color: selectedDifficulty == difficulty[i] ? ColorConstants.WHITE : ColorConstants.BLACK,
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ));
                                            });
                                          });

                                      if (selectedIdList.length == 0 &&
                                          selectedDifficulty != '') {
                                        getCompetitionList(true,
                                            '&competition_level=${selectedDifficulty.toLowerCase()}');
                                      } else if (selectedIdList.length == 0) {
                                        print('calling this');
                                        getCompetitionList(false,
                                            '&competition_level=${selectedDifficulty.toLowerCase()}');
                                      } else
                                        getCompetitionList(
                                            true,
                                            seletedIds.substring(
                                                    0, seletedIds.length - 1) +
                                                '&competition_level=${selectedDifficulty.toLowerCase()}');
                                    },
                                    child: Icon(Icons.filter_list))
                              ]),
                        competitionLoading == false
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: widget.fromDasboard == true
                                    ? min(
                                        3,
                                        int.parse(
                                            '${competitionResponse?.data?.length}'))
                                    : competitionResponse?.data?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CompetitionDetail(
                                                        competition:
                                                            competitionResponse
                                                                    ?.data?[
                                                                index])));
                                      },
                                      child: renderCompetitionCard(
                                          '${competitionResponse?.data![index]?.image ?? ''}',
                                          '${competitionResponse?.data![index]?.name ?? ''}',
                                          '${competitionResponse?.data![index]?.organizedBy ?? ''}',
                                          '${competitionResponse?.data![index]?.competitionLevel ?? 'Easy'}',
                                          '${competitionResponse?.data![index]?.gScore ?? 0}',
                                          '${Utility.ordinalDate(dateVal: "${competitionResponse?.data![index]?.startDate}")}'));
                                })
                            : Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                enabled: true,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (_, __) => Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    width: MediaQuery.of(context).size.width,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      width: double.infinity,
                                      height: 80,
                                    ),
                                  ),
                                  itemCount: 2,
                                ),
                              ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text('Most popular activities',
                                style: Styles.regular(
                                  color: ColorConstants.GREY_6,
                                ))
                          ],
                        ),

                        //
                        if (competitionLoading == false)
                          Container(
                            height: height(context) * 0.4,
                            // color: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 20),

                            // margin: EdgeInsets.only(top: 5, bottom: 10),
                            child: popularCompetitionResponse?.data?.length != 0
                                ? ListView.builder(
                                    itemCount: popularCompetitionResponse
                                        ?.data?.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CompetitionDetail(
                                                            competition:
                                                                popularCompetitionResponse
                                                                        ?.data?[
                                                                    index])));
                                          },
                                          child: renderActivityCard(
                                              '${popularCompetitionResponse?.data![index]?.image}',
                                              '${popularCompetitionResponse?.data![index]?.name}',
                                              '',
                                              '${popularCompetitionResponse?.data![index]?.competitionLevel ?? "Easy"}',
                                              '${popularCompetitionResponse?.data![index]?.gScore}',
                                              '${popularCompetitionResponse?.data![index]?.endDate}'));
                                    })
                                : Center(
                                    child: Text('No Popular Activites Found')),
                          ),
                      ],
                    ),
                  )
                ]),
              ),
            )));
  }

  renderActivityCard(String competitionImg, String name, String companyName,
      String difficulty, String gScore, String date) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: EdgeInsets.only(bottom: 20, left: 0, right: 55),
      decoration: BoxDecoration(
        color: ColorConstants.WHITE,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: competitionImg,
                  width: 100,
                  height: 120,
                  errorWidget: (context, url, error) => SvgPicture.asset(
                    'assets/images/gscore_postnow_bg.svg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
              ),
              child: Text(
                name,
                style: Styles.bold(),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5.0,
                    ),
                    child: Text(difficulty.capital(),
                        style: Styles.regular(
                            color: ColorConstants.GREEN_1, size: 12)),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text('•',
                      style: Styles.regular(
                          color: ColorConstants.GREY_2, size: 12)),
                  SizedBox(
                    width: 4,
                  ),
                  SizedBox(
                      height: 15, child: Image.asset('assets/images/coin.png')),
                  SizedBox(
                    width: 4,
                  ),
                  Text('$gScore Points',
                      style: Styles.regular(
                          color: ColorConstants.ORANGE_4, size: 12)),
                ],
              ),
            ),
          ]),
    );
  }

  renderCompetitionCard(String competitionImg, String name, String companyName,
      String difficulty, String gScore, String date) {
    return Container(
      height: 90,
      width: double.infinity,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: ColorConstants.WHITE,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Row(children: [
        SizedBox(
          width: 70,
          height: 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: competitionImg,
              width: 100,
              height: 120,
              errorWidget: (context, url, error) => SvgPicture.asset(
                'assets/images/gscore_postnow_bg.svg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width(context) * 0.6,
                child: Text(
                  name,
                  style: Styles.bold(size: 14),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  if (companyName != '')
                    Text('Conducted by ',
                        style:
                            Styles.regular(size: 10, color: Color(0xff929BA3))),
                  if (companyName != '')
                    Text(
                      companyName,
                      style: Styles.semibold(size: 12),
                    ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width * 0.4,
                  // ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xff0E1638),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text('$difficulty',
                      style: Styles.regular(
                          color: ColorConstants.GREEN_1, size: 12)),
                  SizedBox(
                    width: 4,
                  ),
                  Text('•',
                      style: Styles.regular(
                          color: ColorConstants.GREY_2, size: 12)),
                  SizedBox(
                    width: 4,
                  ),
                  SizedBox(
                      height: 15, child: Image.asset('assets/images/coin.png')),
                  SizedBox(
                    width: 4,
                  ),
                  Text('$gScore Points',
                      style: Styles.regular(
                          color: ColorConstants.ORANGE_4, size: 12)),
                  SizedBox(
                    width: 4,
                  ),
                  Text('•',
                      style: Styles.regular(
                          color: ColorConstants.GREY_2, size: 12)),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.calendar_month,
                    size: 16,
                  ),
                  SizedBox(
                    width:2,
                  ),
                  Text(
                    date,
                    style: Styles.regular(size: 12, color: Color(0xff5A5F73)),
                  )
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }

  renderTopButton(String img, String title, String value) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LeaderboardPage()));
      },
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width * 0.45,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        decoration: BoxDecoration(
            color: ColorConstants.WHITE.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          Container(
            width: 30,
            height: 30,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: ColorConstants.WHITE),
            child: Image.asset(img),
          ),
          SizedBox(
            width: 10,
          ),
          Text(title, style: Styles.regular(size: 14)),
          Text(value, style: Styles.semibold(size: 14)),
        ]),
      ),
    );
  }

  renderBar(barThickness, mobileWidth, {fullWidth = false}) {
    return Container(
        width: fullWidth ? mobileWidth : mobileWidth * 0.07,
        height: barThickness,
        color: ColorConstants.WHITE.withOpacity(0.3));
  }

  renderEllipse(String text) {
    return Column(
      children: [
        Transform.scale(
          scale: 1.35,
          child: SvgPicture.asset('assets/images/ellipse.svg'),
        ),
        SizedBox(
          height: 10,
        ),
        Text('$text',
            style: Styles.regular(color: ColorConstants.WHITE, size: 12.5))
      ],
    );
  }

  renderProgressBar(percent, barThickness, mobileWidth) {
    return Container(
      height: barThickness,
      width: mobileWidth * 0.46,
      decoration: BoxDecoration(
        color: ColorConstants.WHITE.withOpacity(0.3),
      ),
      child: Stack(
        children: [
          Container(
            height: barThickness,
            width: mobileWidth * 0.46 * (percent / 100),
            decoration: BoxDecoration(
              color: ColorConstants.YELLOW.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
            child: Opacity(
              opacity: 0.3,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                child: SvgPicture.asset(
                  'assets/images/whiteStripe.svg',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  renderFilter(int selectedIndex) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorConstants.WHITE,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(8))),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: ColorConstants.GREY_4,
                    borderRadius: BorderRadius.circular(8)),
                width: 48,
                height: 5,
                margin: EdgeInsets.only(top: 8),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Text(
                    'Filter by',
                    style: Styles.semibold(size: 16),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close))
                ],
              ),
            ),
            Divider(
              color: ColorConstants.GREY_4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Domain'),
                  ),
                  Container(
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: List.generate(
                          domainList!.data!.list.length,
                          (i) => InkWell(
                                onTap: () {
                                  getFilterList(
                                      domainList!.data!.list[i].id.toString());
                                  selectedIndex = i;
                                  setState(() {});
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  child: Chip(
                                    backgroundColor: i == selectedIndex
                                        ? ColorConstants.GREEN
                                        : Color(0xffF2F2F2),
                                    label: Container(
                                      child: Text(
                                          '${domainList!.data!.list[i].name}'),
                                    ),
                                  ),
                                ),
                              )),
                    ),
                  ),
                  Text('Job Roles'),
                  if (domainFilterList != null)
                    Container(
                      // height: MediaQuery.of(context).size.height * 0.4,
                      child: Wrap(
                        direction: Axis.horizontal,
                        // children: filterChips.toList()
                        children: List.generate(
                            domainFilterList!.data!.list.length,
                            (i) => InkWell(
                                  onTap: () {
                                    // getFilterList(domainFilterList!
                                    //     .data!.list[i].id
                                    //     .toString());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 5),
                                    child: Chip(
                                      backgroundColor: Color(0xffF2F2F2),
                                      label: Container(
                                        child: Text(
                                            '${domainFilterList!.data!.list[i].title}'),
                                      ),
                                    ),
                                  ),
                                )),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Iterable<Widget> get shimmerChips sync* {
    for (int i = 0; i < domainList!.data!.list.length; i++) {
      yield InkWell(
        onTap: () {
          setState(() {
            getFilterList(domainList!.data!.list[i].id.toString());
            Navigator.pop(context);
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 5),
          child: Chip(
            backgroundColor: Color(0xffF2F2F2),
            label: Container(
              child: Text('${domainList!.data!.list[i].name}'),
            ),
          ),
        ),
      );
    }
  }

  Iterable<Widget> get filterChips sync* {
    for (int i = 0; i < domainFilterList!.data!.list.length; i++) {
      yield InkWell(
        onTap: () {
          getFilterList(domainFilterList!.data!.list[i].id.toString());
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 5),
          child: Chip(
            backgroundColor: Color(0xffF2F2F2),
            label: Container(
              child: Text('${domainFilterList!.data!.list[i].title}'),
            ),
            // avatar: Container(),
          ),
        ),
      );
    }
  }

  void _handlecompetitionListResponse(CompetitionListState state) {
    var competitionState = state;
    setState(() {
      switch (competitionState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          competitionLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("CompetitionState....................");
          competitionResponse = state.competitonResponse;
          popularCompetitionResponse = state.popularCompetitionResponse;
          completedCompetition = state.competedCompetition;
          myActivity = state.myActivity;

          competitionLoading = false;

          break;
        case ApiStatus.ERROR:
          Log.v(
              "Error CompetitionListIDState ..........................${competitionState.error}");
          competitionLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void handleDomainListResponse(DomainListState state) {
    var popularCompetitionState = state;
    setState(() {
      switch (popularCompetitionState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          popularCompetitionLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("popularCompetitionState....................");
          domainList = state.response;
          popularCompetitionLoading = false;

          break;
        case ApiStatus.ERROR:
          Log.v(
              "Error Popular CompetitionListIDState ..........................${popularCompetitionState.error}");
          popularCompetitionLoading = false;
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
          popularCompetitionLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("PortfolioState Competition Success....................");

          userRank = portfolioState.response;
          Preference.setString(
              Preference.FIRST_NAME, '${userRank?.data.first.name}');
          Preference.setString(
              Preference.PROFILE_IMAGE, '${userRank?.data.first.profileImage}');

          popularCompetitionLoading = false;
          setState(() {});
          break;

        case ApiStatus.ERROR:
          popularCompetitionLoading = false;
          Log.v("PortfolioState Error..........................");
          Log.v(
              "PortfolioState Error..........................${portfolioState.error}");

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  int nextValue(int c, int n){
    int x = 50 - (c % 50);
    c = (x + c) * n;
    return c;
  }
  double percentage(int c){
    int h = nextValue(c, 1);
    int l = h - 50;
    double result =  ((c - l)  * 100) / 50;
    print('Api - URL: https://singularis.lea $result');
    return result;


  }
}





extension on String {
  String capital() {
    return this[0].toUpperCase() + this.substring(1);
  }
}