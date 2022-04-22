import 'dart:io';

import 'package:ccnero_app/api/lyric_api.dart';
import 'package:ccnero_app/api_old/song_api.dart';
import 'package:ccnero_app/constants.dart';
import 'package:ccnero_app/model/lyric.dart';
import 'package:ccnero_app/model/lyric_state.dart';
import 'package:ccnero_app/pages/song_full_page.dart';
import 'package:ccnero_app/pages/song_page.dart';
import 'package:ccnero_app/widgets/formatted_song_text.dart';
import 'package:ccnero_app/widgets/info_pane.dart';
import 'package:ccnero_app/widgets/songs/song_info.dart';
import 'package:ccnero_app/widgets/songs/song_text_widget.dart';
import 'package:flutter/material.dart';

class SongPane extends StatefulWidget {
  final bool standAlone, viewMode;
  final Lyric lyric;
  SongPane(this.lyric, {this.standAlone = false, this.viewMode = false});

  @override
  State<SongPane> createState() => _SongPaneState();
}

class _SongPaneState extends State<SongPane> {
  LyricState lyricState = LyricState();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Lyric>(
        future: SongApi.getLyric(widget.lyric),
        builder: (context, snapshot) => snapshot.hasData
            ? _buildBody(context, snapshot.data!)
            : InfoPane(
                iconData: Icons.music_note,
                text: "Obteniendo: ${widget.lyric.title}",
              ));
  }

  Widget _buildBody(BuildContext context, Lyric lyric) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomRight,
      children: [
        SongTextWidget(
            lyric: lyric,
            lyricState: lyricState,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SongFullPage(lyric, lyricState)));
            }),
        Positioned(
            right: 0, bottom: 0, child: _buildSettingsPane(context, lyric)),
      ],
    );
  }

  Widget _buildSettingsPane(context, Lyric lyric) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //Icon(Icons.music_note),
          /*Expanded(
            child: Container(),
          ),*/
          IconButton(
              onPressed: () {
                setState(() {
                  lyricState.fontSize++;
                });
              },
              icon: const Icon(Icons.zoom_in)),
          IconButton(
              onPressed: () {
                setState(() {
                  lyricState.fontSize = LyricState.DEFAULT_FONT_SIZE;
                });
              },
              icon: const Icon(Icons.fullscreen)),
          IconButton(
              onPressed: () {
                setState(() {
                  lyricState.fontSize--;
                });
              },
              icon: const Icon(Icons.zoom_out)),
          Container(
            height: 32,
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  lyricState.transpose++;
                });
              },
              icon: const Icon(Icons.add)),
          TextButton(
              onPressed: () {
                setState(() {
                  lyricState.transpose = 0;
                });
              },
              child: Text(
                lyric.getTone(),
                style: const TextStyle(color: Colors.white),
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  lyricState.transpose--;
                });
              },
              icon: const Icon(Icons.remove)),
          Container(
            height: 32,
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
          if (widget.standAlone)
            Container(
              height: 32,
            ),
          if (widget.standAlone && !Platform.isAndroid)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          if (widget.standAlone)
            Container(
              height: 16,
            ),
        ],
      ),
    );
  }
}
