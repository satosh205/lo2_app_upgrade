import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/new_portfolio_response.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/ghome/widget/read_more.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_experience.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:page_transition/page_transition.dart';

class ExperienceList extends StatefulWidget {
  final List<CommonProfession>? experience;
  final String? baseUrl;

  const ExperienceList({Key? key, this.baseUrl, required this.experience})
      : super(key: key);

  @override
  State<ExperienceList> createState() => _ExperienceListState();
}

class _ExperienceListState extends State<ExperienceList> {
  bool isExperienceLoading = false;
  List<CommonProfession>? experience;
  List<String> listOfMonths = [
    "Janaury",
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

  @override
  void initState() {
    experience = widget.experience;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (value) {},
        child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) async {
              if (state is SingularisDeletePortfolioState)
                handleSingularisDeletePortfolioState(state);

              if (state is PortfolioState) {
                handlePortfolioState(state);
              }
            },
            child: Scaffold(
                backgroundColor: ColorConstants.WHITE,
                appBar: AppBar(
                  title: Text("Experience", style: Styles.bold()),
                  elevation: 0,
                  backgroundColor: ColorConstants.WHITE,
                  leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: ColorConstants.BLACK,
                      )),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          Navigator.push(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 600),
                                      reverseDuration:
                                          Duration(milliseconds: 600),
                                      type: PageTransitionType.bottomToTop,
                                      child: AddExperience()))
                              .then((value) => updatePortfolioList());
                        },
                        icon: Icon(
                          Icons.add,
                          color: ColorConstants.BLACK,
                        )),
                  ],
                ),
                body: ScreenWithLoader(
                  isLoading: isExperienceLoading,
                  body: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                        height: height(context) * 0.9,
                        width: width(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              itemCount: experience?.length,
                              itemBuilder: (BuildContext context, int index) {
                                String startDateString =
                                    "${experience?[index].startDate}";

                                DateTime startDate = DateFormat("yyyy-MM-dd")
                                    .parse(startDateString);

                                DateTime endDate = DateTime.now();
                                if (experience?[index].endDate != '') {
                                  String endDateString =
                                      "${experience?[index].endDate}";
                                  endDate = DateFormat("yyyy-MM-dd")
                                      .parse(endDateString);
                                }
                                String type =
                                    '${experience?[index].curricularType.replaceAll('_', '')}';
                                type =
                                    type[0].toUpperCase() + type.substring(1);

                                return Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                      "${widget.baseUrl}${experience?[index].imageName}",
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Container(
                                                          width: width(context) *
                                                              0.2,
                                                          height: width(context) *
                                                              0.2,
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  ColorConstants
                                                                      .DIVIDER,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: SvgPicture.asset(
                                                              'assets/images/extra.svg')),
                                                ),
                                              )),
                                          SizedBox(width: 6),
                                          SizedBox(
                                            width: width(context) * 0.7,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          width(context) * 0.5,
                                                      child: Text(
                                                        '${experience?[index].title}',
                                                        style: Styles.bold(
                                                            size: 16),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async{

  AlertsWidget.showCustomDialog(
                                      context: context,
                                      title: '',
                                      text: 'Are you sure you want to edit?',
                                      icon:
                                          'assets/images/circle_alert_fill.svg',
                                      onOkClick: () async {
                                        await Navigator.push(
                                            context,
                                            PageTransition(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                reverseDuration:
                                                    Duration(milliseconds: 300),
                                                type: PageTransitionType
                                                    .bottomToTop,
                                                child: AddExperience(
                                                                        isEditMode:
                                                                            true,
                                                                        experience:
                                                                            experience?[index]))).then(
                                            (value) => updatePortfolioList());
                                      });


                                                        // showModalBottomSheet(
                                                        //     shape: RoundedRectangleBorder(
                                                        //         borderRadius:
                                                        //             BorderRadius
                                                        //                 .circular(
                                                        //                     20)),
                                                        //     context: context,
                                                        //     enableDrag: true,
                                                        //     isScrollControlled:
                                                        //         true,
                                                        //     builder: (context) {
                                                        //       return FractionallySizedBox(
                                                        //         heightFactor:
                                                        //             0.7,
                                                        //         child: Container(
                                                        //             height: height(
                                                        //                 context),
                                                        //             padding:
                                                        //                 const EdgeInsets.all(
                                                        //                     8.0),
                                                        //             margin: const EdgeInsets
                                                        //                     .only(
                                                        //                 top:
                                                        //                     10),
                                                        //             child: AddExperience(
                                                        //                 isEditMode:
                                                        //                     true,
                                                        //                 experience:
                                                        //                     experience?[index])),
                                                        //       );
                                                        //     }).then((value) => updatePortfolioList());
                                                      },
                                                      child: SvgPicture.asset(
                                                          'assets/images/edit_portfolio.svg'),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    InkWell(
                                                      onTap: () {

                                                         AlertsWidget.showCustomDialog(
                                      context: context,
                                      title: '',
                                      text: 'Are you sure you want to delete?',
                                      icon:
                                          'assets/images/circle_alert_fill.svg',
                                      onOkClick: () async {
                                        deletePortfolio(widget
                                                            .experience![index]
                                                            .id);
                                      });
                                                      
                                                      },
                                                      child: SvgPicture.asset(
                                                          'assets/images/delete.svg'),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  '${experience?[index].institute}',
                                                  style:
                                                      Styles.regular(size: 14),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                            experience?[index]
                                                          .currentlyWorkHere ==
                                                      'true'
                                                  ?       Text(
                                                  '$type • ${calculateTimeDifferenceBetween(startDate, endDate)} • ${listOfMonths[startDate.month - 1].substring(0, 3)} ${startDate.day}  -  ${listOfMonths[endDate.month - 1].substring(0, 3)} ${endDate.day}',
                                                  style:
                                                      Styles.regular(size: 12),
                                                ) : Text(
                                                  '$type • ${calculateTimeDifferenceBetween(startDate, endDate)} • ${listOfMonths[startDate.month - 1].substring(0, 3)} ${startDate.day} - Present',
                                                  style:
                                                      Styles.regular(size: 12),
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
                                            '${experience?[index].description}',
                                        color: Color(0xff929BA3),
                                      ),
                                      if (index != experience?.length) Divider()
                                    ],
                                  ),
                                );
                              }),
                        )),
                  ),
                ))));
  }

  void deletePortfolio(int id) {
    BlocProvider.of<HomeBloc>(context)
        .add(SingularisDeletePortfolioEvent(portfolioId: id));
  }

  void handleSingularisDeletePortfolioState(
      SingularisDeletePortfolioState state) {
    setState(() {
      switch (state.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading Delete Experience....................");
          isExperienceLoading = true;
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Delete  Experience....................");
          isExperienceLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Experience deleted')),
          );
          updatePortfolioList();
          break;
        case ApiStatus.ERROR:
          Log.v("Error Delete Experience....................");
          isExperienceLoading = false;

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void updatePortfolioList() {
    print('make api call');
    BlocProvider.of<HomeBloc>(context).add(PortfolioEvent());
  }

  void handlePortfolioState(PortfolioState state) {
    var portfolioState = state;
    setState(() async {
      switch (portfolioState.apiState) {
        case ApiStatus.LOADING:
          Log.v("PortfolioState Loading....................");
          isExperienceLoading = true;
          setState(() {});

          break;
        case ApiStatus.SUCCESS:
          Log.v("PortfolioState Success....................");
          experience = portfolioState.response?.data.experience;
          isExperienceLoading = false;

          setState(() {});
          break;

        case ApiStatus.ERROR:
          isExperienceLoading = false;
          setState(() {});

          Log.v("PortfolioState Error..........................");
          Log.v(
              "PortfolioState Error..........................${portfolioState.error}");

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
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
        return '$month ${Strings.of(context)?.mos}';
      } else
        return '${startDate.difference(endDate).inDays.abs()} ${Strings.of(context)?.d}';
    }
  }
}
