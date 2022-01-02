import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:wedding/data/models.dart';

class AdminService {
  static final endpoint = 'http://wedding-server-dev.eba-yemzuhzj.ap-northeast-2.elasticbeanstalk.com/api/admin';
  // static final endpoint = 'http://10.138.62.2:5206/api/admin';
  static Dio dio = Dio();
  
  static Future<List<UserBase>> getUsers() async {
    var response = await dio.get('$endpoint/user');
    var data = response.data;
    switch (response.statusCode) {
      case HttpStatus.ok: 
      if (data is List) return data.map<UserBase>((e) => UserBase.fromJSON(e)).toList();
    }
    throw data;
  }

  static Future<void> reviewUser(int authID) async {
    var response = await dio.put('$endpoint/auth/review/$authID');
    switch (response.statusCode) {
      case HttpStatus.ok: return;
      default: throw response.data;
    }
  }

  static Future<List<Chat>> getChats() async {
    var response = await dio.get('$endpoint/chat');
    var data = response.data;
    switch (response.statusCode) {
      case HttpStatus.ok:
      if (data is List) return data.map<Chat>((e) => Chat.fromJSON(e)).toList();
    }
    throw data;
  }

  static Future<List<Match>> getMatches() async {
    var response = await dio.get('$endpoint/match');
    var data = response.data;
    switch (response.statusCode) {
      case HttpStatus.ok:
      if (data is List) return data.map<Match>((e) => Match.fromJSON(e)).toList();
    }
    throw data;

  }
}