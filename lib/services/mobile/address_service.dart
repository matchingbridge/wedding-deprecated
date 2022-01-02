import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class AddressService {
  static Future<List<String>> getAddress(String keyword) async {
    final url = 'https://www.juso.go.kr/addrlink/addrLinkApi.do?keyword=건영2차&resultType=json';
    final confmKey = 'U01TX0FVVEgyMDIxMTEwNDAwMjMxNjExMTgzNzE=';
    var response = await Dio().get(
      'https://www.juso.go.kr/addrlink/addrLinkApi.do', 
      queryParameters: {
        'keyword': keyword, 'resultType': 'json', 'confmKey': confmKey
      }
    );
    switch (response.statusCode) {
      case HttpStatus.ok: 
        var addressList = response.data['results']['juso'];
        if (addressList is List)
          return addressList.map<String>((address) => address['roadAddr']).toList();
        else
          return [];
      default:
        throw response.data;
    }
  }
}