import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:wedding/data/models.dart';
import 'package:wedding/services/mobile/base_service.dart';

class UserService extends BaseService {
  static final endpoint = '${BaseService.endpoint}/user';

  static Future<bool> checkUserID(String userID) async {
    var response = await BaseService.get(
      '$endpoint/user_id/$userID',
      authorized: false
    );
    switch (response.statusCode) {
      case HttpStatus.ok:
      return response.data as bool;
    }
    throw response.data;
  }

  static Future<User> getUser() async {
    var response = await BaseService.get(endpoint);
    switch (response.statusCode) {
      case HttpStatus.ok:
      return User.fromJSON(response.data);
    }
    throw response.data;
  }

  static Future<User> getPartner(String userID) async {
    var response = await BaseService.get('$endpoint/$userID');
    switch (response.statusCode) {
      case HttpStatus.ok:
      return User.fromJSON(response.data);
    }
    throw response.data;
  }
}