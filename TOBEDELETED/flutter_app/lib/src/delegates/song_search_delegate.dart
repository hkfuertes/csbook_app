import 'package:csbook/src/model/song.dart';
import 'package:csbook/src/widgets/song_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SongSearchDelegate extends SearchDelegate {
  final List<Song> songs;
  final Function(Song)? onTap;
  final bool autoclose;

  SongSearchDelegate(this.songs, {this.onTap, this.autoclose = false})
      : super(searchFieldLabel: "Buscar");

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          appBarTheme: super
              .appBarTheme(context)
              .appBarTheme
              .copyWith(elevation: 0.0, backgroundColor: Colors.transparent),
        );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  String _removeSpecialChars(String input) {
    var replacements = {"á": "a", "é": "e", "í": "i", "ó": "o", "ú": "u"};
    return replacements.entries
        .fold(input, (prev, e) => prev.replaceAll(e.key, e.value));
  }

  @override
  Widget buildResults(BuildContext context) {
    var filtered = songs.where((e) {
      return _removeSpecialChars(e.title.toLowerCase())
              .contains(_removeSpecialChars(query.toLowerCase())) ||
          (e.author != null &&
              _removeSpecialChars(e.author!.toLowerCase())
                  .contains(_removeSpecialChars(query.toLowerCase()))) ||
          (e.type != null &&
              _removeSpecialChars(e.type!.toLowerCase())
                  .contains(_removeSpecialChars(query.toLowerCase())));
    });

    return ListView(
      children: filtered
          .map((e) => SongListItem(
                song: e,
                onSelected: (song) {
                  if (autoclose) close(context, null);
                  if (onTap != null) onTap!(song);
                },
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
