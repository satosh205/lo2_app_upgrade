import 'package:dio/dio.dart';
import 'package:masterg/utils/Log.dart';

import 'environment.dart';

InterceptorsWrapper requestInterceptor(Dio dio, Environment env) =>
    InterceptorsWrapper(
      onRequest: (RequestOptions options, handler) {
        final uri = options.uri.toString();
        Log.v("Api - URL: ${uri.toString()}");
        Log.v("Api - headers: ${options.headers}");
        Log.v("Api - Request Body: ${options.data}");
        return handler.next(options);
      },
    );

InterceptorsWrapper responseInterceptor(Dio dio, Environment env) =>
    InterceptorsWrapper(onResponse: (Response response, handler) {
      Log.v("Api - Response headers");
      response.headers.forEach((k, v) {
        v.forEach((s) => Log.v("$k , $s"));
      });
      Log.v("Api - Response: ${response.data}");

      return handler.next(response);
    });
