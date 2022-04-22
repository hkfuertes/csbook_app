import 'package:ccnero_app/constants.dart';
import 'package:ccnero_app/pages/song_page.dart';
import 'package:ccnero_app/widgets/info_pane.dart';
import 'package:ccnero_app/widgets/songs/song_list_widget.dart';
import 'package:ccnero_app/widgets/songs/song_pane.dart';
import 'package:flutter/material.dart';

class SongListMultipane extends StatefulWidget {
  @override
  State<SongListMultipane> createState() => _SongListMultipaneState();
}

class _SongListMultipaneState extends State<SongListMultipane> {
  Widget _currentPanel = InfoPane(
      iconData: Icons.info,
      text:
          "Selecciona una canción de la lista de la izquierda \npara empezar");

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      //color: Theme.of(context).primaryColorDark
                      border: Border(
                          right: BorderSide(
                              color: Colors.white.withOpacity(0.3)))),
                  width: constraints.maxWidth * 0.25,
                  child: SongListWidget((lyric) {
                    setState(() {
                      _currentPanel = SongPane(lyric);
                    });
                  }),
                ),
                Expanded(child: _currentPanel)
              ],
            ));
  }
}
