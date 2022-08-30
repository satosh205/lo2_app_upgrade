import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/get_certificates_resp.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/notification_list_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/custom_progress_indicator.dart';

class MyCertificatesPage extends StatefulWidget {
  bool? isViewAll;

  MyCertificatesPage({this.isViewAll});

  @override
  _MyCertificatesPageState createState() => _MyCertificatesPageState();
}

class _MyCertificatesPageState extends State<MyCertificatesPage> {
  List<KpiCertificatesDatum> _getCertificatesResp = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCertificatesListData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            Log.v("Loading....................GetCoursesState build");
            if (state is GetCertificatesState) _handleAnnouncmentData(state);
          },
          child: widget.isViewAll == true ? _verticalList() : _mainBody(),
        ));
  }

  _verticalList() {
    return CommonContainer(
      isBackShow: true,
      child: _mainBody(),
      isContainerHeight: false,
      isScrollable: true,
      // scrollReverse: true,
      bgChildColor: Color.fromRGBO(238, 238, 243, 1),
      title: '${Strings.of(context)?.myCertificates}',
      isTopPadding: false,
      onBackPressed: () {
        Navigator.pop(context);
      },
      isNotification: true,
      onSkipClicked: () {
        Navigator.push(context, NextPageRoute(NotificationListPage()));
      },
      isLoading: false,
    );
  }

  _mainBody() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return ValueListenableBuilder(
      valueListenable: Hive.box(DB.ANALYTICS).listenable(),
      builder: (bc, Box box, child) {
        if (box.get("certificates") == null) {
          return CustomProgressIndicator(true, Colors.white);
        }
        //  else if (true) {
        //   return Container(
        //     height: MediaQuery.of(context).size.height,
        //     width: MediaQuery.of(context).size.width,
        //     child: Center(
        //       child: Text(
        //         "There are no certificates available",
        //         style: Styles.textBold(),
        //       ),
        //     ),
        //   );
        // }
        _getCertificatesResp = box
            .get("certificates")
            .map((e) =>
                KpiCertificatesDatum.fromJson(Map<String, dynamic>.from(e)))
            .cast<KpiCertificatesDatum>()
            .toList();
      //  _getCertificatesResp=[];    
        return Container(
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90,
                child: Stack(
                  children: [
                    Container(
                      width: screenWidth,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 235, 59, 1),
                            Color.fromRGBO(255, 213, 0, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getCertificatesResp.length} certificates',
                            style: Styles.textBold(
                              size: 20,
                              color: Color.fromRGBO(28, 37, 85, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 25,
                      top: 0,
                      child: Image.asset(
                        "assets/images/silver_medal.png",
                        width: 90,
                        height: 90,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 8),
                child: Text(
                 '${ Strings.of(context)?.Your_medals}',
                  style: Styles.textExtraBold(
                    size: 18,
                    color: Color.fromRGBO(255, 141, 41, 1),
                  ),
                ),
              ),
              SizedBox(
                height: 11,
              ),
              _getCertificatesResp.isEmpty ? Container(
            height: MediaQuery.of(context).size.height/2,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                "There are no certificates available",
                style: Styles.textBold(),
              ),
            ),
          ) :  SizedBox(
                width: screenWidth,
                child: _getList(),
              ),
              SizedBox(
                height: 400,
              ),
            ],
          ),
        );
      },
    );
  }

  void _getCertificatesListData() {
    Log.v("Loading....................GetCoursesState_getHomeData");
    BlocProvider.of<HomeBloc>(context).add(GetCertificatesEvent());
  }

  void _handleAnnouncmentData(GetCertificatesState state) {
    var loginState = state;
    // setState(() {
    switch (loginState.apiState) {
      case ApiStatus.LOADING:
        // _isLoading = true;
        Log.v("Loading....................GetCoursesState");
        break;
      case ApiStatus.SUCCESS:
        Log.v("Success....................GetCoursesState");
        // _isLoading = false;
        //_getCertificatesResp = state.response;
        break;
      case ApiStatus.ERROR:
        // _isLoading = false;
        Log.v("Error..........................GetCoursesState");
        Log.v("Error..........................${loginState.error}");
        break;
      case ApiStatus.INITIAL:
        // TODO: Handle this case.
        break;
    }
    //});
  }

  _getList() {
    final now = DateTime.now();
    return GroupedListView<dynamic, DateTime>(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      elements: _getCertificatesResp,
      groupBy: (element) => DateTime(element.year, element.month, now.day),
      groupSeparatorBuilder: (DateTime date) => Container(
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "${DateFormat("MMMM, yyyy").format(date)}",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      groupComparator: (value1, value2) => value2.compareTo(value1),
      itemBuilder: (context, dynamic element) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(235, 238, 255, 1),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 16,
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              element.certificateName ?? "",
                              style: Styles.textExtraBold(
                                size: 14,
                                color: Color.fromRGBO(28, 37, 85, 1),
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                        // Text(
                        //   "Issued " +
                        //       DateFormat('dd-MM-yyyy')
                        //           .format(element.kpiCertificateCreatedAt),
                        //   style: Styles.textExtraBold(
                        //     size: 14,
                        //     color: Color.fromRGBO(28, 37, 85, 0.7),
                        //   ),
                        //   maxLines: 2,
                        // ),
                      ],
                    ),
                    Spacer(),
                    Image.asset("assets/images/medal.png",height:50,width: 50)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // optional
      useStickyGroupSeparators: true,
      // optional
      floatingHeader: true,
      // optional
      order: GroupedListOrder.ASC, // optional
    );
    // return ListView.builder(
    //   shrinkWrap: true,
    //   itemCount: _getCertificatesResp.length,
    //   physics: NeverScrollableScrollPhysics(),
    //   itemBuilder: (ctx, index) {
    //     DateTime? issueDateObj =
    //         _getCertificatesResp[index].kpiCertificateCreatedAt;
    //     String issueDate = DateFormat('dd-MM-yyyy').format(issueDateObj!);
    //     return Container(
    //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    //       decoration: BoxDecoration(
    //         color: Color.fromRGBO(235, 238, 255, 1),
    //         borderRadius: BorderRadius.all(Radius.circular(8)),
    //       ),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Container(
    //             padding: EdgeInsets.all(8.0),
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.all(
    //                 Radius.circular(8),
    //               ),
    //               boxShadow: [
    //                 BoxShadow(
    //                   blurRadius: 16,
    //                   color: Color.fromRGBO(0, 0, 0, 0.05),
    //                 ),
    //               ],
    //             ),
    //             child: Container(
    //               padding: EdgeInsets.all(20),
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.all(Radius.circular(8)),
    //               ),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Text(
    //                         _getCertificatesResp[index].certificateName ?? "",
    //                         style: Styles.textExtraBold(
    //                           size: 14,
    //                           color: Color.fromRGBO(28, 37, 85, 1),
    //                         ),
    //                         maxLines: 2,
    //                       ),
    //                     ],
    //                   ),
    //                   Text(
    //                     "Issued " + issueDate,
    //                     style: Styles.textExtraBold(
    //                       size: 14,
    //                       color: Color.fromRGBO(28, 37, 85, 0.7),
    //                     ),
    //                     maxLines: 2,
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}
