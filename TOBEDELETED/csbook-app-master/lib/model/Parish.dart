import 'dart:convert';

import 'package:csbook_app/Api.dart';
import 'package:csbook_app/model/Chord.dart';
import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/model/Song.dart';

class Parish  {
  final int id;
  final String name;
  final List<String> timetable;
  final String address;
  final String logo;

Parish(
      this.id, this.name, this.timetable, this.address, this.logo);


factory Parish.fromJson(Map<String, dynamic> json) {
    return new Parish(json['id'], json['name'], json['timetable'],
        json['address'], json['logo']);
  }

  factory Parish.fromSimpleJson(Map<String, dynamic> json) {
    return new Parish(json['id'], json['name'],null, "", "");
  }

  bool operator == (dynamic other) {
    if(!other is Parish) return false;
    return (other as Parish).name == name;
  }

  static Future<List<Parish>> getAll() async {
    var response = await Api.get('api/v1/parishes');

    final responseJson = json.decode(response.body);
    final items = (responseJson as List).map((i) => new Parish.fromSimpleJson(i));

    return items.toList();
  }

  
}
