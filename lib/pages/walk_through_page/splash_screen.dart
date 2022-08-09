import 'dart:math';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/blocs/auth_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/utils/config.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/bottombar_response.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/ghome/home_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../auth_pages/choose_language.dart';
import '../preboarding_pages/proboarding_page.dart';

class EntryAnimationPage extends StatefulWidget {
  const EntryAnimationPage({Key? key}) : super(key: key);

  @override
  _EntryAnimationPageState createState() => _EntryAnimationPageState();
}

class _EntryAnimationPageState extends State<EntryAnimationPage> {
  /// Random instance
  final random = Random();
  List<Menu>? menuList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/images/splash/${APK_DETAILS['splash_image']}';
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocManager(
            initState: (BuildContext context) {
              _getAppVersion();
            },
            child: MultiBlocListener(
              listeners: [
                BlocListener<AuthBloc, AuthState>(
                  listener: (BuildContext context, state) {
                    if (state is AppVersionState) _handleResponse(state);
                  },
                ),
                BlocListener<HomeBloc, HomeState>(
                  listener: (BuildContext context, state) {
                    if (state is GetBottomBarState) {
                      _handelBottomNavigationBar(state);
                    }
                  },
                ),
              ],
              child: Center(
                child: Stack(
                  children: [
                    Entry.scale(
                      delay: Duration(seconds: 1),
                      duration: Duration(seconds: 1),
                      scale: 0,
                      child: CustomCard("Entry.scale()"),
                    ),
                    // _logo(),
                    imagePath.split('.').last == 'svg'
                        ? SvgPicture.asset(
                            imagePath,
                            height: 150,
                            width: 150,
                            allowDrawingOutsideViewBox: true,
                          )
                        : Image.asset(
                            imagePath,
                            height: 150,
                            width: 150,
                          ),
                  ],
                ),
              ),
            )));
  }

  void _getAppVersion() {
    BlocProvider.of<AuthBloc>(context)
        .add(AppVersionEvent(deviceType: Utility.getDeviceType().toString()));
  }

  void _handleResponse(AppVersionState state) {
    var loginState = state;
    setState(() async {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
            String appName = packageInfo.appName;
            String packageName = packageInfo.packageName;
            String version = packageInfo.version;
            String buildNumber = packageInfo.buildNumber;
            Log.v(
                "buildNumber: $buildNumber, appName : $appName, packageName: $packageName, version : $version");
            if (isUpdateAvailable(state, buildNumber)) {
              if (state.response!.data!.updateType == 2) {
                AlertsWidget.showCustomDialog(
                    context: context,
                    title: '',
                    text: Strings.of(context)!.updateVersionText2,
                    icon: 'assets/images/circle_alert_fill.svg',
                    oKText: '${Strings.of(context)?.ok}',
                    showCancel: false,
                    onOkClick: () async {
                      launchUrl(Uri.parse(
                          'https://play.google.com/store/apps/details?id=com.at.masterg'));

                      _moveToNext();
                    });
              } else if (Preference.getBool(_getUpdateKey(), def: true)!) {
                Preference.setBool(_getUpdateKey(), false);

                AlertsWidget.showCustomDialog(
                    context: context,
                    title: Strings.of(context)!.updateVersionTitle,
                    text: Strings.of(context)!.updateVersionText1,
                    icon: 'assets/images/circle_alert_fill.svg',
                    oKText: '${Strings.of(context)?.ok}',
                    showCancel: true,
                    onOkClick: () {
                      launchUrl(Uri.parse(
                          'https://play.google.com/store/apps/details?id=com.at.masterg'));

                      _moveToNext();
                    },
                    onCancelClick: () {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        _moveToNext();
                      });
                    });

                AlertsWidget.alertWithOkCancelBtn(
                    context: context,
                    title: Strings.of(context)!.updateVersionTitle,
                    text: Strings.of(context)!.updateVersionText1,
                    onOkClick: () {
                      //_launchURL();

                      _moveToNext();
                    },
                    onCancelClick: () {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        _moveToNext();
                      });
                    });
              } else {
                _moveToNext();
              }
            } else {
              print("calling setupRemoteConfig();");

              _moveToNext();
            }
          });

          break;
        case ApiStatus.ERROR:
          Log.v("Error..........................${loginState.error}");

          _moveToNext();
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  bool isUpdateAvailable(AppVersionState state, String buildNumber) {
    int vNumber = int.parse(buildNumber);
    int serverNumber = int.parse(state.response!.data!.latestVersion!);
    return vNumber < serverNumber;
  }

  _getUpdateKey() {
    return "${Preference.APP_LANGUAGE}_${Utility.convertDateFormat(DateTime.now())}";
  }

  void getBottomNavigationBar() {
    BlocProvider.of<HomeBloc>(context).add((GetBottomNavigationBarEvent()));
  }

  void _handelBottomNavigationBar(GetBottomBarState state) {
    var getBottomBarState = state;
    setState(() async {
      switch (getBottomBarState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");
          menuList = state.response?.data?.menu;
          if (menuList?.length == 0) {
            AlertsWidget.alertWithOkBtn(
                context: context,
                text: 'App Under Maintenance!',
                onOkClick: () {
                  FocusScope.of(context).unfocus();
                });
          } else {
            menuList?.sort((a, b) => a.inAppOrder!.compareTo(b.order!));
//time of splash screen
            await Future.delayed(Duration(seconds: 2));

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
          break;
      }
    });
  }

  Future<void> _moveToNext() async {
    if (Preference.getString(Preference.USER_TOKEN) != null) {
      if (UserSession.userAppLanguageId == 0 ||
          UserSession.userContentLanguageId == 0) {
        getBottomNavigationBar();
      } else {
        getBottomNavigationBar();
      }
    } else {
      if (APK_DETAILS["enable_boarding_screen"] == "0") {
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushAndRemoveUntil(
            context, NextPageRoute(ChooseLanguage()), (route) => false);
      } else {
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushAndRemoveUntil(
            context, NextPageRoute(PreBoardingPage()), (route) => false);
      }
    }
  }
}

class CustomCard extends StatefulWidget {
  const CustomCard(this.label, {Key? key}) : super(key: key);
  final String label;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  String PLAYSTORE_URL =
      "https://play.google.com/store/apps/details?id=com.at.iexcel&hl=en_IN&gl=US";
  String APPSTORE_URL =
      "https://apps.apple.com/us/app/perfetti-swayam/id1564653137";
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Transform.scale(
        scale: 30,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: ColorConstants().primaryColor()),
        ),
      ),
    );
  }

  bool isUpdateAvailable(AppVersionState state, String buildNumber) {
    int vNumber = int.parse(buildNumber);
    int serverNumber = int.parse(state.response!.data!.latestVersion!);
    return vNumber < serverNumber;
  }
}
