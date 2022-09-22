import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/utils/config.dart';
import 'package:masterg/data/models/response/home_response/master_language_response.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/main.dart';
import 'package:masterg/pages/auth_pages/sign_up_screen.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/widget_size.dart';

class ChooseLanguage extends StatefulWidget {
  ChooseLanguage({Key? key}) : super(key: key);

  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  var selected = 0;

  bool _isLoading = false;
  List<ListLanguage>? myList;
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
    super.initState();
    _getLanguage();
  }

  void setCurrentLanguage() async {
    setState(() {
      MyApp.setLocale(context, Locale(localeCodes['english']!));
      selected = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    String appBarImagePath = 'assets/images/${APK_DETAILS['theme_image_url']}';
    print(appBarImagePath);
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is MasterLanguageState) _handleResponse(state);
        },
        child: Builder(builder: (_context) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: ScreenWithLoader(
              isLoading: _isLoading,
              body: SafeArea(
                  child: SingleChildScrollView(
                  //physics: BouncingScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            appBarImagePath.split('.').last == 'svg'
                                ? SvgPicture.asset(
                              appBarImagePath,
                              fit: BoxFit.cover,
                            )
                                : Image.asset(
                              appBarImagePath,
                              height: 150,
                              width: 150,
                            ),

                            SizedBox(height: 60),
                            Center(
                              child: Text(
                                '${Strings.of(context)?.chooseAppLanguage}',
                                style: Styles.bold(size: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 10),

                            //  if(APK_DETAILS['theme_image_url2'] != "")      APK_DETAILS['theme_image_url2']?.split('.').last == 'svg'
                      //           ? SvgPicture.asset(
                      //                   height:
                      //               MediaQuery.of(context).size.height * 0.25,
                      //       'assets/images/${APK_DETAILS['theme_image_url2']}',
                      //         fit: BoxFit.cover,
                      //       )
                      //           : Image.asset(
                      //       'assets/images/${APK_DETAILS['theme_image_url2']}',
                      //           height:
                      //               MediaQuery.of(context).size.height * 0.25,
                      //         // width: 150,
                      //       ),
                            /*SizedBox(
                          //height: MediaQuery.of(context).size.height * 0.25,
                        height: 180,
                          width: 180,
                          child: Image.asset('assets/images/signupimage.gif')
                      ),*/

                       if(APK_DETAILS['theme_image_url2'] != "")      APK_DETAILS['theme_image_url2']?.split('.').last == 'svg'
                                ? SvgPicture.asset(
                                        height:
                                    MediaQuery.of(context).size.height * 0.25,
                            'assets/images/${APK_DETAILS['theme_image_url2']}',
                              fit: BoxFit.cover,
                            )
                                : Image.asset(
                            'assets/images/${APK_DETAILS['theme_image_url2']}',
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                              // width: 150,
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 200,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: myList?.length ?? 0,
                                itemBuilder: (BuildContext context, int index) {
                                  return languageCard(myList![index], index);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 100.0),
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height *
                                  WidgetSize.AUTH_BUTTON_SIZE,
                              decoration: BoxDecoration(
                                  color: ColorConstants().primaryColor(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                '${Strings.of(context)?.continueStr}',
                                style: Styles.regular(
                                  color: ColorConstants.WHITE,
                                ),
                              )),
                            )),
                      ),

                    ],
                  ),
                ),
              )),
            ),
          );
        }),
      ),
    );
  }

  void _handleResponse(MasterLanguageState state) {
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
          myList = state.response!.data!.listData;
          setCurrentLanguage();
          break;
        case ApiStatus.ERROR:
          _isLoading = false;
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _getLanguage() {
    BlocProvider.of<HomeBloc>(context).add(MasterLanguageEvent());
  }

  Widget languageCard(langauge, index) {
    return InkWell(
      onTap: () {
        setState(() {
          selected = index;
          Preference.setInt(Preference.APP_LANGUAGE, langauge.languageId);
          Preference.setString(
              Preference.LANGUAGE, langauge.languageCode.toLowerCase());
          MyApp.setLocale(context,
              Locale(localeCodes[langauge.englishName.toLowerCase()]!));
        });
      },
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: 1,
                  color: index == selected
                      ? ColorConstants.GREEN
                      : ColorConstants.DARK_GREY)),
          child: Center(
              child: Text(
            '${langauge.name}',
            style: Styles.regular(
                size: 18,
                color: index == selected
                    ? ColorConstants.GREEN
                    : ColorConstants.BLACK),
          ))),
    );
  }
}
