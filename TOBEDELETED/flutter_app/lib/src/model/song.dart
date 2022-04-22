import 'dart:convert';

import 'chord.dart';

class Song {
  int id;
  String? type;
  String? time;
  String title;
  String? author;
  String? youtubeId;
  int? oldId;
  List<String> tags;

  String? text, rithm;
  int? capo;

  Song(this.id, this.type, this.time, this.title, this.author, this.youtubeId,
      this.oldId, this.tags);

  factory Song.fromJson(Map<String, dynamic> json) {
    var tags = <String>[];
    if (json['tags'] != null) {
      json['tags'].forEach((v) {
        tags.add(v.toString());
      });
    }
    return Song(json['id'], json['type'], json['time'], json['song']['title'],
        json['song']['author'], json['song']['youtubeId'], null, tags);
  }

  factory Song.fromSongJson(Map<String, dynamic> json) {
    return Song(json['instances'][0]['id'], json['type'], json['time'],
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
    if (matches.isNotEmpty) {
      return matches[0].group(1) ?? "";
    } else {
      return "";
    }
  }

  String getWithNoChords() {
    var retText = text!.replaceAllMapped(Chord.chordRegex, (match) {
      return "";
    });
    return retText;
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

  String _clean(String input) {
    var replacements = {"á": "a", "é": "e", "í": "i", "ó": "o", "ú": "u"};
    var retVal = replacements.entries
        .fold<String>(input, (prev, e) => prev.replaceAll(e.key, e.value));
    return retVal.toLowerCase();
  }

  bool _superContains(Song song, String query) {
    return _clean(song.title).contains(_clean(query)) ||
        (song.author != null) && _clean(song.author!).contains(_clean(query)) ||
        (song.type != null) && _clean(song.type!).contains(_clean(query));
  }

  bool isContained(String? query) {
    return query != null ? _superContains(this, query) : true;
  }
}
