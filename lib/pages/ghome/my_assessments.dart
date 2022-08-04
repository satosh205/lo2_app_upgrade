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
import 'package:masterg/data/models/response/home_response/my_assessment_response.dart';
import 'package:masterg/data/providers/mg_assessment_detail_provioder.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/card_loader.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/gschool_widget/date_picker.dart';
import 'package:masterg/pages/training_pages/mg_assessment_detail.dart';
import 'package:masterg/pages/training_pages/new_screen/assessment_your_report_page.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:provider/provider.dart';

class MyAssessmentPage extends StatefulWidget {
  bool? isViewAll;

  Drawer? drawerWidget;

  MyAssessmentPage({this.isViewAll, this.drawerWidget});

  @override
  _MyAssessmentPageState createState() => _MyAssessmentPageState();
}

class _MyAssessmentPageState extends State<MyAssessmentPage> {
  List<AssessmentList>? assessmentList = [];
  var _isLoading = true;
  int? categoryId = 16;
  Box? box;

  int selectedIndex = 0;
  String selectedOption = 'All';
  bool selectedCalanderView = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    _getHomeData();
    super.initState();
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
              Text('Upcoming Quiz')
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
              Text('Quiz Completed')
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
              Text('Quiz Pending')
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
        title: Text(Strings.of(context)!.MyAssessments ?? "Daily Quiz",
            style: Styles.bold(size: 18)),
        centerTitle: false,
        backgroundColor: ColorConstants.WHITE,
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

  _mainBody() {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is MyAssessmentState) _handleAnnouncmentData(state);
          },
          child: _verticalList(),
        ));
  }

  bool checkViewDate(endDate) {
    String endDateString = Utility.convertDateFromMillis(endDate, 'dd-MM-yyyy');
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(selectedDate);
    print('chekcing date is $endDateString and selected date is $formatted');
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
              if (box.get("myassessment") == null) {
                return CardLoader();
              } else if (box.get("myassessment").isEmpty) {
                return Container(
                  height: 290,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "There are no Assessments available",
                      style: Styles.textBold(),
                    ),
                  ),
                );
              }
              print("#8Amit");
              assessmentList = box
                  .get("myassessment")
                  .map((e) =>
                      AssessmentList.fromJson(Map<String, dynamic>.from(e)))
                  .cast<AssessmentList>()
                  .toList();
              //var list = _getFilterList();
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: SingleChildScrollView(
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
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: assessmentList == null
                              ? 0
                              : assessmentList!.length,
                          itemBuilder: (context, index) {
                            return _rowItem(assessmentList![index]);
                          }),
                    ],
                  ),
                ),
              );
            },
          )
        : CardLoader();
  }

  _verticalList() {
    return _announenmentList();
  }

  _rowItem(AssessmentList item) {
    return Visibility(
      visible: (selectedOption == item.status || selectedOption == 'All') &&
          (selectedCalanderView ? checkViewDate(item.endDate) : true),
      child: InkWell(
        onTap: () {
          if (item.status?.toLowerCase() == 'upcoming')
            AlertsWidget.showCustomDialog(
                context: context,
                title: "Assessment is not ready for submission",
                text: "",
                icon: 'assets/images/circle_alert_fill.svg',
                showCancel: false,
                oKText: 'Ok',
                onOkClick: () async {
                  // Navigator.pop(context);
                });
          else if (Utility.isExpired(item.endDate!)) {
            AlertsWidget.showCustomDialog(
                context: context,
                title: "Assessment deadline is over",
                text: "",
                icon: 'assets/images/circle_alert_fill.svg',
                showCancel: false,
                oKText: 'Ok',
                onOkClick: () async {
                  // Navigator.pop(context);
                });
          } else
            Navigator.push(
                context,
                NextPageRoute(
                    ChangeNotifierProvider<MgAssessmentDetailProvider>(
                        create: (context) => MgAssessmentDetailProvider(
                            TrainingService(ApiService()), item),
                        child: MgAssessmentDetailPage()),
                    isMaintainState: true));
        },
        child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            decoration: BoxDecoration(
              color: ColorConstants.WHITE,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(alignment: Alignment.center, children: [
              Container(
                child: Row(children: [
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${item.title}',
                            style: Styles.bold(size: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.status == 'Completed') ...[
                            SizedBox(height: 5),
                            Text(
                                '${item.score}/${item.maximumMarks} Marks • ${item.attemptAllowed! - item.attemptCount!} attempts left ',
                                style: Styles.regular(
                                    size: 12, color: Colors.black)),
                            SizedBox(height: 5),
                            Text(
                                'Submit before: ${DateFormat('MM/dd/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(item.endDate! * 1000))}',
                                style: Styles.regular(size: 12))
                          ] else ...[
                            SizedBox(height: 5),
                            Text(
                                '${item.durationInMinutes} mins • ${item.maximumMarks} Marks',
                                style: Styles.regular(
                                    size: 12, color: Colors.black)),
                            SizedBox(height: 5),
                            Text(
                                'Submit before: ${DateFormat('MM/dd/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(item.endDate! * 1000))}',
                                style: Styles.regular(size: 12)),
                          ],
                        ]),
                  ),
                ]),
              ),
              Positioned(
                  right: 0,
                  // top: 100,
                  // bottom: 100,
                  child: Visibility(
                    visible: item.status == 'Completed',
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              NextPageRoute(AssessmentYourReportPage(
                                  contentId: item.contentId)));
                        },
                        child: Text('Report',
                            textAlign: TextAlign.right,
                            style: Styles.regular(
                                size: 12,
                                color: ColorConstants().primaryColor())),
                      ),
                    ),
                  ))
            ])),
      ),
    );
  }

  void _handleAnnouncmentData(MyAssessmentState state) {
    var loginState = state;
    // setState(() {
    switch (loginState.apiState) {
      case ApiStatus.LOADING:
        Log.v("Loading....................");
        break;
      case ApiStatus.SUCCESS:
        _isLoading = false;
        //_userTrack();
        assessmentList!.clear();
        /*if (state.contentType == categoryId) {
          announcementList.addAll(state.response.data.list.where((element) {
            return element.categoryId == categoryId;
          }).toList());
        }*/
        break;
      case ApiStatus.ERROR:
        _isLoading = false;
        Log.v("Error..........................");
        Log.v("ErrorAnnoucement..........................${loginState.error}");
        break;
      case ApiStatus.INITIAL:
        break;
    }
    // });
  }

  @override
  void dispose() {
    // box.close();
    super.dispose();
  }

  void _getHomeData() async {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(MyAssessmentEvent(box: box));
    setState(() {});
  }
}
