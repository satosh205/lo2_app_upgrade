// ignore_for_file: unused_field

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masterg/data/models/response/home_response/course_category_list_id_response.dart';
import 'package:masterg/data/models/response/home_response/popular_courses_response.dart';
import 'package:masterg/pages/custom_pages/card_loader.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/data/models/response/home_response/onboard_sessions.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/training_pages/training_detail_page.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/data/providers/training_detail_provider.dart';

import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  // List<MProgram> courseList1;
  int nocourseAssigned = 0;
  bool? _isCourseList1Loading = true;
  List<MProgram>? courseList1;
  List<Liveclass>? liveclassList;
  List<PopularCourses>? popularcourses;
  List<Recommended>? recommendedcourses;
  List<OtherLearners>? otherLearners;
  List<ShortTerm>? shortTerm;
  List<HighlyRated>? highlyRated;
  List<MostViewed>? mostViewed;

  String? errorMessage;

  Box? box;

  @override
  void initState() {
    super.initState();
    print('loading page......');

    _getAssignedCourses();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Courses", style: Styles.bold(size: 18)),
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
          // courseCategoryList.add(state.response.data.);

          courseList1 = state.response!.data!.programs;
          print('===========${courseList1}');

          if (courseList1!.length <= 0) nocourseAssigned = 1;
          _isCourseList1Loading = false;

          break;
        case ApiStatus.ERROR:
          Log.v("Error..........................");
          Log.v(
              "Error CourseCategoryListIDState ..........................${loginState.error}");

          Log.v('the result is ${state.response?.error![0]}');

          setState(() {
            errorMessage = state.response?.error![0];
            _isCourseList1Loading = false;
          });
          courseList1 = state.response!.data!.programs;

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
    return courseList1 != null && courseList1!.length > 0
        ? Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: ColorConstants.GREY),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      // print('button is clicked');
                      Navigator.push(
                          context,
                          NextPageRoute(
                              ChangeNotifierProvider<TrainingDetailProvider>(
                                  create: (context) => TrainingDetailProvider(
                                      TrainingService(ApiService()),
                                      courseList1![index]),
                                  child: TrainingDetailPage()),
                              isMaintainState: true));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 12),
                      width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height * 0.13,
                      decoration: BoxDecoration(
                          color: ColorConstants.WHITE,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: '${courseList1![index].image}',
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
                              width: MediaQuery.of(context).size.width * 0.55,
                              //height: MediaQuery.of(context).size.height * 0.25,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                          allowDrawingOutsideViewBox: true,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('${courseList1![index].duration}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: Styles.regular(size: 10)),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                        '${courseList1![index].completionPer}% ${Strings.of(context)?.Completed}',
                                        style: Styles.regular(size: 12)),
                                    SizedBox(height: 10),
                                    Container(
                                      height: 10,
                                      width: MediaQuery.of(context).size.width *
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
                                                color: ColorConstants()
                                                    .primaryColor(),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ]),
                    ));
              },
              itemCount: courseList1?.length ?? 0,
              scrollDirection: Axis.vertical,
            ),
          )
        : _isCourseList1Loading == true
            ? CardLoader()
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
                            'You do not have any classes yet, Subscribe to a course to get started.')
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                    errorMessage ?? ' No Active Courses',
                    style: Styles.bold(size: 16),
                  ));
  }
}
