import 'package:ccnero_app/api_old/song_api.dart';
import 'package:ccnero_app/model/lyric.dart';
import 'package:ccnero_app/widgets/songs/song_list_widget.dart';
import 'package:flutter/material.dart';

class SongSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    return Column(
      children: <Widget>[
        //Build the results based on the searchResults stream in the searchBloc
        FutureBuilder<List<Lyric>>(
          future: SongApi.getLyrics(query: query),
          builder: (context, AsyncSnapshot<List<Lyric>> snapshot) {
            if (!snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.data!.isEmpty) {
              return Column(
                children: const <Widget>[
                  Text(
                    "No Results Found.",
                  ),
                ],
              );
            } else {
              return ListView(
                children:
                    snapshot.data!.map((e) => LyricTile(e, (l) {})).toList(),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}
