// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_constants.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/get_content_resp.dart';
import 'package:masterg/data/models/response/home_response/training_programs_response.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/swayam_pages/announcemnt_filter_page.dart';
import 'package:masterg/pages/swayam_pages/training_detail_page.dart';
import 'package:masterg/pages/swayam_pages/training_detail_provider.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/images.dart';
import 'package:masterg/utils/utility.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class TrainingCourses extends StatefulWidget {
  bool? isViewAll;
  List<Program>? programs;

  TrainingCourses({this.isViewAll, this.programs});

  String tags = '';

  @override
  _TrainingCoursesState createState() => _TrainingCoursesState();
}

class _TrainingCoursesState extends State<TrainingCourses> {
  List<ListData>? announcementList;
  var _isLoading = true;
  int? categoryId;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _mainBody();
  }

  _mainBody() {
    return BlocManager(
        initState: (BuildContext context) {
          categoryId = Utility.getCategoryValue(ApiConstants.ANNOUNCEMENT_TYPE);
          _getHomeData();
        },
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is AnnouncementContentState)
              _handleAnnouncmentData(state);
          },
          child: widget.isViewAll == true ? _verticalList() : _horizontalList(),
        ));
  }

  _announenmentList() {
    var list = _getFilterList();
    return widget.programs?.length == 0
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                "There are no trainings available",
                style: Styles.textBold(),
              ),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: (widget.isViewAll == true ? 0 : 20)),
            scrollDirection:
                widget.isViewAll == true ? Axis.vertical : Axis.horizontal,
            shrinkWrap: true,
            itemCount: widget.programs == null ? 0 : widget.programs?.length,
            itemBuilder: (context, index) {
              return _rowItem(widget.programs![index]);
            });
  }

  _verticalList() {
    return CommonContainer(
      child: _announenmentList(),
      isBackShow: false,
      title: Strings.of(context)?.announcements,
      onBackPressed: () {
        Navigator.pop(context);
      },
      floatIcon: Icons.filter_alt,
      isFloatIconVisible: true,
      floatIconTap: () {
        Navigator.push(context, NextPageRoute(AnnouncementFilterPage()))
            .then((value) {
          Log.v(value);
          widget.tags = value;
        });
      },
    );
  }

  Widget _rowItem(Program item) {
    return InkWell(
      onTap: () {
        Log.v(item.toJson());
           Navigator.push(
            context,
            NextPageRoute(ChangeNotifierProvider<TrainingDetailProvider>(
                create: (context) =>
                    TrainingDetailProvider(TrainingService(ApiService()), item),
                child: TrainingDetailPage())));
        // FirebaseAnalytics()
        //     .logEvent(name: "training_program_opened", parameters: null);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Container(
          margin: EdgeInsets.only(bottom: widget.isViewAll == false ? 10 : 0),
          decoration: BoxDecoration(
              color: ColorConstants.WHITE,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          width: MediaQuery.of(context).size.width /
              (widget.isViewAll == true ? 1 : 1.1),
          height: MediaQuery.of(context).size.width / 1.68,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.PLACE_HOLDER,
                        image: '${item.image}',
                        height: widget.isViewAll == true
                            ? MediaQuery.of(context).size.width / 1.68 - 60
                            : 140,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Visibility(
                      child: Image(
                        image: AssetImage(Images.PLAY_ICON),
                      ),
                    )
                  ],
                ),
              ),
              _size(height: 10, width: 0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${item.name}',
                  textAlign: TextAlign.center,
                  style: Styles.textBold(
                      size: 18, color: ColorConstants.TEXT_DARK_BLACK),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text(
                      '${Strings.of(context)?.Start_date} : ',
                      style: Styles.textSemiBold(
                          size: 12,
                          color: ColorConstants.DARK_BLUE.withOpacity(0.8)),
                    ),
                    Text(
                      Utility.convertDateFromMillis(
                          item.startDate!, Strings.REQUIRED_DATE_DD_MMM_YYYY),
                      style: Styles.textSemiBold(
                          size: 12,
                          color: ColorConstants.DARK_BLUE.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
              _size(height: 12, width: 0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Visibility(
                            visible: true,
                            child: CircularPercentIndicator(
                              radius: 40,
                              lineWidth: 2.0,
                              percent: item.completion! / 100,
                              backgroundColor: ColorConstants.GREY,
                              center: new Text(
                                "${item.completion.toString()}%",
                                style: Styles.textExtraBold(
                                    size: 12, color: ColorConstants.BLACK),
                              ),
                              progressColor: ColorConstants.ACTIVE_TAB,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${Strings.of(context)?.Completed}',
                          style: Styles.textRegular(
                            size: 10,
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _size({double height = 20, double width = 0}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  _getFilterList() {
    // Log.v("_getFilterList $selectedIndex");
    // if (widget.tags == null || widget.tags.isEmpty) return announcementList;
    // return announcementList
    //     ?.where((element) => element.tag!.contains(widget.tags))
    //     .toList();
    return announcementList;
  }

  void _handleAnnouncmentData(AnnouncementContentState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          Log.v("Su22222222ccess....................${state.contentType}");
          _isLoading = false;
          announcementList?.clear();
          print('category id is $categoryId and state id is ${state.contentType}');
          if (state.contentType == categoryId) {
            announcementList
                ?.addAll(state.response!.data!.list!.where((element) {
              return element.categoryId == categoryId;
            }).toList());
          }
          announcementList = state.response!.data!.list!;
          print('total size is ${announcementList?.length}');
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error123..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }

  void _getHomeData() {
    BlocProvider.of<HomeBloc>(context)
        .add(AnnouncementContentEvent(contentType: categoryId));
  }

  _horizontalList() {
    var list = _getFilterList();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: widget.programs!.map((item) => _rowItem(item)).toList());
  }
}
