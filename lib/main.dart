import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/pages/walk_through_page/splash_screen.dart';
import 'package:masterg/utils/check_connection.dart';
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
  runZoned(() {
    runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await FlutterDownloader.initialize();
      //  WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      setupDependencyInjections();
      initHive();
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      Preference.getInstance();
      runApp(MyApp());
      Preference.load().then((value) {
        UserSession();
      });
    }, (error, stackTrace) {});
  }, zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
    //comment to hide all print
    if (kDebugMode) parent.print(zone, "$line");
  }));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print("onBackgroundMessage: ${message.data}");
  UserSession.notificationData = message.data;
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

    Preference.getInstance();
    Preference.load().then((value) {
      setState(() {
        UserSession();
        updateLocale();
      });
    });
  }

  void updateLocale() {
    if (Preference.getString(Preference.APP_ENGLISH_NAME) != null) {
      this.locale = Locale(
          '${localeCodes[Preference.getString(Preference.APP_ENGLISH_NAME)]}');
    }
    isLocalLanguageLoaded = true;
    setState(() {});
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
              // textSelectionHandleColor: Colors.transparent,
              // primaryColor: ColorConstants.ORANGE,
              primarySwatch: ColorConstants.PRIMARY_COLOR_LIGHT,
              // textSelectionColor: Colors.transparent,
              primaryColorDark: ColorConstants.ORANGE),
          onGenerateTitle: (BuildContext context) =>
              '${Strings.of(context)?.appName}',
          localizationsDelegates: [
            const DemoLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          builder: (BuildContext context, Widget? widget) {
            ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
              return CustomError(errorDetails: errorDetails);
            };

            return widget!;
          },
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
          home: CheckInternet(refresh: () {}, body: EntryAnimationPage()),
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

class CustomError extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomError({
    Key? key,
    required this.errorDetails,
  })  : assert(errorDetails != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        child: Text(
          "Something is not right here...  ${errorDetails.exception}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
      ),
    );
  }
}
