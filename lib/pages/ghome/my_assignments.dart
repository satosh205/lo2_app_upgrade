// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_constants.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/my_assignment_response.dart';
import 'package:masterg/data/providers/my_assignment_detail_provider.dart';
import 'package:masterg/pages/custom_pages/card_loader.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/training_pages/mg_assignment_detail_page.dart';
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

  @override
  void initState() {
    // FirebaseAnalytics().logEvent(name: "annoucements_screen", parameters: null);
    // FirebaseAnalytics().setCurrentScreen(screenName: "announcements_screen");

    //_getHomeData();
    super.initState();
    _getHomeData();
    categoryId = Utility.getCategoryValue(ApiConstants.ANNOUNCEMENT_TYPE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context)!.MyAssignments ?? "My Assignments",
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
          child: _announenmentList(),
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
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  scrollDirection:
                      widget.isViewAll! ? Axis.vertical : Axis.horizontal,
                  shrinkWrap: true,
                  itemCount:
                      assignmentList == null ? 0 : assignmentList!.length,
                  itemBuilder: (context, index) {
                    return _rowItem(assignmentList![index]);
                  });
            },
          )
        : CardLoader();
  }

  _rowItem(AssignmentList item) {
    return InkWell(
        onTap: () {
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
                border: Border.all(
                    color: Colors.green, width: 1, style: BorderStyle.solid)),
            child: Row(children: [
              // Icon(
              //   Icons.circle_outlined,
              //   color: ColorConstants.BLACK,
              //   size: 20,
              // ),
              //SizedBox(width: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${item.title}', style: Styles.bold(size: 16)),
                SizedBox(height: 5),
                Text('${item.maximumMarks} marks',
                    style: Styles.regular(size: 12)),
                SizedBox(height: 5),
                Text(
                    'Submit before ${DateFormat('MM/dd/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(item.endDate! * 1000))}',
                    style: Styles.regular(size: 12)),
                /*Text('25% Completed',
                    style: Styles.textRegular(color: ColorConstants.BLACK)),*/
                SizedBox(height: 5),
              ]),
              /*Positioned(
                top: 20,
                right: 0,
                child: Icon(CupertinoIcons.forward,
                    size: 30, color: Colors.black.withOpacity(0.7)),
              ),*/
            ])));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
