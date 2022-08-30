// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/notification_resp.dart';
import 'package:masterg/data/models/request/home_request/user_tracking_activity.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
// import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';

class NotificationListPage extends StatefulWidget {
  Widget? drawerWidget;

  NotificationListPage({this.drawerWidget});

  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  var _isLoading = false;
  List<ListData>? notificationList;
  // var notificationList = <ListData>[];

  @override
  void initState() {
    // FirebaseAnalytics()
    //     .logEvent(name: "notifications_screen", parameters: null);
    // FirebaseAnalytics().setCurrentScreen(screenName: "notifications_screen");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {
        _getNotificationList();
      },
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is NotificationState) _handleNotificationLists(state);
        },
        child: Builder(builder: (_context) {
          return CommonContainer(
            child: _content(),
            isDrawerEnable: widget.drawerWidget != null,
            isBackShow: true,
            onBackPressed: () {
              Navigator.pop(context);
            },
            title: Strings.of(context)?.notifications,
            isLoading: _isLoading,
          );
        }),
      ),
    );
  }

  _rowItem(ListData item) {
    return Card(
        margin: EdgeInsets.only(bottom: 8, left: 5, right: 5, top: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        elevation: 2,
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.category ?? '',
                  style: Styles.textItalic(size: 14),
                ),
                Text(
                  item.title ?? '',
                  style: Styles.textBold(size: 16),
                ),
                Text(
                  item.description ?? '',
                  style: Styles.textRegular(size: 14),
                ),
              ]),
        ));
  }

  _content() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
          itemCount: notificationList?.length,
          padding: EdgeInsets.only(bottom: 40),
          itemBuilder: (context, index) {
            return _rowItem(notificationList![index]);
          }),
    );
  }

  void _getNotificationList() {
    BlocProvider.of<HomeBloc>(context).add(NotificationListEvent());
  }

  void _userTrack() {
    BlocProvider.of<HomeBloc>(context).add(UserTrackingActivityEvent(
        trackReq: UserTrackingActivity(
            activityType: "page_change",
            context: "",
            activityTime: DateTime.now(),
            device: 1)));
  }

  void _handleNotificationLists(NotificationState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = false;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          _isLoading = false;
          _userTrack();
          notificationList = state.response?.data?.list;
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }
}
