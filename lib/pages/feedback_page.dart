import 'dart:math';

// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
// import 'package:masterg/blocs/dealer_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/feedback_response.dart';
import 'package:masterg/pages/custom_pages/app_button.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/write_feedback_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/custom_progress_indicator.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';

class FeedBackPage extends StatefulWidget {
  bool? isViewAll;

  FeedBackPage({this.isViewAll});

  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  bool _isLoading = false;
  List<ListData>? listData;

  @override
  void initState() {
    // FirebaseAnalytics().logEvent(name: "idea_factory_screen", parameters: null);
    // FirebaseAnalytics().setCurrentScreen(screenName: "idea_factory_screen");
    getFeedbackList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _mainBody();
  }

  _feedbackDataList() {
    return ValueListenableBuilder(
      valueListenable: Hive.box(DB.CONTENT).listenable(),
      builder: (bc, Box box, child) {
        if (box.get("ideas") == null) {
          return CustomProgressIndicator(true, Colors.white);
        } else if (box.get("ideas").isEmpty) {
          return Container(
            height: 290,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                "There are no ideas available",
                style: Styles.textBold(),
              ),
            ),
          );
        }

        listData = box
            .get("ideas")
            .map((e) => ListData.fromJson(Map<String, dynamic>.from(e)))
            .cast<ListData>()
            .toList();
        return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            controller:
                new ScrollController(keepScrollOffset: widget.isViewAll!),
            itemCount:
                widget.isViewAll! ? listData?.length : min(2, listData!.length),
            itemBuilder: (context, index) {
              return _rowItem(listData![index]);
            });
      },
    );
  }

  _mainBody() {
    return BlocManager(
        initState: (BuildContext context) {
          //getFeedbackList();
        },
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is FeedbackState) _handleResponse(state);
          },
          child: widget.isViewAll! ? _verticalList() : _feedbackDataList(),
        ));
  }

  _rowItem(ListData item) {
    return Card(
        margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        elevation: 4,
        color: ColorConstants.BG_LIGHT_GREY,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.title}',
                style: Styles.textExtraBold(size: 16),
              ),
              _size(),
              Text(
                '${item.description}',
                style:
                    Styles.textBold(size: 16, color: ColorConstants.DAR_GREY),
              ),
              _size(),
              Text(
                Utility.convertDateFromMillis(item.createdAt!,
                    "${Strings.REQUIRED_DATE_HH_MM_A}, ${Strings.REQUIRED_DATE_DD_MMM_YYYY}",
                    isUTC: true),
                style: Styles.textBold(
                    size: 14, color: ColorConstants.DAR_GREY.withOpacity(0.7)),
              )
            ],
          ),
        ));
  }

  _size({double height = 20, double width = 0}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  void _handleResponse(FeedbackState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          _isLoading = false;
          listData = state.response?.data?.list;
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

  void getFeedbackList() {
    BlocProvider.of<HomeBloc>(context).add(FeedbackEvent());
  }

  _verticalList() {
    return CommonContainer(
      isBackShow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _feedbackDataList()),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(context, NextPageRoute(WriteFeedbackPage(2)));
          //   },
          //   child: Text('hhelo'),
          // )

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: AppButton(
                onTap: !forbiddenRolesList
                        .contains(UserSession.designation?.trim().toLowerCase())
                    ? () {
                        Navigator.push(
                            context, NextPageRoute(WriteFeedbackPage(2)));
                      }
                    : () {
                        print('forbidden');
                      },
                title: Strings.of(context)?.writeAnIdea),
          )
        ],
      ),
      isLoading: false,
      title: Strings.of(context)?.Idea_Factory,
      onBackPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
