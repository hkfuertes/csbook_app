import 'dart:convert';

import 'package:csbook/src/model/song.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class SongApi {
  static Future<List<Song>> getSongs({String? query}) async {
    var uri = Uri.parse(Constants.baseOldUrl + "/songs");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      Iterable data = json.decode(response.body);

      var Songs = data.map((model) => Song.fromSongJson(model)).toList();
      return Songs;
    } else {
      return [];
    }
  }

  static Future<Song?> getSong(int songId) async {
    var uri =
        Uri.parse(Constants.baseOldUrl + "/instance/" + songId.toString());
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      Song retVal = Song.fromJson(json.decode(response.body));
      retVal.text = json.decode(response.body)['songText'];
      retVal.capo = int.parse(json.decode(response.body)['capo']);
      retVal.rithm = json.decode(response.body)['rithm'];
      return retVal;
    }
    return null;
  }
}
