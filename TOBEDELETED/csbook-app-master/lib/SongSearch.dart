
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:csbook_app/model/Song.dart';

class SongSearch extends SearchDelegate<Song> {
  final List<Song> songs;
  final void Function(Song) callBack;

  SongSearch(this.songs, this.callBack);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
        ),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show results based on selection
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // We dont have any suggestion for songs... Maybe Recents...

    final List<Song> suggestionList = query.isEmpty
        ? []
        : songs
            .where((song) =>
                song.title.toLowerCase().contains(query.toLowerCase()) ||
                (song.author != null &&
                    song.author.toLowerCase().contains(query.toLowerCase())) ||
                (song.subtitle != null &&
                    song.subtitle.toLowerCase().contains(query.toLowerCase())))
            .toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) =>
            SongTile(suggestionList[index], onTap: (song) {
              close(context, null);
              callBack(suggestionList[index]);
            }));
  }
}
