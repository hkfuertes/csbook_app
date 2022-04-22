import 'package:ccnero_app/model/lyric.dart';
import 'package:ccnero_app/model/lyric_state.dart';
import 'package:ccnero_app/widgets/formatted_song_text.dart';
import 'package:ccnero_app/widgets/songs/song_info.dart';
import 'package:flutter/material.dart';

class SongTextWidget extends StatelessWidget {
  final Lyric lyric;
  final LyricState lyricState;
  final GestureTapCallback onTap;

  SongTextWidget({
    required this.lyric,
    required this.lyricState,
    required this.onTap,
  });

  final CrossAxisAlignment alignment = CrossAxisAlignment.start;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: alignment,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(right: 16.0, top: 16.0, left: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: SongInfo(
                      lyric.title,
                      lyric.author ?? "",
                      alignment: alignment,
                    ),
                  ),
                ],
              ),
            ),
            FormattedSongText(
              lyric.transpose(lyricState.transpose),
              textSize: lyricState.fontSize,
            ),
          ],
        )));
  }
}
