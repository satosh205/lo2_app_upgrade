import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/competition_response.dart';
import 'package:masterg/data/models/response/home_response/course_category_list_id_response.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/singularis/competition_detail.dart';
import 'package:masterg/pages/singularis/leaderboard_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:shimmer/shimmer.dart';
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
  bool? competitionLoading;
  bool? popularCompetitionLoading;

  @override
  void initState() {
    getCompetitionList();
    if (widget.fromDasboard == false) getPopularCompetitionList();

    super.initState();
  }

  void getCompetitionList() {
    BlocProvider.of<HomeBloc>(context)
        .add(CompetitionListEvent(isPopular: false));
  }

  void getPopularCompetitionList() {
    BlocProvider.of<HomeBloc>(context)
        .add(CompetitionListEvent(isPopular: true));
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
              if (state is PopularCompetitionListState) {
                _handlePopularCompetitionListResponse(state);
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
                          SizedBox(
                             width: 45,
                                height: 45,
                            child:ClipRRect(
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
                          SizedBox(width: width(context) * 0.02,),
                          Text('${Preference.getString(Preference.FIRST_NAME)}', style: Styles.bold(size: 22, color: ColorConstants.WHITE),)
                        ],
                      ),
                    ),
                  ),
                  if (widget.fromDasboard == false)
                    Container(
                      width: double.infinity,
                      height: mobileHeight * 0.25,
                      padding: EdgeInsets.only(top: 8),
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
                              left: mobileWidth * 0.08,
                              top: 8,
                              child: renderProgressBar(
                                  percent, barThickness, mobileWidth)),
                          Positioned(
                              left: mobileWidth * 0.01,
                              top: 30,
                              child: Text(
                                '50 Points',
                                style: Styles.regular(
                                    color: ColorConstants.WHITE, size: 12.5),
                              )),
                          Positioned(
                            left: mobileWidth * 0.02,
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
                              child: renderEllipse('100')),
                          Positioned(
                              left: mobileWidth * 0.66,
                              top: 3.8,
                              child: renderEllipse('150')),
                          Positioned(
                              left: mobileWidth * 0.79,
                              top: 4,
                              child: renderEllipse('200')),
                          Positioned(
                              left: mobileWidth * 0.92,
                              top: 4,
                              child: renderEllipse('250')),
                          Positioned(
                              left: 10,
                              bottom: 40,
                              child: renderTopButton(
                                'assets/images/leaderboard.png',
                                'Your rank: ',
                                '120')),
                          Positioned(
                              right: 10,
                              bottom: 40,
                              child: renderTopButton(
                                  'assets/images/coin.png', 'Points: ', '50')),
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
                        if (widget.fromDasboard == false)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Participate & Add to Your Portfolio',
                                    style: Styles.regular(
                                      color: ColorConstants.GREY_6,
                                    )),
                                InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.49,
                                              child: renderFilter(),
                                            );
                                          });
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
                                          '${Utility.ordinalDate(dateVal: "${competitionResponse?.data![index]?.endDate}")}'));
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
                            height: height(context) * 0.38,
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
                    child: Text(difficulty,
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
        Column(
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
                Text('Conducted by ',
                    style: Styles.regular(size: 10, color: Color(0xff929BA3))),
                Text(
                  companyName,
                  style: Styles.semibold(size: 12),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
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
                Text('Easy',
                    style: Styles.regular(
                        color: ColorConstants.GREEN_1, size: 12)),
                SizedBox(
                  width: 4,
                ),
                Text('•',
                    style:
                        Styles.regular(color: ColorConstants.GREY_2, size: 12)),
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
                    style:
                        Styles.regular(color: ColorConstants.GREY_2, size: 12)),
                SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.calendar_month,
                  size: 20,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  date,
                  style: Styles.regular(size: 12, color: Color(0xff5A5F73)),
                )
              ],
            )
          ],
        ),
      ]),
    );
  }

  renderTopButton(String img, String title, String value) {
    return InkWell(
      onTap: () {
         Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LeaderboardPage()));  
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
          Text(title, style: Styles.semibold(size: 14)),
          Text(value, style: Styles.semibold(size: 16)),
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

  renderFilter() {
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
              child: Text(
                'Filter by',
                style: Styles.semibold(size: 16),
              ),
            ),
            Divider(
              color: ColorConstants.GREY_4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Wrap(
                        direction: Axis.horizontal,
                        children: shimmerChips.toList()),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Wrap(
                        direction: Axis.horizontal,
                        children: shimmerChips.toList()),
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
    for (int i = 0; i < 4; i++) {
      yield Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Shimmer.fromColors(
          baseColor: Color(0xffe6e4e6),
          highlightColor: Color(0xffeaf0f3),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: Chip(
              // backgroundColor: Colors.transparent,
              label:
                  Container(width: 10, height: 10, color: ColorConstants.WHITE),
              avatar: Container(),
            ),
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
          competitionResponse = state.response;
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

  void _handlePopularCompetitionListResponse(
      PopularCompetitionListState state) {
    var popularCompetitionState = state;
    setState(() {
      switch (popularCompetitionState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          popularCompetitionLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("popularCompetitionState....................");
          popularCompetitionResponse = state.response;
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
}
