import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/onboard_sessions.dart';
import 'package:masterg/data/models/response/home_response/popular_courses_response.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/card_loader.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/gschool_widget/date_picker.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyClasses extends StatefulWidget {
  const MyClasses({Key? key}) : super(key: key);

  @override
  _MyClassesState createState() => _MyClassesState();
}

class _MyClassesState extends State<MyClasses> {
  bool isProgramListLoading = true;
  // List<MProgram> courseList1;
  List<Liveclass>? liveclassList;
  List<PopularCourses>? popularcourses;
  List<Recommended>? recommendedcourses;
  List<OtherLearners>? otherLearners;
  List<ShortTerm>? shortTerm;
  List<HighlyRated>? highlyRated;
  List<MostViewed>? mostViewed;
  DateTime selectedDate = DateTime.now();
  bool haveData = false;

  bool _isJoyCategoryLoading = true;

  Box? box;
  String selectedOption = "All";
  bool selectedCalanderView = false;

  @override
  void initState() {
    _getLiveClass();

    super.initState();
  }

  _showPopUpMenu(Offset offset) async {
    final screenSize = MediaQuery.of(context).size;
    double left = offset.dx;
    double top = offset.dy;
    double right = screenSize.width - offset.dx;
    double bottom = screenSize.height - offset.dy;

    showMenu<String>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      position: RelativeRect.fromLTRB(left, top, right, bottom),
      items: [
        PopupMenuItem<String>(
            child: Row(children: [
              SvgPicture.asset(
                'assets/images/live_icon.svg',
                width: 20,
                height: 20,
                allowDrawingOutsideViewBox: true,
              ),
              SizedBox(width: 20),
              Text('Ongoing Class')
            ]),
            value: '1'),
        PopupMenuItem<String>(
            child: Row(children: [
              SvgPicture.asset(
                'assets/images/upcoming_live.svg',
                width: 20,
                height: 20,
                allowDrawingOutsideViewBox: true,
              ),
              SizedBox(width: 20),
              Text('Upcoming Class')
            ]),
            value: '2'),
        PopupMenuItem<String>(
            child: Row(children: [
              SvgPicture.asset(
                'assets/images/completed_icon.svg',
                width: 20,
                height: 20,
                allowDrawingOutsideViewBox: true,
              ),
              SizedBox(width: 20),
              Text('Class Completed')
            ]),
            value: '3'),
        PopupMenuItem<String>(
            child: Row(children: [
              SvgPicture.asset(
                'assets/images/pending_icon.svg',
                width: 20,
                height: 20,
                allowDrawingOutsideViewBox: true,
              ),
              SizedBox(width: 20),
              Text('Class Pending')
            ]),
            value: '4'),
      ],
      elevation: 8.0,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context)!.MyClasses ?? "My Classes",
            style: Styles.bold(size: 18)),
        actions: [
          GestureDetector(
            onTapDown: (TapDownDetails detail) {
              _showPopUpMenu(detail.globalPosition);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: SvgPicture.asset(
                'assets/images/info_icon.svg',
                height: 22,
                width: 22,
                allowDrawingOutsideViewBox: true,
              ),
            ),
          )
        ],
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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LiveclassModel>(
            create: (context) => LiveclassModel([]),
          ),
        ],
        child: Consumer<LiveclassModel>(
          builder: (context, liveClassModel, child) => BlocManager(
            initState: (BuildContext context) {},
            child: BlocListener<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is getLiveClassState) {
                    _handleLiveClassResponse(state, liveClassModel);
                  }
                },
                child: !_isJoyCategoryLoading
                    ? haveData == true
                        ? _getClasses(liveClassModel)
                        : Center(
                            child: Text(
                              'No active programs for this user.',
                              style: Styles.bold(size: 16),
                            ),
                          )
                    : CardLoader()),
          ),
        ));
  }

  bool checkViewDate(startDate) {
    String startDateString =
        Utility.convertDateFromMillis(startDate, 'dd-MM-yyyy');
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(selectedDate);
    if (startDateString == formatted) {
      print('show');
      return true;
    } else {
      print('hide');
      return false;
    }
  }

  Widget _getClasses(LiveclassModel listClassModel) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    List<Liveclass>? liveClassTempList = liveclassList;
    // if (selectedCalanderView) {
    //   liveClassTempList?.sort((a, b) => a.fromDate!.compareTo(b.fromDate!));
    //   DateTime date;

    //   liveClassTempList = liveClassTempList?.where((element) {
    //     print('');
    //     date = DateTime.fromMillisecondsSinceEpoch(element.fromDate! * 1000);
    //     if (date.year >= selectedDate.year) {
    //       if (date.month >= selectedDate.month) {
    //         if (date.day >= selectedDate.day) return true;
    //       } else {
    //         return false;
    //       }
    //     } else {
    //       return false;
    //     }
    //     return false;
    //   }).toList();
    // }

    List<Liveclass>? list = [];

    String searchKey = selectedOption == 'Ongoing' ? 'Live' : selectedOption;

    if (selectedOption != 'All')
      for (var element in liveClassTempList!) {
        if (element.liveclassStatus == searchKey) {
          list.add(element);
        }
      }
    else
      list = liveClassTempList;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      listClassModel.refreshList(list!);
    });

    List<int> dateList = List.filled(listClassModel.list!.length, 0);
    // List<bool> showDates = List.filled(listClassModel.list!.length, false);

    for (int i = 0; i < listClassModel.list!.length; i++) {
      dateList[i] = int.parse(DateFormat('d').format(
          DateTime.fromMillisecondsSinceEpoch(
              listClassModel.list![i].fromDate! * 1000)));
    }
    int currentDate = 0;

    // if (dateList.length > 0) {
    //   showDates[0] = true;
    //   currentDate = dateList[0];
    // }

    // for (int i = 1; i < dateList.length - 1; i++) {
    //   if (currentDate != dateList[i]) showDates[i] = true;
    //   currentDate = dateList[i];
    // }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: ColorConstants.GREY),
      child: Column(
        children: [
          Row(
            children: [
              Text('Sort By: ', style: Styles.regular(size: 14)),
              DropdownButton<String>(
                underline: SizedBox(),
                hint: Text('$selectedOption', style: Styles.bold(size: 14)),
                items: <String>['All', 'Upcoming', 'Completed', 'Ongoing']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {
                  selectedOption = _!;

                  List<Liveclass>? list = [];
                  String searchKey =
                      selectedOption == 'Ongoing' ? 'Live' : selectedOption;
                  if (selectedOption != 'All')
                    for (var element in liveclassList!) {
                      if (element.liveclassStatus == searchKey) {
                        list.add(element);
                      }
                    }
                  else
                    list = liveclassList;

                  listClassModel.refreshList(list);
                },
              ),
              Expanded(child: SizedBox()),
              InkWell(
                onTap: () {
                  setState(() {
                    //selectedCalanderView = !selectedCalanderView;
                    selectedCalanderView = false;
                  });
                },
                child: !selectedCalanderView
                    ? SvgPicture.asset(
                        'assets/images/selected_listview.svg',
                        height: 16,
                        width: 16,
                        allowDrawingOutsideViewBox: true,
                      )
                    : SvgPicture.asset(
                        'assets/images/unselected_listview.svg',
                        height: 16,
                        width: 16,
                        allowDrawingOutsideViewBox: true,
                      ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {
                  setState(() {
                    //selectedCalanderView = !selectedCalanderView;
                    selectedCalanderView = true;
                  });
                },
                child: selectedCalanderView
                    ? SvgPicture.asset(
                        'assets/images/selected_calender.svg',
                        height: 20,
                        width: 20,
                        allowDrawingOutsideViewBox: true,
                      )
                    : SvgPicture.asset(
                        'assets/images/unselected_calender.svg',
                        height: 20,
                        width: 20,
                        allowDrawingOutsideViewBox: true,
                      ),
              )
            ],
          ),
          if (selectedCalanderView)
            Calendar(
              sendValue: (DateTime date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          listClassModel.list?.length != 0
              ? Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      int classStatus = Utility.classStatus(
                          listClassModel.list![index].fromDate!,
                          listClassModel.list![index].endDate!);

                      bool show;
                      if (selectedCalanderView) {
                        show = true;
                      } else {
                        //normal list view
                        show = !Utility.isExpired(
                            listClassModel.list![index].endDate!);
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                              visible: checkViewDate(listClassModel
                                          .list![index].fromDate!) ==
                                      true
                                  ? true
                                  : false,
                              child: Text(
                                ' ${DateFormat('EEEE').format(DateTime.fromMillisecondsSinceEpoch(listClassModel.list![index].fromDate! * 1000))}, ${DateFormat('d').format(DateTime.fromMillisecondsSinceEpoch(listClassModel.list![index].fromDate! * 1000))} ${months[int.parse(DateFormat('M').format(DateTime.fromMillisecondsSinceEpoch(listClassModel.list![index].fromDate! * 1000))) - 1]}, ${DateTime.fromMillisecondsSinceEpoch(listClassModel.list![index].fromDate! * 1000).year}',
                                style: Styles.regular(size: 14),
                              )),
                          InkWell(
                            onTap: () {
                              final DateFormat formatter =
                                  DateFormat('dd-MM-yyyy');
                              final String formatted =
                                  formatter.format(selectedDate);
                              print(
                                  'the from date  is ${listClassModel.list![index].fromDate!} and Selected date ${formatted}');
                              print(
                                  'the vlaue is ${checkViewDate(listClassModel.list![index].fromDate!)}');
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: ColorConstants.WHITE,
                                    border: Border.all(
                                        color: Colors.grey[350]!, width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      listClassModel.list![index]
                                                      .liveclassStatus!
                                                      .toLowerCase() ==
                                                  'live' ||
                                              listClassModel.list![index]
                                                      .liveclassStatus!
                                                      .toLowerCase() ==
                                                  'completed'
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                if (classStatus == 0) ...[
                                                  SvgPicture.asset(
                                                    'assets/images/live_icon.svg',
                                                    width: 20,
                                                    height: 20,
                                                    allowDrawingOutsideViewBox:
                                                        true,
                                                  )
                                                ] else if (classStatus ==
                                                    1) ...[
                                                  SvgPicture.asset(
                                                    'assets/images/empty_circle.svg',
                                                    width: 20,
                                                    height: 20,
                                                    allowDrawingOutsideViewBox:
                                                        true,
                                                  )
                                                ] else
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: ColorConstants.GREEN,
                                                    size: 20.0,
                                                  ),
                                                SizedBox(width: 5),
                                                classStatus != 2
                                                    ? Text(
                                                        listClassModel
                                                                    .list![
                                                                        index]
                                                                    .contentType!
                                                                    .toLowerCase() ==
                                                                'offlineclass'
                                                            ? 'Ongoing'
                                                            : "Live Now",
                                                        style: Styles.regular(
                                                            size: 12,
                                                            color:
                                                                ColorConstants
                                                                    .RED))
                                                    : Text(
                                                        '${listClassModel.list![index].startTime} - ${listClassModel.list![index].endTime} |${DateFormat('d').format(DateTime.fromMillisecondsSinceEpoch(listClassModel.list![index].fromDate! * 1000))} ${months[int.parse(DateFormat('M').format(DateTime.fromMillisecondsSinceEpoch(listClassModel.list![index].fromDate! * 1000))) - 1]}',
                                                        style: Styles.regular(
                                                            size: 14)),
                                                Expanded(child: SizedBox()),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: ColorConstants
                                                          .BG_GREY),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 18),
                                                  child: Text(
                                                      listClassModel
                                                                      .list![
                                                                          index]
                                                                      .contentType!
                                                                      .toLowerCase() ==
                                                                  'liveclass' ||
                                                              listClassModel
                                                                      .list![
                                                                          index]
                                                                      .contentType!
                                                                      .toLowerCase() ==
                                                                  'zoomclass'
                                                          ? "Live"
                                                          : 'Classroom',
                                                      style: Styles.regular(
                                                          size: 10,
                                                          color: ColorConstants
                                                              .BLACK)),
                                                ),
                                              ],
                                            )
                                          : listClassModel.list![index]
                                                      .liveclassStatus!
                                                      .toLowerCase() ==
                                                  'upcoming'
                                              ? Row(children: [
                                                  SvgPicture.asset(
                                                    'assets/images/upcoming_live.svg',
                                                    allowDrawingOutsideViewBox:
                                                        true,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                      '${listClassModel.list![index].startTime} - ${listClassModel.list![index].endTime} |${DateFormat('d').format(DateTime.fromMillisecondsSinceEpoch(listClassModel.list![index].fromDate! * 1000))} ${months[int.parse(DateFormat('M').format(DateTime.fromMillisecondsSinceEpoch(listClassModel.list![index].fromDate! * 1000))) - 1]}',
                                                      style: Styles.regular(
                                                          size: 14)),
                                                  Expanded(child: SizedBox()),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: ColorConstants
                                                            .BG_GREY),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 18),
                                                    child: Text(
                                                        listClassModel
                                                                        .list![
                                                                            index]
                                                                        .contentType ==
                                                                    'liveclass' ||
                                                                listClassModel
                                                                        .list![
                                                                            index]
                                                                        .contentType ==
                                                                    'zoomclass'
                                                            ? "Live"
                                                            : "Classroom",
                                                        style: Styles.regular(
                                                            size: 10,
                                                            color:
                                                                ColorConstants
                                                                    .BLACK)),
                                                  ),
                                                ])
                                              : SizedBox(),
                                      SizedBox(height: 10),
                                      Text(
                                          '${listClassModel.list![index].name}',
                                          style: Styles.semibold(size: 16)),
                                      SizedBox(height: 9),
                                      Text(
                                        '${listClassModel.list![index].description}',
                                        style: Styles.regular(size: 14),
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          listClassModel.list![index]
                                                          .trainerName !=
                                                      null &&
                                                  listClassModel.list![index]
                                                          .trainerName !=
                                                      ''
                                              ? Text(
                                                  'by ${listClassModel.list![index].trainerName} ',
                                                  style:
                                                      Styles.regular(size: 12))
                                              : Text(''),
                                          Expanded(child: SizedBox()),
                                          if (listClassModel
                                                  .list![index].liveclassStatus!
                                                  .toLowerCase() ==
                                              'live')
                                            InkWell(
                                                onTap: () {
                                                  if (listClassModel
                                                              .list![index]
                                                              .contentType!
                                                              .toLowerCase() ==
                                                          "liveclass" ||
                                                      listClassModel
                                                              .list![index]
                                                              .contentType!
                                                              .toLowerCase() ==
                                                          "zoomclass")
                                                    launchUrl(Uri.parse(
                                                        '${listClassModel.list![index].url}'));
                                                  else
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content:
                                                          Text("Coming Soon"),
                                                    ));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: listClassModel
                                                                    .list![
                                                                        index]
                                                                    .contentType!
                                                                    .toLowerCase() ==
                                                                "liveclass" ||
                                                            listClassModel
                                                                    .list![
                                                                        index]
                                                                    .contentType!
                                                                    .toLowerCase() ==
                                                                "zoomclass"
                                                        ? ColorConstants()
                                                            .primaryColor()
                                                        : ColorConstants.GREY_2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Padding(
                                                      child: Text(
                                                          listClassModel
                                                                          .list![
                                                                              index]
                                                                          .contentType!
                                                                          .toLowerCase() ==
                                                                      "liveclass" ||
                                                                  listClassModel
                                                                          .list![
                                                                              index]
                                                                          .contentType!
                                                                          .toLowerCase() ==
                                                                      "zoomclass"
                                                              ? "Join Now"
                                                              : "Mark your attendance",
                                                          style: Styles.regular(
                                                            size: 12,
                                                            color: listClassModel
                                                                            .list![
                                                                                index]
                                                                            .contentType!
                                                                            .toLowerCase() ==
                                                                        "liveclass" ||
                                                                    listClassModel
                                                                            .list![
                                                                                index]
                                                                            .contentType!
                                                                            .toLowerCase() ==
                                                                        "zoomclass"
                                                                ? ColorConstants
                                                                    .BLACK
                                                                : ColorConstants
                                                                    .GREY_3,
                                                          )),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 18,
                                                              vertical: 8)),
                                                )),
                                          if (listClassModel
                                                  .list![index].liveclassStatus!
                                                  .toLowerCase() ==
                                              'upcoming')
                                            Text('Upcoming',
                                                style:
                                                    Styles.regular(size: 12)),
                                          Visibility(
                                              child: Text('Concluded',
                                                  style:
                                                      Styles.regular(size: 12)),
                                              // child: ElevatedButton(
                                              //     style: ButtonStyle(
                                              //         foregroundColor:
                                              //             MaterialStateProperty.all<Color>(
                                              //                 Colors.white),
                                              //         backgroundColor:
                                              //             MaterialStateProperty.all<Color>(
                                              //                 ColorConstants
                                              //                     .YELLOW),
                                              //         shape: MaterialStateProperty.all<
                                              //                 RoundedRectangleBorder>(
                                              //             RoundedRectangleBorder(
                                              //                 borderRadius:
                                              //                     BorderRadius.circular(10),
                                              //                 side: BorderSide(color: ColorConstants.YELLOW)))),
                                              //     onPressed: () {
                                              //       //launch(listClassModel.list[index].url);
                                              //     },
                                              //     child: Padding(
                                              //         child: Text(
                                              //           "View Recording",
                                              //         ),
                                              //         padding: EdgeInsets.all(10))),
                                              visible: listClassModel
                                                      .list![index]
                                                      .liveclassStatus!
                                                      .toLowerCase() ==
                                                  'completed')
                                        ],
                                      )
                                    ])),
                          ),
                        ],
                      );
                    },
                    itemCount: listClassModel.list?.length ?? 0,
                    scrollDirection: Axis.vertical,
                  ),
                )
              : Center(
                  child: Text(
                    'No active programs.',
                    style: Styles.bold(size: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
        ],
      ),
    );
  }

  void _getLiveClass() {
    BlocProvider.of<HomeBloc>(context).add(getLiveClassEvent());
  }

  void _handleLiveClassResponse(getLiveClassState state, LiveclassModel model) {
    var loginState = state;
    // setState(() {
    switch (loginState.apiState) {
      case ApiStatus.LOADING:
        _isJoyCategoryLoading = true;
        break;
      case ApiStatus.SUCCESS:
        Log.v(state.response!.data!.modules!.liveclass.toString());

        liveclassList = state.response!.data!.modules!.liveclass;

        List<Liveclass>? list = [];

        String searchKey =
            selectedOption == 'Ongoing' ? 'Live' : selectedOption;

        if (selectedOption != 'All')
          for (var element in liveclassList!) {
            if (element.liveclassStatus == searchKey) {
              list.add(element);
            }
          }
        else
          list = liveclassList;
        if (list?.length == 0)
          haveData = false;
        else
          haveData = true;
        model.refreshList(list);

        _isJoyCategoryLoading = false;
        break;
      case ApiStatus.ERROR:
        _isJoyCategoryLoading = false;
        Log.v("Error..........................");
        Log.v("ErrorHome..........................${loginState.error}");
        break;
      case ApiStatus.INITIAL:
        break;
    }
    // });
  }
}
