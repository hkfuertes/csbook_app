import 'dart:ffi';
import 'dart:io';

import 'package:ccnero_app/model/lyric.dart';
import 'package:ccnero_app/model/lyric_state.dart';
import 'package:ccnero_app/widgets/songs/song_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

class SongFullPage extends StatelessWidget {
  final Lyric lyric;
  final LyricState lyricState;
  SongFullPage(this.lyric, this.lyricState);
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) Wakelock.enable();
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid || Platform.isIOS) Wakelock.disable();
        return true;
      },
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.black),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
              statusBarColor: Colors.black,
              systemNavigationBarColor: Colors.black),
          child: Scaffold(
            body: SafeArea(
              child: SongTextWidget(
                lyric: lyric,
                lyricState: lyricState,
                onTap: () {},
              ),
            ),
            floatingActionButton: !Platform.isAndroid
                ? FloatingActionButton(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    elevation: 0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  )
                : Container(),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        radius: 50,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(50)),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
