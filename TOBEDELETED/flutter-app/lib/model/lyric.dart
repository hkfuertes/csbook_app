import 'dart:convert';

import 'package:ccnero_app/model/chord.dart';

class Lyric {
  int id;
  String? type;
  String? time;
  String title;
  String? author;
  String? youtubeId;
  int oldId;
  List<String> tags;

  String? text, rithm;
  int? capo;

  Lyric(this.id, this.type, this.time, this.title, this.author, this.youtubeId,
      this.oldId, this.tags);

  factory Lyric.fromJson(Map<String, dynamic> json) {
    var tags = <String>[];
    if (json['tags'] != null) {
      json['tags'].forEach((v) {
        tags.add(v.toString());
      });
    }
    return Lyric(json['id'], json['type'], json['time'], json['title'],
        json['author'], json['youtubeId'], json['old_id'], tags);
  }

  factory Lyric.fromSongJson(Map<String, dynamic> json) {
    return Lyric(json['instances'][0]['id'], json['type'], json['time'],
        json['title'], json['author'], json['youtubeId'], json['id'], []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['time'] = this.time;
    data['title'] = this.title;
    data['author'] = this.author;
    data['youtubeId'] = this.youtubeId;
    data['old_id'] = this.oldId;
    if (this.tags != null) {
      data['tags'] = jsonEncode(this.tags);
    }
    return data;
  }

  String getTone() {
    var matches = Chord.chordRegex.allMatches(text ?? "").toList();
    if (matches.length > 0)
      return matches[0].group(1) ?? "";
    else
      return "";
  }

  String transpose(int semiTone) {
    return text!.replaceAllMapped(Chord.chordRegex, (match) {
      return "[" +
          Chord(match.group(1) ?? "")
              .transpose(semiTone)
              .paint(Chord.CHORD_SET_SPANISH) +
          "]";
    });
  }

  String transposeTo(String tone) {
    Chord toChord = Chord(tone);
    Chord chord = Chord(getTone());
    return this.transpose(chord.semiTonesDiferentWith(toChord));
  }
}
