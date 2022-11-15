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
  final bool showEdulystLogo;
  ChooseLanguage({Key? key, required this.showEdulystLogo}) : super(key: key);

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
    setCurrentLanguage();
  }

  void setCurrentLanguage() async {
    int? currentLanId = Preference.getInt(Preference.APP_LANGUAGE);
    if (currentLanId != null)
      for (int i = 0; i < myList!.length; i++)
        if (currentLanId == myList?[i].languageId) {
          selected = i;
           Preference.setString(
              Preference.LANGUAGE, '${myList?[i].languageCode?.toLowerCase()}');
          MyApp.setLocale(context, Locale(localeCodes['${myList?[i].englishName?.toLowerCase()}']!));

          break;
        } else {
          MyApp.setLocale(context, Locale(localeCodes['english']!));
          selected = 0;
        }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String appBarImagePath = 'assets/images/${APK_DETAILS['theme_image_url']}';
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
                  child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                        height: APK_DETAILS['package_name'] == 'com.at.masterg'
                            ? 40
                            : 20),
                    Center(
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.showEdulystLogo == true)
                            Transform.scale(
                                scale: 1.2,
                                child: appBarImagePath.split('.').last == 'svg'
                                    ? SvgPicture.asset(
                                        appBarImagePath,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        appBarImagePath,
                                        height: 150,
                                        width: 150,
                                      )),
                          SizedBox(
                              height: APK_DETAILS['package_name'] ==
                                      'com.at.masterg'
                                  ? 60
                                  : 10),
                          if (APK_DETAILS['theme_image_url2'] != "")
                            APK_DETAILS['theme_image_url2']?.split('.').last ==
                                    'svg'
                                ? SvgPicture.asset(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    'assets/images/${APK_DETAILS['theme_image_url2']}',
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/${APK_DETAILS['theme_image_url2']}',
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    // width: 150,
                                  ),
                          SizedBox(height: 30),

                          Center(
                            child: Text(
                              '${Strings.of(context)?.chooseAppLanguage}',
                              style: Styles.bold(size: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                              height: 180,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 0,
                                  crossAxisSpacing: 0,
                                  childAspectRatio: 10 / 4.4,
                                  crossAxisCount: 2,
                                ),
                                itemCount: myList?.length ?? 0,
                                itemBuilder: (BuildContext context, int index) {
                                  return languageCard(myList![index], index);
                                },
                              )),
                        ],
                      ),
                    ),
                    if (!widget.showEdulystLogo)
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                    InkWell(
                        onTap: () {
                          if (widget.showEdulystLogo)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()));
                          else
                            Navigator.pop(context);
                        },
                        child: Container(
                          margin:
                              EdgeInsets.only(left: 12.0, right: 12.0, top: 10),
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
                  ],
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
          // width: double.infinity,
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.2,
          // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: 1,
                  color: index == selected
                      ? ColorConstants.GREEN
                      : ColorConstants.DARK_GREY)),
          child: Stack(
            children: [
              Positioned(
                  left: 5,
                  top: 5,
                  child: SvgPicture.asset(
                    height: 16,
                    index == selected
                        ? 'assets/images/selected_lang.svg'
                        : 'assets/images/unselected_lang.svg',
                    fit: BoxFit.cover,
                  )),
              Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${langauge.name}',
                    style: Styles.bold(
                        size: 18,
                        color: index == selected
                            ? ColorConstants.GREEN
                            : ColorConstants.BLACK),
                  ),
                  Text(langauge.title ?? '',
                      style: Styles.regular(
                      size: 12,
                        color: ColorConstants.BLACK,
                      )),
                ],
              )),
            ],
          )),
    );
  }
}
