import 'package:ccnero_app/model/lyric.dart';
import 'package:ccnero_app/widgets/songs/song_pane.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SongPage extends StatelessWidget {
  final bool viewMode;
  final Lyric lyric;
  SongPage(this.lyric, {this.viewMode = false});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).scaffoldBackgroundColor,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor),
      child: Scaffold(
          body: SafeArea(
              child: SongPane(
        lyric,
        viewMode: viewMode,
        standAlone: true,
      ))),
    );
  }
}
