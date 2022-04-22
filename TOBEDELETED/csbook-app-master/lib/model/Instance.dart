import 'dart:convert';
import 'dart:core';

import 'package:csbook_app/Api.dart';
import 'package:csbook_app/model/Chord.dart';
import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/model/Parish.dart';
import 'package:csbook_app/model/Song.dart';

class Instance {
  final int id;
  final String songText;
  final String capo;
  final String rithm;
  final String tone;

  Song song;

  Parish parish;

  final chordRegex = RegExp(r'\[(.*?)\]');

  Instance(
      this.id, this.songText, this.capo, this.rithm, this.tone);

  factory Instance.fromJson(Map<String, dynamic> json) {
    return new Instance(json['id'], json['songText'], json['capo'],
        json['rithm'], json['tone']);
  }

  static Future<Instance> get(int instance) async {
    var response = await Api.get('api/v1/instance/' + instance.toString());

    final responseJson = json.decode(response.body);
    Instance current;
    current = new Instance.fromJson(responseJson);
    current.setSong(Song.fromJson(responseJson['song']));
    current.setParish(Parish.fromSimpleJson(responseJson['parish']));
    return current;
  }

  static Future<List<Instance>> getBySongId(int song_id) async {
    var response = await Api.get('api/v1/song/' + song_id.toString());

    final responseJson = json.decode(response.body);
    Instance current;
    final items = (responseJson['instances'] as List).map((i) {
      current = new Instance.fromJson(i);
      current.setSong(Song.fromJson(responseJson['song']));
      return current;
    });

    return items.toList();
  }

  void setSong(Song song) {
    this.song = song;
  }

  void setParish(Parish parish){
    this.parish = parish;
  }

  String removeChords() {
    return songText.replaceAll(chordRegex, "").replaceAll("( )+", " ");
  }

  String getTone(List<String> chordset) {
    return Chord(tone).paint(chordset);
  }

  String transpose(int semiTone) {
    return songText.replaceAllMapped(Chord.chordRegex, (match) {
      return "[" +
          Chord(match.group(1))
              .transpose(semiTone)
              .paint(Chord.CHORD_SET_SPANISH) +
          "]";
    });
  }

  String transposeTo(String tone) {
    Chord toChord = new Chord(tone);
    Chord chord = new Chord(this.tone);
    return this.transpose(chord.semiTonesDiferentWith(toChord));
  }

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['songId'] = this.song.id;
    map['songText'] = this.songText;
    map['capo'] = this.capo;
    map['rithm'] = this.rithm;
    map['parish'] = this.parish.id;
    map['tone'] = this.tone;
    return map;
  }

  factory Instance.fromDb(Song song, Map<String, dynamic> instance_map) {
    Instance retVal = new Instance(
        instance_map['id'],
        instance_map['songText'],
        instance_map['capo'],
        instance_map['rithm'],
        instance_map['tone']);

    retVal.setSong(song);
    return retVal;
  }
}
