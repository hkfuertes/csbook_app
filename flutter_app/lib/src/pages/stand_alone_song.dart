import 'dart:io';

import 'package:csbook/src/model/mass.dart';
import 'package:csbook/src/model/song.dart';
import 'package:csbook/src/panels/song_pane.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class StandAloneSong extends StatefulWidget {
  final Song song;
  final MassSong? massSong;
  bool black;

  StandAloneSong(this.song, {Key? key, this.black = false, this.massSong})
      : super(key: key);

  @override
  State<StandAloneSong> createState() => _StandAloneSongState();
}

class _StandAloneSongState extends State<StandAloneSong> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      Wakelock.toggle(enable: widget.black);
    } else if (!Platform.isLinux) {
      Wakelock.toggle(enable: widget.black);
    }
    return WillPopScope(
      onWillPop: () async {
        if (widget.black) {
          setState(() {
            widget.black = false;
          });
          return false;
        } else {
          return true;
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: widget.black
                ? Colors.black
                : Theme.of(context).scaffoldBackgroundColor),
        child: Theme(
          data: widget.black
              ? Theme.of(context)
                  .copyWith(scaffoldBackgroundColor: Colors.black)
              : Theme.of(context),
          child: Scaffold(
            body: SafeArea(
              child: SongPane(
                widget.song,
                viewMode: widget.black,
                onBackPressed: () {
                  if (widget.black) {
                    setState(() {
                      widget.black = false;
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                onBlackModeRequested: () {
                  setState(() {
                    widget.black = true;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
