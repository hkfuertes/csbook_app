import 'package:csbook/src/api/song_api.dart';
import 'package:csbook/src/delegates/song_search_delegate.dart';
import 'package:csbook/src/model/song.dart';
import 'package:csbook/src/pages/stand_alone_song.dart';
import 'package:csbook/src/pages/stand_alone_song_page.dart';
import 'package:csbook/src/panels/searchable.dart';
import 'package:csbook/src/widgets/song_list_item.dart';
import 'package:flutter/material.dart';

class SongsListPane extends StatelessWidget implements Searchable {
  SongSearchDelegate? sd;
  SongsListPane({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Song>>(
        future: SongApi.getSongs(),
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            //We create the Delegate
            sd = SongSearchDelegate(snapshot.data!,
                onTap: (song) => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => StandAloneSongPage(song))));
            return ListView(
              children: snapshot.data!
                  //.where((e) => e.isContained(_query))
                  .map((e) => SongListItem(
                      song: e,
                      onSelected: (song) => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => StandAloneSongPage(song)))))
                  .toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  void onSearchRequested(BuildContext context) {
    if (sd != null) showSearch(context: context, delegate: sd!);
  }

  @override
  IconData getSearchButtonIcon() {
    return Icons.search;
  }
}
