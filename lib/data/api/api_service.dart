import 'package:dio/dio.dart';
import 'package:masterg/utils/Log.dart';
import 'api_constants.dart';
import 'environment.dart';
import 'interceptors.dart';

class ApiService {
  static ApiService? _instance;

  factory ApiService() => _instance ??= ApiService._();

  ApiService._();

  static const String USER_AGENT = "user-agent";
  static const _timeout = 600000;

  bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  //Switch the environment between Prod and Dev
  Environment _env = _Prod();

  // Environment _env = _Dev();

  Environment get env => _env;

  Dio get dio => _dio();

  Dio _dio() {
    final options = BaseOptions(
      baseUrl: _env.baseUrl,
      connectTimeout: _timeout,
      receiveTimeout: _timeout,
    );

    var dio = Dio(options);
    dio.interceptors.add(requestInterceptor(dio, _env));
    dio.interceptors.add(responseInterceptor(dio, _env));
    // dio.interceptors.add(DioCacheInterceptor(
    //     options: CacheOptions(
    //   store: HiveCacheStore(null),
    //   policy: CachePolicy.request,
    //   hitCacheOnErrorExcept: [401, 403, 404,304],
    // )));
    return dio;
  }

  void setEnvironment(EnvironmentType type) {
    Log.v("Setting environment to $type");
    switch (type) {
      case EnvironmentType.DEV:
        _env = _Dev();
        break;
      default:
        _env = _Prod();
    }
  }
}

class _Prod extends Environment {
  @override
  EnvironmentType get type => EnvironmentType.PROD;

  @override
  String get baseUrl => ApiConstants.PRODUCTION_BASE_URL;

  @override
  String get apiKey => "For api key";
}

class _Dev extends Environment {
  @override
  EnvironmentType get type => EnvironmentType.DEV;

  @override
  String get baseUrl => ApiConstants.DEV_BASE_URL;

  @override
  String get apiKey => "For api key";
}

enum ApiStatus { INITIAL, LOADING, SUCCESS, ERROR }
