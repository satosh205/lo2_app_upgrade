// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/language_response.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/main.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/ghome/home_page.dart';
// import 'package:masterg/pages/home_pages/home_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';

class LanguagePage extends StatefulWidget {
  int? languageType;
  bool isFromLogin = false;

  LanguagePage({this.languageType, this.isFromLogin = false});

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  bool _isLoading = false;
  List<ListData>? myList;
  List<Menu>? menuList;

  var localeCodes = {
    'english': "en",
    'hindi': "hi",
    'kannada': "kn",
    'marathi': "mr",
    'tamil': "ta",
    'telugu': "te",
    'bengali': "bn",
    'malyalam': 'ml'
  };

  @override
  void initState() {
    // FirebaseAnalytics().logEvent(name: "languages_screen", parameters: null);
    // FirebaseAnalytics().setCurrentScreen(screenName: "languages_screen");
    super.initState();
    _getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      // initState: (BuildContext context) {},
      listeners: [
        BlocListener<HomeBloc, HomeState>(listener: (context, state) {
          if (state is LanguageState) _handleResponse(state);
        }),
        BlocListener<HomeBloc, HomeState>(
          listener: (BuildContext context, state) {
            if (state is GetBottomBarState) _handelBottomNavigationBar(state);
          },
        ),
      ],

      child: Builder(builder: (_context) {
        return _mainContent();
      }),
    );
  }

  _mainContent() {
    return CommonContainer(
      isBackShow: false,
      bgChildColor: ColorConstants.WHITE,
      title: widget.languageType == 1
          ? Strings.of(context)?.chooseAppLanguage
          : Strings.of(context)?.chooseContentLanguage,
      isLoading: _isLoading,
      child: _isLoading ? Container() : _languageList(),
      onBackPressed: () {
        if (widget.languageType == 1 && widget.isFromLogin) {
          UserSession.userContentLanguageId = 1;
          UserSession.userAppLanguageId = 1;
          Navigator.pop(context);
          // Navigator.pushAndRemoveUntil(
          //     context, NextPageRoute(HomePage()), (route) => false);
          getBottomNavigationBar();
        }
        Navigator.pop(context);
      },
    );
  }

  _rowItem(ListData item, int index) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(
            width: 1.5,
            color: item.languageId == _getSelectedLanguage()
                ? ColorConstants.DARK_BLUE.withOpacity(0.44)
                : ColorConstants.Color_E5E5E5),
        color: item.languageId == _getSelectedLanguage()
            ? ColorConstants.DISABLE_COLOR
            : Colors.white,
      ),
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          _saveLanguage(item);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.name}',
                  style: Styles.textExtraBold(
                      size: 16, color: ColorConstants.PRIMARY_COLOR),
                ),
                Text(
                  '${item.englishName}',
                  style: Styles.textRegular(
                      size: 12, color: ColorConstants.PRIMARY_COLOR),
                ),
              ],
            ),
            CircleAvatar(
              radius: 13,
              backgroundColor: ColorConstants.DARK_BLUE,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: item.languageId == _getSelectedLanguage()
                      ? ColorConstants.PRIMARY_COLOR
                      : Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _size({double height = 20, double width = 0}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  void _getLanguage() {
    BlocProvider.of<HomeBloc>(context)
        .add(LanguageEvent(languageType: widget.languageType));
  }

  void _handleResponse(LanguageState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("UserProfileState....................");
          _isLoading = false;
          myList = state.response?.data?.listData;
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

  _languageList() {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = size.width / 2 - 90;
    final double itemWidth = size.width / 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /* Visibility(
          visible: widget.isFromLogin,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.languageType != 1
                  ? Strings.of(context).selectContentLanguage
                  : Strings.of(context).selectAppLanguage,
              style:
                  Styles.textExtraBold(size: 18, color: ColorConstants.ORANGE),
            ),
          ),
        ),
        _size(height: widget.isFromLogin ? 10 : 0),*/
        Visibility(
          visible: widget.isFromLogin,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '${Strings.of(context)?.you_can_change_langauge}',
              style: Styles.textBold(
                  size: 14, color: ColorConstants.TEXT_DARK_BLACK),
            ),
          ),
        ),
        _size(height: widget.isFromLogin ? 10 : 0),
        Expanded(
          child: GridView.builder(
            itemCount: myList?.length ?? 0,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: itemWidth / itemHeight),
            itemBuilder: (BuildContext context, int index) {
              return _rowItem(myList![index], index);
            },
          ),
        ),
      ],
    );
  }

  _getSelectedLanguage() {
    return widget.languageType == 1
        ? UserSession.userAppLanguageId
        : UserSession.userContentLanguageId;
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
          _isLoading = true;
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
            menuList?.sort((a, b) => a.inAppOrder!.compareTo(b.inAppOrder!));
            Navigator.pushAndRemoveUntil(
                context,
                NextPageRoute(
                    homePage(
                      bottomMenu: menuList,
                    ),
                    isMaintainState: true),
                (route) => false);
          }
          _isLoading = false;
          break;

        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${getBottomBarState.error}");

          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }

  _saveLanguage(ListData item) {
    setState(() {
      if (widget.languageType == 1) {
        if (!localeCodes.containsKey(item.englishName?.toLowerCase())) return;
        UserSession.userAppLanguageId = item.languageId;
        Preference.setInt(Preference.APP_LANGUAGE, item.languageId!);
        Preference.setString(Preference.LANGUAGE,
            '${localeCodes[item.englishName?.toLowerCase()]}');
        MyApp.setLocale(
            context, Locale('${localeCodes[item.englishName?.toLowerCase()]}'));
      } else {
        UserSession.userContentLanguageId = item.languageId;
        Preference.setInt(Preference.CONTENT_LANGUAGE, item.languageId!);
      }
      if (widget.isFromLogin) {
        if (widget.languageType == 1) {
          Navigator.push(
              context,
              NextPageRoute(LanguagePage(
                languageType: 2,
                isFromLogin: true,
              )));
        } else {
          Navigator.pop(context);
          getBottomNavigationBar();
        }
      }
    });
  }
}
