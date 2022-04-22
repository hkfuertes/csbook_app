import 'package:flutter/material.dart';

class SongInfo extends StatelessWidget {
  final CrossAxisAlignment alignment;
  final String title;
  final String? author;

  SongInfo(this.title, this.author, {this.alignment = CrossAxisAlignment.end});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          this.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        if (author != null)
          Text(
            author!,
            style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w100,
                fontStyle: FontStyle.italic),
          )
      ],
    );
  }
}
