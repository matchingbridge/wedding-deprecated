import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding/data/strings.dart';

class BaseService {
  static final endpoint = 'http://wedding-server-dev.eba-yemzuhzj.ap-northeast-2.elasticbeanstalk.com/api/client';
  // static final endpoint = 'http://192.168.219.119:5206/api/client';
  static Dio dio = Dio();
  static SharedPreferences? sharedPreferences;

  static Future<String?> getAccessToken() async {
    if (sharedPreferences == null)
      sharedPreferences = await SharedPreferences.getInstance();
    if (await checkExpired())
      await refresh();
    return sharedPreferences!.getString(accessTokenKey);
  }

  static Future<bool> checkExpired() async {
    if (sharedPreferences == null)
      sharedPreferences = await SharedPreferences.getInstance();
    assert(sharedPreferences!.containsKey(expiresAtKey));
    var expiresAt = sharedPreferences!.getInt(expiresAtKey)!;
    var now = DateTime.now().millisecondsSinceEpoch / 1000;
    return expiresAt < now;
  }

  static Future<void> refresh() async {
    if (sharedPreferences == null)
      sharedPreferences = await SharedPreferences.getInstance();
    assert(sharedPreferences!.containsKey(refreshTokenKey));
    assert(sharedPreferences!.containsKey(accessTokenKey));
    var refreshToken = sharedPreferences!.getString(refreshTokenKey);
    var accessToken = sharedPreferences!.getString(accessTokenKey);
    var response = await dio.post(
      '$endpoint/account/refresh-token',
      data: {'refresh_token': refreshToken},
      options: Options(headers: {'Authorization': accessToken})
    );
    if (!await save(response.data[accessTokenKey], response.data[expiresAtKey]))
      throw failedToSave;
  }

  static Future<bool> save(String accessToken, int expiresAt,
      {String? refreshToken}) async {
    if (sharedPreferences == null)
      sharedPreferences = await SharedPreferences.getInstance();
    var success = await sharedPreferences!.setString(accessTokenKey, accessToken);
    success &= await sharedPreferences!.setInt(expiresAtKey, expiresAt);
    if (refreshToken != null)
      success &= await sharedPreferences!.setString(refreshTokenKey, refreshToken);
    return success;
  }

  static Future<Options> getOptions(bool authorized) async => Options(headers: {
    if (authorized)
      'Authorization': await getAccessToken()
  }, contentType: 'application/json', validateStatus: (code) => true);

  static Future<Response<T>> get<T>(String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool authorized = true
  }) async {
    return await dio.get<T>(path,
      queryParameters: queryParameters,
      options: await getOptions(authorized),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response<T>> post<T>(String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool authorized = true
  }) async {
    return await dio.post<T>(path,
      data: data,
      queryParameters: queryParameters,
      options: await getOptions(authorized),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress
    );
  }

  static Future<Response<T>> put<T>(String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool authorized = true
  }) async {
    return await dio.put<T>(path,
      data: data,
      queryParameters: queryParameters,
      options: await getOptions(authorized),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress
    );
  }

  static Future<Response<T>> delete<T>(String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool authorized = true
  }) async {
    return await dio.delete<T>(path,
      data: data,
      queryParameters: queryParameters,
      options: await getOptions(authorized),
      cancelToken: cancelToken
    );
  }
}