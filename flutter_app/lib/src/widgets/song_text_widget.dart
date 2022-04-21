import 'package:csbook/src/model/song.dart';
import 'package:csbook/src/widgets/formatted_song_text.dart';
import 'package:csbook/src/widgets/song_info.dart';
import 'package:flutter/material.dart';

class SongTextWidget extends StatelessWidget {
  final Song song;
  final Function()? onTap;
  final Function(double)? onPinch;
  final bool english;
  final bool showChords;
  final double textScaleFactor;
  final int semitonesFactor;

  SongTextWidget(
      {required this.song,
      this.onTap,
      this.textScaleFactor = 1.0,
      this.semitonesFactor = 0,
      this.english = false,
      this.showChords = true,
      this.onPinch});

  final CrossAxisAlignment alignment = CrossAxisAlignment.start;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            SongInfo(
              padding:
                  const EdgeInsets.only(right: 16.0, top: 16.0, left: 16.0),
              song: song,
              alignment: alignment,
            ),
            FormattedSongText(
                onTap: onTap,
                onPinch: onPinch,
                songText: (showChords)
                    ? song.transpose(semitonesFactor)
                    : song.getWithNoChords(),
                textScaleFactor: textScaleFactor,
                notation: (english)
                    ? FormattedSongText.NOTATION_ENGLISH
                    : FormattedSongText.NOTATION_SPANISH),
          ],
        ));
  }
}
