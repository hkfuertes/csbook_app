import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';

class ParishApi {
  static Future<Map<int, String>> getParishes() async {
    var uri = Uri.parse(Constants.baseOldUrl + "/parishes");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      return {for (var e in json.decode(response.body)) e["id"]: e["name"]};
    } else {
      return {};
    }
  }
}
