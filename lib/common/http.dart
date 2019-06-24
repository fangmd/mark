import 'package:dio/dio.dart';

import '../C.dart';

// dio.interceptors.add(LogInterceptor(responseBody: false)); //开启请求日志

class Http {
  ///dio 配置
  static BaseOptions getCommonOptions(Map<String, String> header) {
    var options = BaseOptions(
      method: 'get',
      connectTimeout: 5000,
      baseUrl: BASE_URL,
    );
    options.headers.addAll({
      // "clienttype": 'ANDROID', // add customer header
    });
    if (header != null) {
      options.headers.addAll(header);
    }
    return options;
  }

  static Dio getDio({Map<String, String> header}) {
    Dio dio = new Dio(getCommonOptions(header));
    dio.interceptors.add(LogInterceptor(
      requestHeader: false,
      requestBody: false,
      responseHeader: false,
      responseBody: true,
    ));
    return dio;
  }
}
