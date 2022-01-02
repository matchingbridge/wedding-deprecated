import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:http_parser/http_parser.dart';
import 'package:wedding/data/models.dart';
import 'package:wedding/data/strings.dart';
import 'package:wedding/services/mobile/base_service.dart';

class AuthService extends BaseService {
  static final endpoint = '${BaseService.endpoint}/auth';

  static Future<bool> signin(String userID, String password) async {
    var response = await BaseService.post(
      '$endpoint/signin', 
      data: {'user_id': userID, 'password': password}, 
      authorized: false
    );
    switch (response.statusCode) {
      case HttpStatus.ok:
      if (!await BaseService.save(response.data[accessTokenKey], response.data[expiresAtKey], refreshToken: response.data[refreshTokenKey]))
        throw failedToSave;
      return true;
      case HttpStatus.accepted: return false;
      default: throw response.data;
    }
  }

  static Future<String> signup(User user, String password, Map<String, String> media) async {
    var files = Map<String, MultipartFile>();
    for (var entry in media.entries)
      files[entry.key] = await MultipartFile.fromFile(entry.value, filename: 'media', contentType: MediaType('multipart', 'form-data'));
    var response = await BaseService.post(
      '$endpoint/signup', 
      data: FormData.fromMap({
        'user': json.encode(user.toJSON()),
        'password': password,
      }..addAll(files)),
      authorized: false
    );
    switch (response.statusCode) {
      case HttpStatus.ok: return '';
      default: throw response.data;
    }
  }
}