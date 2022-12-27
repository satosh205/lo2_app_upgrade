import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/dashboard_content_resp.dart';
import 'package:masterg/data/models/response/auth_response/dashboard_view_resp.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/custom_progress_indicator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Box? box;
  bool? dashboardIsVisibleLoading = true;
  bool? dasboardListLoading = true;

  DashboardContentResponse? dashboardContentResponse;
  DashboardViewResponse? dashboardViewResponse;

  @override
  void initState() {
    getDashboardIsVisible();
    getDasboardList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) async {},
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                'Welcome',
                style: Styles.semibold(size: 14),
              ),
              Text(
                '${Preference.getString(Preference.FIRST_NAME)}',
                style: Styles.bold(size: 28),
              ),
              Text(
                'Begin your learning journey',
                style: Styles.regular(),
              ),
              getBody()
            ],
          )),
        ));
  }

  getBody() {
    return ValueListenableBuilder(
      valueListenable: Hive.box("content").listenable(),
      builder: (bc, Box box, child) {
        if (box.get("getDashboardIsVisible") == null) {
          // return CustomProgressIndicator(true, Colors.white);
          return Text('lading');
        } else if (box.get("getDashboardIsVisible").isEmpty) {
          return Container(
            height: 290,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                "There are no getDashboardIsVisible available",
                style: Styles.textBold(),
              ),
            ),
          );
        }

        dashboardViewResponse = box.get("getDashboardIsVisible");
        return Text('${dashboardViewResponse}');
      },
    );
  }

  void getDashboardIsVisible() {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(DashboardIsVisibleEvent());
  }

  void getDasboardList() {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(DashboardContentEvent());
  }

  void handleDashboardIsVisible(DashboardIsVisibleState state) {
    var dashboardIsVisibleState = state;
    setState(() {
      switch (dashboardIsVisibleState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          dashboardIsVisibleLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("DashboardIsVisibleState....................");
          Log.v(state.response!.data);
          dashboardViewResponse = state.response;

          dashboardIsVisibleLoading = false;
          break;
        case ApiStatus.ERROR:
          dashboardIsVisibleLoading = false;
          Log.v("Error..........................");
          Log.v(
              "Error..........................${dashboardIsVisibleState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void handleDasboardList(DashboardContentState state) {
    var dashboardContentState = state;
    setState(() {
      switch (dashboardContentState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          dasboardListLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("DashboardContentState....................");
          Log.v(state.response!.data);
          dashboardContentResponse = state.response;

          dasboardListLoading = false;
          break;
        case ApiStatus.ERROR:
          dasboardListLoading = false;
          Log.v("Error..........................");
          Log.v(
              "Error..........................${dashboardContentState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}
