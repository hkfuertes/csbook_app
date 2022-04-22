// ignore_for_file: unnecessary_const

import 'dart:io';

import 'package:csbook/src/api/mass_api.dart';
import 'package:csbook/src/constants.dart';
import 'package:csbook/src/helpers/KeyboardHelper.dart';
import 'package:csbook/src/model/mass.dart';
import 'package:csbook/src/model/song_state.dart';
import 'package:csbook/src/settings_controller.dart';
import 'package:csbook/src/widgets/formatted_song_text.dart';
import 'package:csbook/src/widgets/song_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:wakelock/wakelock.dart';

class MassPlayer extends StatefulWidget {
  final Mass mass;
  const MassPlayer({Key? key, required this.mass}) : super(key: key);

  @override
  State<MassPlayer> createState() => _MassPlayerState();
}

class _MassPlayerState extends State<MassPlayer> {
  int _currentSong = 0;
  final PageController _controller = PageController(initialPage: 0);
  final Duration _transitionDuration = const Duration(milliseconds: 500);
  final Curve _transitionCurve = Curves.ease;

  final ScrollController _scrollController = ScrollController();
  final double _offsetToScroll = 256;
  final Duration _scrollDuration = const Duration(milliseconds: 500);

  double scaleFactor = 1.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var settings = Provider.of<SettingsController>(context);
    _stayAwake(enabled: true);
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.black),
        child: Theme(
            data: Theme.of(context)
                .copyWith(scaffoldBackgroundColor: Colors.black),
            child: WillPopScope(
              onWillPop: () async {
                _stayAwake(enabled: false);
                return true;
              },
              child: SafeArea(
                child: FutureBuilder<Mass>(
                    future: MassApi.getMass(widget.mass),
                    builder: (_, snapshot) {
                      return KeyboardHelper(
                        onUp: () => _scrollController.animateTo(
                            _scrollController.offset - _offsetToScroll,
                            duration: _scrollDuration,
                            curve: Curves.ease),
                        onDown: () => _scrollController.animateTo(
                            _scrollController.offset + _offsetToScroll,
                            duration: _scrollDuration,
                            curve: Curves.ease),
                        child: Scaffold(
                          body: (snapshot.hasData && snapshot.data != null)
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    PageView(
                                      //physics:const NeverScrollableScrollPhysics(),
                                      controller: _controller,
                                      onPageChanged: (npage) {
                                        setState(() {
                                          _currentSong = npage;
                                        });
                                      },
                                      children: snapshot.data!.songs
                                          .map((e) => SingleChildScrollView(
                                                controller: _scrollController,
                                                child: FormattedSongText(
                                                    textScaleFactor:
                                                        scaleFactor,
                                                    songText: (settings
                                                            .showChords)
                                                        ? e.song!.transposeTo(
                                                            e.tone!)
                                                        : e.song!
                                                            .getWithNoChords()),
                                              ))
                                          .toList(),
                                    ),
                                    _buildButton(
                                      context,
                                      onTheLeft: false,
                                      enabled: (_currentSong <
                                          snapshot.data!.songs.length - 1),
                                      onTap: () {
                                        _controller.nextPage(
                                            duration: _transitionDuration,
                                            curve: _transitionCurve);
                                      },
                                    ),
                                    _buildButton(
                                      context,
                                      enabled: (_currentSong > 0),
                                      onTap: () {
                                        _controller.previousPage(
                                            duration: _transitionDuration,
                                            curve: _transitionCurve);
                                      },
                                    ),
                                  ],
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                          bottomNavigationBar:
                              (snapshot.hasData && snapshot.data != null)
                                  ? _buildBottomBar(snapshot.requireData)
                                  : null,
                        ),
                      );
                    }),
              ),
            )));
  }

  Widget _buildButton(BuildContext context,
      {onTap, bool onTheLeft = true, bool? enabled}) {
    double sideMargin = 6;
    double hitbox = 32;
    return Positioned(
      bottom: MediaQuery.of(context).size.height * .05,
      top: MediaQuery.of(context).size.height * .6,
      left: onTheLeft ? 0 : null,
      right: onTheLeft ? null : 0,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (enabled != null && enabled) ? onTap : null,
        child: Padding(
          padding: EdgeInsets.only(
              left: (onTheLeft) ? sideMargin : hitbox,
              right: (onTheLeft) ? hitbox : sideMargin),
          child: Container(
            width: 2,
            color: (enabled != null && enabled)
                ? Colors.white
                : Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  BottomAppBar _buildBottomBar(Mass mass) {
    return BottomAppBar(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(
              minHeight: 1,
              value: (_currentSong + 1) / (mass.songs.length),
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
            ),
            Row(children: [
              Expanded(
                child: ListTile(
                  leading: (!Constants.isWebOrAndroid())
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      : null,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (mass.songs[_currentSong].capo != null &&
                          mass.songs[_currentSong].capo! > 0)
                        Container(
                          margin: const EdgeInsets.only(right: 8.0),
                          padding: const EdgeInsets.only(right: 8.0),
                          decoration: const BoxDecoration(
                              border: const Border(
                                  right:
                                      const BorderSide(color: Colors.white))),
                          child: Text(
                            " C" +
                                mass.songs[_currentSong].capo.toString() +
                                "",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                mass.songs[_currentSong].moment.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                              Opacity(
                                opacity: 0.7,
                                child: Text(
                                  mass.songs[_currentSong].song!.title,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                            ]),
                      ),
                      const Icon(Icons.font_download),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            scaleFactor -= 0.1;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            scaleFactor += 0.1;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  _stayAwake({enabled}) {
    if (kIsWeb) {
      Wakelock.toggle(enable: enabled);
    } else if (!Platform.isLinux) {
      Wakelock.toggle(enable: enabled);
    }
  }
}
