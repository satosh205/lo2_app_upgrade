import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/ghome/widget/read_more.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_education.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:page_transition/page_transition.dart';

import '../../../data/models/response/home_response/new_portfolio_response.dart';

class EducationList extends StatefulWidget {
  final List<CommonProfession> education;
  final String? baseUrl;
  const EducationList({Key? key, required this.education, this.baseUrl})
      : super(key: key);

  @override
  State<EducationList> createState() => _EducationListState();
}

class _EducationListState extends State<EducationList> {
  bool isEducationLoading = false;
  List<CommonProfession>? education = [];

  @override
  void initState() {
    education = widget.education;
    education?.sort((a, b) => b.endDate.compareTo(a.endDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    return BlocManager(
        initState: (value) {},
        child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) async {
              if (state is SingularisDeletePortfolioState)
                handleSingularisDeletePortfolioState(state);
              if (state is PortfolioState) handleEducatoinListState(state);
            },
            child: Scaffold(
                appBar: AppBar(
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
                          await Navigator.push(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 600),
                                      reverseDuration:
                                          Duration(milliseconds: 600),
                                      type: PageTransitionType.bottomToTop,
                                      child: AddEducation()))
                              .then((value) => updateEducationList());
                        },
                        icon: Icon(
                          Icons.add,
                          color: ColorConstants.BLACK,
                        ))
                  ],
                  title: Text(
                    'Education',
                    style: Styles.bold(),
                  ),
                ),
                body: ScreenWithLoader(
                  isLoading: isEducationLoading,
                  body: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                          color: ColorConstants.WHITE,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: education?.length,
                              itemBuilder: (context, index) {
                                String startDateString =
                                    "${education?[index].startDate}";
                                String endDateString =
                                    "${education?[index].endDate}";
                                DateTime startDate = DateFormat("yyyy-MM-dd")
                                    .parse(startDateString);
                                DateTime endDate = DateFormat("yyyy-mm-dd")
                                    .parse(endDateString);
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Spacer(),
                                          InkWell(
                                              onTap: () async {
                                                AlertsWidget.showCustomDialog(
                                                    context: context,
                                                    title: '',
                                                    text:
                                                        'Are you sure you want to edit?',
                                                    icon:
                                                        'assets/images/circle_alert_fill.svg',
                                                    onOkClick: () async {
                                                      await Navigator.push(
                                                          context,
                                                          PageTransition(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      300),
                                                              reverseDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          300),
                                                              type: PageTransitionType
                                                                  .bottomToTop,
                                                              child:
                                                                  AddEducation(
                                                                education:
                                                                    education?[
                                                                        index],
                                                                isEditMode:
                                                                    true,
                                                              ))).then((value) =>
                                                          updateEducationList());
                                                    });
                                              },
                                              child: SvgPicture.asset(
                                                  'assets/images/edit_portfolio.svg')),
                                          SizedBox(
                                            width: 14,
                                          ),
                                          InkWell(
                                              onTap: () async {


                                                 AlertsWidget.showCustomDialog(
                                                    context: context,
                                                    title: '',
                                                    text:
                                                        'Are you sure you want to delete?',
                                                    icon:
                                                        'assets/images/circle_alert_fill.svg',
                                                    onOkClick: () async {
                                                      deletePortfolio(
                                                    education![index].id);
                                                    });
                                               
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/delete.svg',
                                                color: Color(0xff0E1638),
                                              )),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '${widget.baseUrl}${education?[index].imageName}',
                                                height: width(context) * 0.2,
                                                width: width(context) * 0.2,
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) {
                                                  return Container(
                                                    padding: EdgeInsets.all(14),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffD5D5D5)),
                                                    child: SvgPicture.asset(
                                                      'assets/images/default_education.svg',
                                                      height: 40,
                                                      width: 40,
                                                      color:
                                                          ColorConstants.GREY_5,
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                    ),
                                                  );
                                                },
                                                placeholder:
                                                    (BuildContext context,
                                                        loadingProgress) {
                                                  return Container(
                                                    padding: EdgeInsets.all(14),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffD5D5D5)),
                                                    child: SvgPicture.asset(
                                                      'assets/images/default_education.svg',
                                                      height: 40,
                                                      width: 40,
                                                      color:
                                                          ColorConstants.GREY_5,
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                    ),
                                                  );
                                                },
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                width: width(context) * 0.72,
                                                child: Text(
                                                  maxLines: 2,
                                                  // overflow: TextOverflow.ellipsis,
                                                  '${education?[index].title}',
                                                  style: Styles.bold(size: 14),
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              SizedBox(
                                                width: width(context) * 0.72,
                                                child: Text(
                                                  '${education?[index].institute}',
                                                  style:
                                                      Styles.regular(size: 12),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${listOfMonths[startDate.month - 1].substring(0, 3)} ${startDate.day} - ',
                                                    style: Styles.regular(
                                                        size: 14),
                                                  ),
                                                  if (education?[index]
                                                              .endDate !=
                                                          null ||
                                                      education?[index]
                                                              .endDate !=
                                                          '')
                                                    Text(
                                                      '${listOfMonths[endDate.month].substring(0, 3)} ${endDate.day}',
                                                      style: Styles.regular(
                                                          size: 14),
                                                    ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ReadMoreText(
                                        viewMore: 'View more',
                                        text:
                                            '${education?[index].description}',
                                        color: Color(0xff929BA3),
                                      ),
                                      if (index != education?.length) Divider(),
                                    ],
                                  ),
                                );
                              }))),
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
          Log.v("Loading Delete  Certificate....................");
          isEducationLoading = true;
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Delete  Certificate....................");
          isEducationLoading = false;
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Education deleted'),
            ));
          updateEducationList();
          break;
        case ApiStatus.ERROR:
          Log.v("Error Delete Certificate....................");
          isEducationLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void updateEducationList() {
    print('make api call');
    BlocProvider.of<HomeBloc>(context).add(PortfolioEvent());
  }

  void handleEducatoinListState(PortfolioState state) {
    var portfolioState = state;
    setState(() async {
      switch (portfolioState.apiState) {
        case ApiStatus.LOADING:
          Log.v("PortfolioState Loading....................");
          isEducationLoading = true;
          setState(() {});

          break;
        case ApiStatus.SUCCESS:
          Log.v("PortfolioState Success....................");
          education = portfolioState.response?.data.education;
          education?.sort((a, b) => b.endDate.compareTo(a.endDate));
          isEducationLoading = false;

          setState(() {});
          break;

        case ApiStatus.ERROR:
          isEducationLoading = false;
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
}
