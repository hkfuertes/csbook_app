import 'dart:convert';

import 'package:csbook/src/api/song_api.dart';
import 'package:csbook/src/model/mass.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class MassApi {
  static Future<List<Mass>> getMasses({String? query}) async {
    var uri = Uri.parse(Constants.baseOldUrl + "/masses");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map<Mass>((model) => Mass.fromJson(model))
          .toList();
    } else {
      return [];
    }
  }

  static Future<Mass> getMass(Mass mass) async {
    var uri = Uri.parse(Constants.baseOldUrl + "/mass/" + mass.id.toString());
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var newMass = Mass.fromJson(json.decode(response.body), empty: false);

      await Future.forEach<MassSong>(newMass.songs, (e) async {
        e.song = await SongApi.getSong(e.songId);
      });

      return newMass;
    }
    return mass;
  }
}
