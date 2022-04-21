import 'package:csbook/src/model/song.dart';
import 'package:flutter/material.dart';

class SongInfo extends StatelessWidget {
  final CrossAxisAlignment alignment;
  final Song song;
  final EdgeInsets padding;

  SongInfo(
      {required this.song,
      this.alignment = CrossAxisAlignment.end,
      this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (song.capo != null && song.capo! > 0)
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              padding: const EdgeInsets.only(right: 8.0),
              decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.white))),
              child: Text(
                " C" + song.capo.toString(),
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          Column(
            crossAxisAlignment: alignment,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                song.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (song.author != null)
                Text(
                  song.author!,
                  style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w100,
                      fontStyle: FontStyle.italic),
                )
            ],
          ),
        ],
      ),
    );
  }
}
