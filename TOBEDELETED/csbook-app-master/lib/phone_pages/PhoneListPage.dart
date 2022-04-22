import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/pages/SongScreen.dart';
import 'package:csbook_app/SongSearch.dart';
import 'package:csbook_app/Widgets/NavigationDrawer.dart';
import 'package:csbook_app/databases/CSDB.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class PhoneListPage extends StatefulWidget {
  static const routeName = '/song_list';

  PhoneListPage({Key key}) : super(key: key);

  @override
  _PhoneListPageState createState() => _PhoneListPageState();
}

class _PhoneListPageState extends State<PhoneListPage> {
  var index = 0;

  void getInstances(BuildContext context, Song song) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SongScreen(
              key: Key("0"),
              song: song,
            )));
  }

  Widget makeAppBar(List<Song> _songs) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Text(Constants.APP_TITLE),
      actions: getActions(context, _songs),
    );
  }

  Widget makeBody(List<Song> _songs) {
    return Scrollbar(
      child: Builder(builder: (context) {
        return ListView.builder(
            itemCount: _songs.length,
            itemBuilder: (BuildContext context, int index) {
              return SongTile(_songs[index], onTap: (song) {
                getInstances(context, song);
              });
            });
      }),
    );
  }

  List<Widget> getActions(BuildContext context, List<Song> _songs) {
    return [
      IconButton(
        icon: Icon(Icons.search),
        tooltip: 'Filtrar',
        onPressed: () {
          showSearch(
              context: context,
              delegate: SongSearch(_songs, (song) {
                print(song.title);
                getInstances(context, song);
              }));
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Song>>(
        future: Song.get(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return Container();
          return Scaffold(
            appBar: makeAppBar(snapshot.data),
            body: RoundedBlackContainer(
              child: makeBody(snapshot.data),
              bottomOnly: true,
              radius: Constants.APP_RADIUS,
            ),
            drawer: NavigationDrawer.drawer(context,
                end: false, currentPage: NavigationDrawer.LIST_PAGE),
            endDrawer: NavigationDrawer.drawer(context,
                end: true, currentPage: NavigationDrawer.LIST_PAGE),
          );
        });
  }
}
