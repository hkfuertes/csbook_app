import 'dart:convert';

import 'package:ccnero_app/constants.dart';
import 'package:ccnero_app/model/lyric.dart';
import 'package:http/http.dart' as http;

class LyricApi {
  static Future<List<Lyric>> getLyrics() async {
    var uri = Uri.parse(Constants.baseUrl + "/lyrics");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      Iterable data = json.decode(response.body);

      var lyrics = data.map((model) => Lyric.fromJson(model)).toList();
      return lyrics;
    } else {
      return [];
    }
  }

  static Future<Lyric> getLyric(Lyric lyric) async {
    var uri = Uri.parse(Constants.baseUrl + "/lyric/" + lyric.id.toString());
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      lyric.text = json.decode(response.body)['text'];
      lyric.capo = int.parse(json.decode(response.body)['capo']);
      lyric.rithm = json.decode(response.body)['rithm'];
    }
    return lyric;
  }
}
