import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/pages/walk_through_page/splash_screen.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:path_provider/path_provider.dart';

import 'blocs/auth_bloc.dart';
import 'data/api/api_service.dart';
import 'data/models/response/auth_response/user_session.dart';
import 'dependency_injections.dart';
import 'local/pref/Preference.dart';
import 'utils/Strings.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize();
    setupDependencyInjections();
    initHive();
    Preference.getInstance();
    runApp(MyApp()); 
    Preference.load().then((value) {
      UserSession();
    });
  }, (error, stackTrace) {});
}

class MyApp extends StatefulWidget with PortraitModeMixin {
  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    // ignore: invalid_use_of_protected_member
    state.setState(() {
      state.locale = newLocale;
      UserSession.language = newLocale.languageCode;
    });
  }
}

class _MyAppState extends State<MyApp> {
  Locale? locale;
  bool isLocalLanguageLoaded = false;

  @override
  void initState() {
    super.initState();
    Preference.getInstance();
    Preference.load().then((value) {
      setState(() {
        UserSession();
        if (UserSession.language != null)
          this.locale = new Locale('${UserSession.language}');
        isLocalLanguageLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(LoginState(ApiStatus.INITIAL))),
          BlocProvider<HomeBloc>(
              create: (context) =>
                  HomeBloc(AnnouncementContentState(ApiStatus.INITIAL))),

                   BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(LoginState(ApiStatus.INITIAL))),
          BlocProvider<HomeBloc>(
              create: (context) =>
                  HomeBloc(AnnouncementContentState(ApiStatus.INITIAL))),
          BlocProvider<HomeBloc>(
              create: (context) =>
                  HomeBloc(ContentTagsState(ApiStatus.INITIAL))),
        ],
        child: MaterialApp(
          locale: this.locale,
          theme: ThemeData(
              textSelectionHandleColor: Colors.transparent,
              primaryColor: ColorConstants.ORANGE,
              primarySwatch: ColorConstants.PRIMARY_COLOR_LIGHT,
              textSelectionColor: Colors.transparent,
              primaryColorDark: ColorConstants.ORANGE),
          onGenerateTitle: (BuildContext context) =>
              '${Strings.of(context)?.appName}',
          localizationsDelegates: [
            const DemoLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''),
            const Locale('ta', ''),
            const Locale('te', ''),
            const Locale('kn', ''),
            const Locale('mr', ''),
            const Locale('bn', ''),
            const Locale('hi', ''),
            const Locale('ml', ''),
          ],
          home: EntryAnimationPage(),
          debugShowCheckedModeBanner: false,
        ));
  }
}

mixin PortraitModeMixin on StatefulWidget {
  /*initializeRemoteConfig() async {
    print("initualize remote config");
    _remoteConfigHelper = await RemoteConfigHelper.getInstance();
    await _remoteConfigHelper.initialize();
  }*/

  Widget? build(BuildContext context) {
    print("initualize remote config");
    _portraitModeOnly();
    return null;
  }
}

void initHive() async {
  await getApplicationDocumentsDirectory().then((value) {
    Hive.init(value.path);
    Hive.openBox(DB.CONTENT);
    Hive.openBox(DB.ANALYTICS);
    Hive.openBox(DB.TRAININGS);
    Hive.openBox('theme');
  });
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class Application {
  static BuildContext? _context;

  Application(BuildContext context) {
    _context = context;
  }

  static BuildContext? getContext() {
    return _context;
  }
}
