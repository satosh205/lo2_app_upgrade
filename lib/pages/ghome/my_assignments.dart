// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_constants.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/my_assignment_response.dart';
import 'package:masterg/data/providers/my_assignment_detail_provider.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/card_loader.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/gschool_widget/date_picker.dart';
import 'package:masterg/pages/training_pages/mg_assignment_detail_page.dart';
import 'package:masterg/pages/training_pages/training_detail_page.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:provider/provider.dart';

class MyAssignmentPage extends StatefulWidget {
  bool? isViewAll;

  Drawer? drawerWidget;

  MyAssignmentPage({this.isViewAll, this.drawerWidget});

  @override
  _MyAssignmentPageState createState() => _MyAssignmentPageState();
}

class _MyAssignmentPageState extends State<MyAssignmentPage> {
  List<AssignmentList>? assignmentList = [];
  var _isLoading = true;
  int? categoryId = 16;
  Box? box;

  int selectedIndex = 0;
  String selectedOption = 'All';
  bool selectedCalanderView = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // FirebaseAnalytics().logEvent(name: "annoucements_screen", parameters: null);
    // FirebaseAnalytics().setCurrentScreen(screenName: "announcements_screen");

    //_getHomeData();
    super.initState();
    _getHomeData();
    categoryId = Utility.getCategoryValue(ApiConstants.ANNOUNCEMENT_TYPE);
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
                'assets/images/upcoming_live.svg',
                width: 20,
                height: 20,
                allowDrawingOutsideViewBox: true,
              ),
              SizedBox(width: 20),
              Text('Upcoming Assignment')
            ]),
            value: '1'),
        PopupMenuItem<String>(
            child: Row(children: [
              SvgPicture.asset(
                'assets/images/completed_icon.svg',
                width: 20,
                height: 20,
                allowDrawingOutsideViewBox: true,
              ),
              SizedBox(width: 20),
              Text('Assignment Completed')
            ]),
            value: '2'),
        PopupMenuItem<String>(
            child: Row(children: [
              SvgPicture.asset(
                'assets/images/pending_icon.svg',
                width: 20,
                height: 20,
                allowDrawingOutsideViewBox: true,
              ),
              SizedBox(width: 20),
              Text('Assignment Pending')
            ]),
            value: '3'),
      ],
      elevation: 8.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.GREY,
      appBar: AppBar(
        title: Text(Strings.of(context)!.MyAssignments ?? "My Assignments",
            style: Styles.bold(size: 18)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
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

  void _getHomeData() async {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(MyAssignmentEvent(box: box));
    setState(() {});
  }

  _mainBody() {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is MyAssignmentState) {
              _handleAnnouncmentData(state);
            }
          },
          child: SingleChildScrollView(child: _announenmentList()),
        ));
  }

  void _handleAnnouncmentData(MyAssignmentState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          //_isLoading = false;
          //_userTrack();
          assignmentList!.clear();
          print("45678456784567845678456789");
          // assignmentList = box
          //     .get("myassignment")
          //     .map((e) => AssignmentList.fromJson(Map<String, dynamic>.from(e)))
          //     .cast<AssignmentList>()
          //     .toList();
          /*if (state.contentType == categoryId) {
          announcementList.addAll(state.response.data.list.where((element) {
            return element.categoryId == categoryId;
          }).toList());
        }*/
          break;
        case ApiStatus.ERROR:
          //_isLoading = false;
          Log.v("Error..........................");
          Log.v(
              "ErrorAnnoucement..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  bool checkViewDate(endDate) {
    String endDateString = Utility.convertDateFromMillis(endDate, 'dd-MM-yyyy');
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(selectedDate);
    if (endDateString == formatted)
      return true;
    else
      return false;
  }

  _announenmentList() {
    return box != null
        ? ValueListenableBuilder(
            valueListenable: box!.listenable(),
            builder: (bc, Box box, child) {
              if (box.get("myassignment") == null) {
                return CardLoader();
              } else if (box.get("myassignment").isEmpty) {
                return Container(
                  height: 290,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "There are no Assignments available",
                      style: Styles.textBold(),
                    ),
                  ),
                );
              }
              print("#8Amit");
              assignmentList = box
                  .get("myassignment")
                  .map((e) =>
                      AssignmentList.fromJson(Map<String, dynamic>.from(e)))
                  .cast<AssignmentList>()
                  .toList();
              //var list = _getFilterList();
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Sort By: ', style: Styles.regular(size: 14)),
                        DropdownButton<String>(
                          underline: SizedBox(),
                          hint: Text('$selectedOption',
                              style: Styles.bold(size: 14)),
                          items: <String>[
                            'All',
                            'Upcoming',
                            'Completed',
                            'Pending',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {
                            setState(() {
                              selectedOption = _!;
                            });
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
                    SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ListView.builder(
                            // scrollDirection:
                            //     widget.isViewAll! ? Axis.vertical : Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: assignmentList == null
                                ? 0
                                : assignmentList!.length,
                            itemBuilder: (context, index) {
                              return _rowItem(assignmentList![index]);
                            }),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : CardLoader();
  }

  _rowItem(AssignmentList item) {
    bool show;

    if (selectedCalanderView) {
      show = true;
    } else {
      //normal list view
      show = !Utility.isExpired(item.endDate!);
    }
    return Visibility(
      visible: show
          ? (selectedOption == item.status || selectedOption == 'All') &&
              (selectedCalanderView ? checkViewDate(item.endDate) : true)
          : false,
      child: InkWell(
          onTap: () {
            if (item.status == 'Upcoming')
              AlertsWidget.showCustomDialog(
                  context: context,
                  title: "Assignment is not ready for submission",
                  text: "",
                  icon: 'assets/images/circle_alert_fill.svg',
                  showCancel: false,
                  oKText: '${Strings.of(context)?.ok}',
                  onOkClick: () async {
                    // Navigator.pop(context);
                  });
            else if (Utility.isExpired(item.endDate!)) {
              AlertsWidget.showCustomDialog(
                  context: context,
                  title: "Assignment deadline is over",
                  text: "",
                  icon: 'assets/images/circle_alert_fill.svg',
                  showCancel: false,
                  oKText: '${Strings.of(context)?.ok}',
                  onOkClick: () async {
                    // Navigator.pop(context);
                  });
            } else
              Navigator.push(
                context,
                NextPageRoute(
                    ChangeNotifierProvider<MgAssignmentDetailProvider>(
                        create: (c) => MgAssignmentDetailProvider(
                            TrainingService(ApiService()), item),
                        child: MgAssignmentDetailPage(
                          id: item.contentId,
                        )),
                    isMaintainState: true),
              );
          },
          child: Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: BoxDecoration(
                color: ColorConstants.WHITE,
                borderRadius: BorderRadius.circular(10),
                /*border: Border.all(
                      color: Colors.green, width: 1, style: BorderStyle.solid)*/
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                if (item.status == 'Completed') ...[
                  SvgPicture.asset(
                    'assets/images/completed_icon.svg',
                    width: 20,
                    height: 20,
                    allowDrawingOutsideViewBox: true,
                  ),
                ] else if (item.status == 'Upcoming') ...[
                  SvgPicture.asset(
                    'assets/images/upcoming_live.svg',
                    width: 20,
                    height: 20,
                    allowDrawingOutsideViewBox: true,
                  ),
                ] else if (item.status == 'Pending') ...[
                  SvgPicture.asset(
                    'assets/images/pending_icon.svg',
                    width: 20,
                    height: 20,
                    allowDrawingOutsideViewBox: true,
                  ),
                ],
                SizedBox(width: 20),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${item.title}', style: Styles.bold(size: 16)),
                      SizedBox(height: 5),
                      if (item.status == 'Completed') ...[
                        Text('Submitted', style: Styles.regular(size: 12)),
                        SizedBox(height: 5),
                        // Text(
                        //     '${DateFormat('MM/dd/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(item.endDate! * 1000).toUtc())}',
                        //     style: Styles.regular(size: 12)),
                        // SizedBox(height: 5),
                      ] else if (item.status == 'Upcoming') ...[
                        Text(
                            'Deadline: ${DateFormat('MM/dd/yyyy, hh:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  item.endDate! * 1000),
                            )}',
                            style: Styles.regular(size: 12)),
                        SizedBox(height: 5),
                      ] else if (item.status == 'Pending') ...[
                        Text('${item.status}',
                            style: Styles.regular(
                                size: 12,
                                color: ColorConstants().primaryColor())),
                        SizedBox(height: 5),
                      ],
                      if (item.isGraded == 1 &&
                          item.score != null &&
                          item.score != 0)
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Score earned: ',
                                  style: Styles.regular(size: 12)),
                              TextSpan(
                                text: '${item.score}',
                                style: Styles.bold(size: 12),
                              ),
                              TextSpan(
                                  text: '/${item.maximumMarks}',
                                  style: Styles.regular(size: 12)),
                            ],
                          ),
                        ),
                    ]),
              ]))),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
