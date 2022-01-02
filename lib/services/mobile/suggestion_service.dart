import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:wedding/data/models.dart';
import 'package:wedding/services/mobile/base_service.dart';

class SuggestionService extends BaseService {
  static final endpoint = '${BaseService.endpoint}/suggestion';

  static Future<Suggestion> getSuggestion() async {
    var response = await BaseService.get(endpoint);
    switch (response.statusCode) {
      case HttpStatus.ok: return Suggestion.fromJSON(response.data);
      case HttpStatus.notFound: throw '매칭 대상이 없습니다.';
      default: throw response.data;
    }
  }
}