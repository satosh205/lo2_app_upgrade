// ignore_for_file: unused_field

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/course_category_list_id_response.dart';
import 'package:masterg/data/providers/training_detail_provider.dart';
import 'package:masterg/pages/custom_pages/card_loader.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/training_pages/training_detail_page.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/config.dart';

class MyCourses extends StatefulWidget {
  final fromDashboard;
  const MyCourses({Key? key, this.fromDashboard = false}) : super(key: key);

  @override
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  // List<MProgram> courseList1;
  int nocourseAssigned = 0;
  bool? _isCourseList1Loading = true;
  List<MProgram>? courseList1;

  String? errorMessage;

  Box? box;

  @override
  void initState() {
    super.initState();
    _getAssignedCourses();
  }

  Widget build(BuildContext context) {
    if (widget.fromDashboard)
      return _mainBody();
    else
      return Scaffold(
        appBar: AppBar(
          title: Text('${Strings.of(context)?.MyCourses}',
              style: Styles.bold(size: 18)),
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: _mainBody(),
      );
  }

  _mainBody() {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is CourseCategoryListIDState) {
              _handleCourseList1Response(state);
            }
          },
          child: _getCourses(),
        ));
  }

  void _handleCourseList1Response(CourseCategoryListIDState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isCourseList1Loading = true;

          break;
        case ApiStatus.SUCCESS:
          Log.v("CourseCategoryState....................");
          courseList1 = state.response!.data!.programs;
          courseList1 = courseList1
              ?.where((element) => element.isCompetition != 1)
              .toList();

          if (courseList1!.length <= 0) nocourseAssigned = 1;
          _isCourseList1Loading = false;

          break;
        case ApiStatus.ERROR:
          Log.v(
              "Error CourseCategoryListIDState ..........................${loginState.error}");
          setState(() {
            errorMessage = state.response?.error![0];
            _isCourseList1Loading = false;
          });
          courseList1 = state.response!.data!.programs;
          courseList1 = courseList1
              ?.where((element) => element.isCompetition != 1)
              .toList();
//

          if (courseList1 == null || courseList1!.length <= 0)
            nocourseAssigned = 1;

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _getAssignedCourses() {
    BlocProvider.of<HomeBloc>(context)
        .add(CourseCategoryListIDEvent(categoryId: 0));
  }

  Widget _getCourses() {
    if (APK_DETAILS['package_name'] == 'com.learn_build')
      courseList1?.sort((a, b) => a.categoryName!.compareTo(b.categoryName!));

    return courseList1 != null && courseList1!.length > 0
        ? Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: widget.fromDashboard
                    ? ColorConstants.WHITE
                    : ColorConstants.GREY),
            child: ListView.builder(
              
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (APK_DETAILS['package_name'] == 'com.learn_build')
                        if (index == 0)
                          Container(
                              margin: EdgeInsets.only(left: 9, top: 3),
                              child: Text('${courseList1![index].categoryName}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: Styles.semibold(size: 16))),
                      if (index > 0 &&
                          courseList1![index].categoryName !=
                              courseList1![index - 1].categoryName)
                        Container(
                            margin: EdgeInsets.only(left: 9, top: 12),
                            child: Text('${courseList1![index].categoryName}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: Styles.semibold(size: 16))),
                      InkWell(
                          onTap: () {
                            // print('button is clicked');
                            Navigator.push(
                                context,
                                NextPageRoute(
                                    ChangeNotifierProvider<
                                            TrainingDetailProvider>(
                                        create: (context) =>
                                            TrainingDetailProvider(
                                                TrainingService(ApiService()),
                                                courseList1![index]),
                                        child: TrainingDetailPage()),
                                    isMaintainState: true));
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(
                                top: 12,
                                right: widget.fromDashboard == true ? 10 : 0),
                            width: widget.fromDashboard
                                ? MediaQuery.of(context).size.width * 0.98
                                : MediaQuery.of(context).size.width,
                            //height: MediaQuery.of(context).size.height * 0.13,
                            decoration: BoxDecoration(
                                color: widget.fromDashboard
                                    ? ColorConstants.GREY.withOpacity(0.6)
                                    : ColorConstants.WHITE,
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (widget.fromDashboard)
                                    SizedBox(
                                      width: 120,
                                      height: 100,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '${courseList1![index].image}',
                                          width: 100,
                                          height: 120,
                                          errorWidget: (context, url, error) =>
                                              SvgPicture.asset(
                                            'assets/images/gscore_postnow_bg.svg',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
                                    //height: MediaQuery.of(context).size.height * 0.25,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('${courseList1![index].name}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: Styles.bold(size: 16)),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/clock_icon.svg',
                                                width: 15,
                                                height: 15,
                                                allowDrawingOutsideViewBox:
                                                    true,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  '${courseList1![index].duration}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                  style:
                                                      Styles.regular(size: 10)),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                              '${courseList1![index].completionPer}% ${Strings.of(context)?.Completed}',
                                              style: Styles.regular(size: 12)),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 10,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            decoration: BoxDecoration(
                                                color: ColorConstants.GREY,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: 10,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.6 *
                                                      (courseList1![index]
                                                              .completionPer! /
                                                          100),
                                                  decoration: BoxDecoration(
                                                      // color: !widget.fromDashboard
                                                      //     ? ColorConstants()
                                                      //         .primaryColor()
                                                      //     : ColorConstants.YELLOW,

                                                      color: ColorConstants
                                                          .PROGESSBAR_TEAL,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                ]),
                          )),
                    ],
                  );
                },
                itemCount: courseList1?.length ?? 0,
                scrollDirection:
                    widget.fromDashboard == true  ? Axis.horizontal : Axis.vertical),
          )
        : _isCourseList1Loading == true
            ? widget.fromDashboard
                ? ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Color(0xffe6e4e6),
                        highlightColor: Color(0xffeaf0f3),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Shimmer.fromColors(
                        baseColor: Color(0xffe6e4e6),
                        highlightColor: Color(0xffeaf0f3),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6)),
                        ),
                      )
                    ],
                  )
                : CardLoader()
            : courseList1 != null && courseList1!.length == 0
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/images/instructor_icon.svg',
                          height: 100.0,
                          width: 100.0,
                          allowDrawingOutsideViewBox: true,
                        ),
                        Text(
                            '${Strings.of(context)?.subscribeToCourseToGetStarted}')
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                    errorMessage ?? '${Strings.of(context)?.noActiveCourses}',
                    style: Styles.bold(size: 16),
                  ));
  }
}
