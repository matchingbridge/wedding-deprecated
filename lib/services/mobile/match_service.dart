import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:wedding/data/models.dart';
import 'package:wedding/data/strings.dart';
import 'package:wedding/services/mobile/base_service.dart';

class MatchService extends BaseService {
  static final endpoint = '${BaseService.endpoint}/match';

  static Future<Match?> getMatch({String? partnerID}) async {
    var response = await BaseService.get(endpoint, queryParameters: {
      if (partnerID != null)
        'partner_id' : partnerID
    });
    switch (response.statusCode) {
      case HttpStatus.ok: return Match.fromJSON(response.data);
      case HttpStatus.notFound: return null;
      default: throw response.data;
    }
  }

  static Future<Match> askMatch(String partnerID) async {
    var response = await BaseService.put('$endpoint/ask/$partnerID');
    switch (response.statusCode) {
      case HttpStatus.ok: return Match.fromJSON(response.data);
      default: throw response.data;
    }
  }

  static Future<Match> answerMatch(String partnerID, bool accept) async {
    var response = await BaseService.put('$endpoint/answer/$partnerID', data: {'accept': accept});
    switch (response.statusCode) {
      case HttpStatus.ok: return Match.fromJSON(response.data);
      default: throw response.data;
    }
  }

  static Future<bool> terminateMatch(String partnerID, String message) async {
    var response = await BaseService.put('$endpoint/terminate/$partnerID', data: {'message': message});
    switch (response.statusCode) {
      case HttpStatus.ok: return true;
      default: throw response.data;
    }
  }

  static Future<List<Match>> getHistory() async {
    var response = await BaseService.get('$endpoint/history');
    var data = response.data;
    if (data is List)
      return data.map<Match>((e) => Match.fromJSON(e)).toList();
    throw wrongDataType;
  }

  static Future<List<Match>> getUnanswered() async {
    var response = await BaseService.get('$endpoint/unanswered');
    var data = response.data;
    if (data is List)
      return data.map<Match>((e) => Match.fromJSON(e)).toList();
    throw wrongDataType;
  }
}