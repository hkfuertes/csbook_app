import '../model/song.dart';
import 'package:flutter/material.dart';

class SongListItem extends StatelessWidget {
  Song song;
  Function(Song)? onSelected;
  SongListItem({Key? key, required this.song, this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        song.title,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: (song.author != null)
          ? Text(
              song.author!,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onTap: () {
        if (onSelected != null) {
          onSelected!(song);
        }
      },
    );
  }
}
