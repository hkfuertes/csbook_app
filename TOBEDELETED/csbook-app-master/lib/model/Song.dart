import 'dart:convert';

import 'package:csbook_app/Api.dart';

class Song {
  final int id;
  final String title;
  final String subtitle;
  final String author;
  final String type;
  final String time;
  final String youtubeId;

  //Simply to show a popup
  Map<int, String> instances = Map();

  bool cached = false;

  Song(this.id, this.title, this.subtitle, this.author, this.type, this.time,
      this.youtubeId);

  factory Song.fromJson(Map<String, dynamic> json) {
    return new Song(json['id'], json['title'], json['subtitle'], json['author'],
        json['type'], json['time'], json['youtubeId']);
  }

  static Future<List<Song>> get({int skip=0, int take=0}) async {
    var response = await Api.get('api/v1/songs');

    final responseJson = json.decode(response.body);
    final items = (responseJson as List).map((i) {
      var current = new Song.fromJson(i);
      var instances = i['instances'] as List;
      for (int i = 0; i< instances.length; i++){
        current.instances[instances[i]['id']] = instances[i]['parish']['name'];
      }
      return current;
      });

    return items.toList();
  }

  String getTitle() {
    return title;
  }

  String getSubTitle() {
    return subtitle;
  }

  String getAuthor() {
    return hasAuthor() ? author : "";
  }

  bool hasAuthor() {
    return author != null;
  }

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['title'] = this.title;
    map['subtitle'] = this.subtitle;
    map['author'] = this.author;
    map['type'] = this.type;
    map['time'] = this.time;
    map['youtubeId'] = this.youtubeId;
    map['cached'] = this.cached ? 1 :0;

    String instances = "";
    this.instances.forEach((key,value){
      instances += key.toString()+";"+value+"|";
    });
    map['instances'] = instances;
    return map;
  }
  factory Song.fromDb(Map<String, dynamic> _json) {
    Song s = new Song.fromJson(_json);
    s.instances = new Map<int,String>();
    _json['instances'].toString().split("|").forEach((pair){
      if(pair!= ""){
        var el = pair.split(";");
        s.instances[int.parse(el[0])] = el[1];
      }
    });
    s.cached = _json['cached'] == 1;
    return s;
  }

  Song setCached(){
    cached = true;
    return this;
  }

}
