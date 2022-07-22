import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/home_response/joy_category_response.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/ghome/home_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/widget_size.dart';
import 'package:shimmer/shimmer.dart';

class InterestPage extends StatefulWidget {
  final bool? backEnable;

  InterestPage({Key? key, this.backEnable}) : super(key: key);

  @override
  State<InterestPage> createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  bool isInterestMapping = false;

  List<String>? interestMapResponse;
  List<ListElement>? programs_list;
  List<int?> selectProgramId = [];
  List<int> selectedPrograms = [];
  List<ListElement> joyCategoryList = [];
  bool isUpdating = false;
  List<Menu>? menuList;

  @override
  void initState() {
    super.initState();
    _getInterestPrograms();
  }

  void _getInterestPrograms() {
    BlocProvider.of<HomeBloc>(context).add(InterestEvent());
  }

  void _mapInterest(param) {
    BlocProvider.of<HomeBloc>(context).add(MapInterestEvent(param: param));
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (BuildContext context) {},
        child: MultiBlocListener(
            listeners: [
              BlocListener<HomeBloc, HomeState>(
                  listener: (BuildContext context, state) {
                if (state is InterestState)
                  _handleInterestProgramResponse(state);
                if (state is MapInterestState)
                  _handleMapInterestResponse(state);
              }),
              BlocListener<HomeBloc, HomeState>(
                listener: (BuildContext context, state) {
                  if (state is GetBottomBarState) {
                    _handelBottomNavigationBar(state);
                  }
                },
              ),
            ],
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: ColorConstants().primaryColor(),
                leading: BackButton(color: Colors.black),
                title: Text(
                  '${Strings.of(context)?.ChooseYourInterests}',
                  style: Styles.semibold(),
                ),
                elevation: 0,
                automaticallyImplyLeading:
                    widget.backEnable == true ? true : false,
                /*leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),*/
              ),
              body: SafeArea(
                child: ScreenWithLoader(
                  isLoading: isInterestMapping,
                  body: SingleChildScrollView(
                    child: programs_list != null
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                top: 20.0,
                                right: 20.0,
                                bottom: 20.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${Strings.of(context)?.SelectCategories}',
                                      style: Styles.bold()),
                                  SizedBox(height: 2),
                                  Text(
                                      '${Strings.of(context)?.SelectAleastSixCategories}',
                                      style: Styles.regular()),
                                  SizedBox(height: 20),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    child: Wrap(
                                        direction: Axis.horizontal,
                                        children: techChips.toList()),
                                  ),
                                  Visibility(
                                    visible: selectProgramId.length > 0,
                                    child: InkWell(
                                        onTap: () {
                                          var parameter = '';
                                          print(selectProgramId);
                                          selectProgramId.forEach((element) {
                                            parameter +=
                                                element.toString() + ',';
                                          });
                                          parameter = parameter.substring(
                                              0, parameter.length - 1);
                                          Preference.setString(
                                              'interestCategory',
                                              '${parameter}');
                                          _mapInterest(parameter);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 5.0, top: 30.0, right: 5.0),
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              WidgetSize.AUTH_BUTTON_SIZE,
                                          decoration: BoxDecoration(
                                              color: ColorConstants()
                                                  .buttonColor(),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                              child: Text(
                                                  '${Strings.of(context)?.continueStr}',
                                                  style: Styles.regular(
                                                    color: ColorConstants.BLACK,
                                                  ))),
                                        )),
                                  ),
                                ]),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Wrap(
                                direction: Axis.horizontal,
                                children: shimmerChips.toList()),
                          ),
                  ),
                ),
              ),
            )));
  }

  void _handleMapInterestResponse(MapInterestState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isInterestMapping = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          interestMapResponse = state.response!.data;
          isUpdating = true;
          isInterestMapping = true;

          _getInterestPrograms();
          // var box = Hive.box("content");
          // JoyCategoryResponse joyCategoryResponse =
          // JoyCategoryResponse.fromJson(response.body);
          // box.put("joy_category",
          //     joyCategoryList..map((e) => e.toJson()).toList());

          break;
        case ApiStatus.ERROR:
          isInterestMapping = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleInterestProgramResponse(InterestState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          if (isUpdating) {
            getBottomNavigationBar();
          } else {
            Log.v("JoyCategoryState....................");

            Log.v(state.response!.data!.list.toString());

            programs_list = state.response!.data!.list;
            final generated =
                List.generate(programs_list!.length, (index) => 0);
            selectedPrograms = generated;

            print('===== programs_list.length=======');
            print(programs_list!.length);
            for (int i = 0; i < programs_list!.length; i++) {
              if (programs_list![i].isSelected == 1) {
                joyCategoryList.add(programs_list![i]);
                setState(() {
                  selectProgramId.contains(programs_list![i].id)
                      ? selectProgramId.remove(programs_list![i].id)
                      : selectProgramId.add(programs_list![i].id);
                });
              }
            }

            // options
            // options = programs_list.map((e) => e.title);

            Log.v("JoyCategoryState Done ....................");
          }

          break;
        case ApiStatus.ERROR:
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void getBottomNavigationBar() {
    BlocProvider.of<HomeBloc>(context).add((GetBottomNavigationBarEvent()));
  }

  void _handelBottomNavigationBar(GetBottomBarState state) {
    var getBottomBarState = state;
    setState(() {
      switch (getBottomBarState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          menuList = state.response!.data!.menu;
          if (menuList?.length == 0) {
            AlertsWidget.alertWithOkBtn(
                context: context,
                text: 'App Under Maintenance!',
                onOkClick: () {
                  FocusScope.of(context).unfocus();
                });
          } else {
          menuList?.sort((a, b) => a.inAppOrder!.compareTo(b.order!));

            Navigator.pushAndRemoveUntil(
                context,
                NextPageRoute(
                    homePage(
                      bottomMenu: menuList,
                    ),
                    isMaintainState: true),
                (route) => false);
          }

          break;

        case ApiStatus.ERROR:
          Log.v("Error..........................");
          Log.v("Error..........................${getBottomBarState.error}");

          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }

  Iterable<Widget> get shimmerChips sync* {
    for (int i = 0; i < 15; i++) {
      yield Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Shimmer.fromColors(
          baseColor: Color(0xffe6e4e6),
          highlightColor: Color(0xffeaf0f3),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: Chip(
              // backgroundColor: Colors.transparent,
              label: Container(
                  width: i % 2 == 0
                      ? 30
                      : i % 2 == 0
                          ? 10
                          : 40,
                  height: 10,
                  color: ColorConstants.WHITE),
              avatar: Container(),
            ),
          ),
        ),
      );
    }
  }

  Iterable<Widget> get techChips sync* {
    for (int i = 0; i < programs_list!.length; i++)
      yield InkWell(
        onTap: () {
          if (joyCategoryList.contains(programs_list![i]))
            joyCategoryList.add(programs_list![i]);
          else
            joyCategoryList.remove(programs_list![i]);

          setState(() {
            selectProgramId.contains(programs_list![i].id)
                ? selectProgramId.remove(programs_list![i].id)
                : selectProgramId.add(programs_list![i].id);
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 10),
          child: Chip(
            backgroundColor: Colors.transparent,
            shape: StadiumBorder(
                side: BorderSide(
                    color: selectProgramId.contains(programs_list![i].id)
                        ? ColorConstants.GREEN
                        : ColorConstants.GREY_4,
                    width: 1)),
            avatar: selectProgramId.contains(programs_list![i].id)
                ? Icon(
                    Icons.check_circle,
                    color: ColorConstants.GREEN,
                    size: 20,
                  )
                : null,
            label: Text(
              '${programs_list![i].title}',
              style: Styles.regular(size: 14.22),
            ),
            // labelStyle: TextStyle(color: Colors.white),
          ),
        ),
      );
  }
}
