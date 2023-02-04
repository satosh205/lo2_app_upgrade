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
import 'package:masterg/pages/ghome/widget/read_more.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/add_extra_act.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class ExtraActivitiesList extends StatefulWidget {
  final List<CommonProfession> activities;
  final String? baseUrl;
  const ExtraActivitiesList({Key? key, required this.activities, this.baseUrl})
      : super(key: key);

  @override
  State<ExtraActivitiesList> createState() => _ExtraActivitiesListState();
}

class _ExtraActivitiesListState extends State<ExtraActivitiesList> {
  bool isActivitieLoading = false;
  List<CommonProfession>? activities;
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
activities = widget.activities;
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
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text("Extra currricular Activities",
                      style: Styles.bold()),
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
                          await showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              context: context,
                              enableDrag: true,
                              isScrollControlled: true,
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.7,
                                  child: Container(
                                      height: height(context),
                                      padding: const EdgeInsets.all(8.0),
                                      margin: const EdgeInsets.only(top: 10),
                                      child: AddActivities()),
                                );
                              }).then((value) => updatePortfolioList());
                        },
                        icon: Icon(
                          Icons.add,
                          color: ColorConstants.BLACK,
                        )),
                  ],
                ),
                body: 
            BlocManager(
          initState: (context) {},
          child: BlocListener<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is PortfolioState) {
                  handlePortfolioState(state);
                }
                if(state is SingularisDeletePortfolioState) {
   handleSingularisDeletePortfolioState(state);

                }
              },
              child:     
                ScreenWithLoader(
                  isLoading: isActivitieLoading,
                  body: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                        height: height(context) * 0.9,
                        width: width(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              itemCount: widget.activities.length,
                              itemBuilder: (BuildContext context, int index) {
                                String startDateString =
                                    "${widget.activities[index].startDate}";

                                DateTime startDate = DateFormat("yyy-MM-dd")
                                    .parse(startDateString);

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
                                          SizedBox(
                                            width: width(context) * 0.2,
                                            height: width(context) * 0.2,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${widget.baseUrl}${widget.activities[index].imageName}",
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Container(
                                                      width:
                                                          width(context) * 0.2,
                                                      height:
                                                          width(context) * 0.2,
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                          color: ColorConstants
                                                              .DIVIDER,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: SvgPicture.asset(
                                                          'assets/images/extra.svg')),
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          SizedBox(
                                            width: width(context) * 0.7,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          width(context) * 0.5,
                                                      child: Text(
                                                        '${widget.activities[index].title}',
                                                        style: Styles.bold(
                                                            size: 16),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        await showModalBottomSheet(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            context: context,
                                                            enableDrag: true,
                                                            isScrollControlled:
                                                                true,
                                                            builder: (context) {
                                                              return FractionallySizedBox(
                                                                heightFactor:
                                                                    0.7,
                                                                child:
                                                                    Container(
                                                                        height: height(
                                                                            context),
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                8.0),
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                10),
                                                                        child:
                                                                            AddActivities(
                                                                          isEditMode:
                                                                              true,
                                                                          activity:
                                                                              widget.activities[index],
                                                                        )),
                                                              );
                                                            }).then((value) => updatePortfolioList());
                                                      },
                                                      child: SvgPicture.asset(
                                                          'assets/images/edit_portfolio.svg'),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        deletePortfolio(widget
                                                            .activities[index]
                                                            .id);
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
                                                  '${widget.activities[index].institute}',
                                                  style:
                                                      Styles.regular(size: 14),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        '${widget.activities[index].curricularType} • '),
                                                    Text(
                                                      '  ${startDate.day} ${listOfMonths[startDate.month - 1]} ',
                                                      style: Styles.regular(
                                                          size: 14),
                                                    ),
                                                  ],
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
                                            '${widget.activities[index].description}',
                                        color: Color(0xff929BA3),
                                      ),
                                      if (index != widget.activities.length)
                                        Divider()
                                    ],
                                  ),
                                );
                              }),
                        )),
                  ),
                ))))));
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
          Log.v("Loading Delete Activities....................");
          isActivitieLoading = true;
          break;

        case ApiStatus.SUCCESS:
          Log.v("Success Delete  Activities....................");
          isActivitieLoading = false;
          updatePortfolioList();

          
          break;
        case ApiStatus.ERROR:
          Log.v("Error Delete Activities....................");
          isActivitieLoading = false;

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

   void updatePortfolioList(){
   BlocProvider.of<HomeBloc>(context)
                                .add(PortfolioEvent());
  }

  void handlePortfolioState(PortfolioState state) {
    var portfolioState = state;
    setState(() async {
      switch (portfolioState.apiState) {
        case ApiStatus.LOADING:
          Log.v("PortfolioState Loading....................");
                    isActivitieLoading = false;

          setState(() {});

          break;
        case ApiStatus.SUCCESS:
          Log.v("PortfolioState Success....................");
          activities = portfolioState.response?.data.extraActivities;
                   isActivitieLoading = false;


          setState(() {});
          break;

        case ApiStatus.ERROR:
                   isActivitieLoading = false;

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
