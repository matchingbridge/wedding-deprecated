import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:wedding/data/models.dart';
import 'package:wedding/data/strings.dart';
import 'package:wedding/services/mobile/base_service.dart';

class ChatService extends BaseService {
  static final endpoint = '${BaseService.endpoint}/chat';

  static Future<List<Chat>> getChats() async {
    var response = await BaseService.get(endpoint);
    switch (response.statusCode) {
      case HttpStatus.ok:
      var data = response.data;
      if (data is List)
        return data.map<Chat>((e) => Chat.fromJSON(e)).toList();
      throw wrongDataType;
    }
    throw response.data;
  }

  static Future<Chat> makeChat(String message) async {
    var response = await BaseService.post(endpoint, data: {'message': message});
    switch (response.statusCode) {
      case HttpStatus.ok:
      var data = response.data;
      if (data is Map)
        return Chat.fromJSON(data);
      throw wrongDataType;
    }
    throw response.data;
  }
}