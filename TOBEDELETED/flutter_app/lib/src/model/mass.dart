import 'package:csbook/src/model/song.dart';
import 'package:intl/intl.dart';

class Mass {
  String id;
  DateTime date;
  String? name;
  String? type;
  String? parishName;
  List<MassSong> songs;

  Mass(
      {required this.id,
      required this.date,
      this.name,
      this.type,
      this.parishName,
      required this.songs});

  String getName() {
    if (name != null) {
      return name!;
    } else {
      return "Misa del " + DateFormat("dd/MM/yyyy").format(date);
    }
  }

  String getDate({format = "dd/MM/yyyy"}) {
    return DateFormat(format).format(date);
  }

  @override
  operator ==(Object? o) {
    return ((o != null) && (o is Mass)) && o.id == id;
  }

  factory Mass.fromJson(Map<String, dynamic> json, {empty = true}) {
    return Mass(
      id: json["id"],
      date: DateFormat("yyyy-MM-dd").parse(json["date"]),
      name: json["name"],
      type: json["type"],
      parishName: json["parish"]["name"],
      songs: empty
          ? []
          : (json['songs'] as List).map((e) => MassSong.fromJson(e)).toList(),
    );
  }
}

class MassSong {
  String moment;
  int songId;
  String? tone;
  int? capo;
  Song? song;

  String getSongName() {
    if (song != null) {
      return song!.title;
    } else {
      return "Song " + songId.toString();
    }
  }

  @override
  operator ==(Object? o) {
    return ((o != null) && (o is MassSong)) &&
        (o.songId == songId) &&
        (o.moment == moment);
  }

  MassSong({required this.moment, required this.songId, this.tone, this.capo});
  factory MassSong.fromJson(Map<String, dynamic> json) {
    return MassSong(
        moment: json["moment"],
        songId: json["instance"],
        tone: json["tone"],
        capo: json["capo"]);
  }
}
