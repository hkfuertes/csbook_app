import 'package:ccnero_app/pages/song_page.dart';
import 'package:ccnero_app/widgets/songs/song_list_multipane.dart';
import 'package:ccnero_app/widgets/songs/song_list_widget.dart';
import 'package:flutter/material.dart';

class SongList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if ( //constraints.maxWidth > 600 ||
          constraints.maxHeight < constraints.maxWidth) {
        return SongListMultipane();
      } else {
        return SongListWidget((lyric) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => SongPage(lyric)));
        });
      }
    });
  }
}
