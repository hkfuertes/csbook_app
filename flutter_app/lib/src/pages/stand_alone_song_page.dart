// ignore_for_file: unnecessary_const

import 'dart:io';

import 'package:csbook/src/api/song_api.dart';
import 'package:csbook/src/constants.dart';
import 'package:csbook/src/helpers/KeyboardHelper.dart';
import 'package:csbook/src/model/mass.dart';
import 'package:csbook/src/model/song.dart';
import 'package:csbook/src/panels/song_pane.dart';
import 'package:csbook/src/settings_controller.dart';
import 'package:csbook/src/widgets/SongTitleRow.dart';
import 'package:csbook/src/widgets/formatted_song_text.dart';
import 'package:csbook/src/widgets/song_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class StandAloneSongPage extends StatefulWidget {
  final Song song;
  final MassSong? massSong;
  bool black;

  StandAloneSongPage(this.song, {Key? key, this.black = false, this.massSong})
      : super(key: key);

  @override
  State<StandAloneSongPage> createState() => _StandAloneSongPageState();
}

class _StandAloneSongPageState extends State<StandAloneSongPage> {
  double _textScaleFactor = 1.0;
  int _transposeFactor = 0;
  final ScrollController _controller = ScrollController();

  final double _offsetToScroll = 256;
  final Duration _scrollDuration = const Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      Wakelock.toggle(enable: widget.black);
    } else if (!Platform.isLinux) {
      Wakelock.toggle(enable: widget.black);
    }
    var settings = Provider.of<SettingsController>(context);
    print("test");
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
            systemNavigationBarColor:
                widget.black ? Colors.black : Constants.BOTTOMAPPBAR_COLOR),
        child: Theme(
          data: widget.black
              ? Theme.of(context)
                  .copyWith(scaffoldBackgroundColor: Colors.black)
              : Theme.of(context),
          child: FutureBuilder<Song?>(
            future: SongApi.getSong(widget.song.id),
            builder: (_, snapshot) => (snapshot.data == null)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : KeyboardHelper(
                    onUp: () => _controller.animateTo(
                        _controller.offset - _offsetToScroll,
                        duration: _scrollDuration,
                        curve: Curves.ease),
                    onDown: () => _controller.animateTo(
                        _controller.offset + _offsetToScroll,
                        duration: _scrollDuration,
                        curve: Curves.ease),
                    child: Scaffold(
                      body: SafeArea(
                        child: ListView(
                          controller: _controller,
                          children: [
                            SongTitleRow(
                              song: snapshot.data!,
                              showBackButton: !Constants.isWebOrAndroid(),
                              displayBackAsCross: true,
                              tryTrimTitle: true,
                              contentPadding:
                                  const EdgeInsets.only(left: 16.0, top: 8),
                              baseTextStyle:
                                  Theme.of(context).textTheme.headline6,
                              onBackTap: () {
                                if (widget.black) {
                                  setState(() {
                                    widget.black = false;
                                  });
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            FormattedSongText(
                              songText: (settings.showChords)
                                  ? snapshot.data!.transpose(_transposeFactor)
                                  : snapshot.data!.getWithNoChords(),
                              textScaleFactor: _textScaleFactor,
                            ),
                          ],
                        ),
                      ),
                      floatingActionButton: (widget.black)
                          ? null
                          : FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  widget.black = true;
                                });
                              },
                              child: const Icon(Icons.play_arrow)),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.endDocked,
                      bottomNavigationBar: (widget.black)
                          ? null
                          : BottomAppBar(
                              color: Constants.BOTTOMAPPBAR_COLOR,
                              shape: const CircularNotchedRectangle(),
                              notchMargin: 8,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 86, top: 4, bottom: 4),
                                child: SingleChildScrollView(
                                  reverse: true,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    //alignment: MainAxisAlignment.start,
                                    children: [
                                      if (settings.showChords)
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              _transposeFactor--;
                                            });
                                          },
                                        ),
                                      if (settings.showChords)
                                        TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              snapshot.data!.getTone(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )),
                                      if (settings.showChords)
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              _transposeFactor++;
                                            });
                                          },
                                        ),
                                      if (settings.showChords)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Container(
                                            width: 1,
                                            height: 24,
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.zoom_out),
                                        onPressed: () {
                                          setState(() {
                                            _textScaleFactor -= 0.1;
                                          });
                                        },
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.zoom_in),
                                        onPressed: () {
                                          setState(() {
                                            _textScaleFactor += 0.1;
                                          });
                                        },
                                      ),
                                      /*
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          width: 1,
                                          height: 24,
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.share),
                                        onPressed: () {},
                                      ),*/
                                    ],
                                  ),
                                ),
                              )),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
