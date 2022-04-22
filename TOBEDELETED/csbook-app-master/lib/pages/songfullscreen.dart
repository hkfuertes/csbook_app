import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/Widgets/SongTextWidget.dart';
import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Settings.dart';
import 'package:flutter/material.dart';

import 'package:screen/screen.dart';

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SongFullScreen extends StatefulWidget {
  static const routeName = '/song_view_fs';

  final SongState songState;
  SongFullScreen(this.songState);

  @override
  _SongFullScreenState createState() => _SongFullScreenState(songState);
}

class SongState {
  final int transpose;
  final double fontsize;
  final Instance instance;

  SongState(this.transpose, this.fontsize, this.instance);
}

class _SongFullScreenState extends State<SongFullScreen> {
  SongState songState;
  Instance instance;

  int transpose = 0;
  double defaultFontSize = 16;
  double initfontSize, fontSize = 16;

  int _notation = Settings.NOTATION_SPANISH;

  _SongFullScreenState(this.songState);

  @override
  void initState() {
    // Prevent screen from going into sleep mode:
    Screen.keepOn(true);
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      setState(() {
        var savedNotation = sp.get(Settings.NOTATION_TOKEN);
        if (savedNotation != null && savedNotation is int)
          _notation = savedNotation;
      });
    });
  }

  Future<bool> _prepareExit() {
    Screen.keepOn(false);
    //Constants.systemBarsSetup(Theme.of(context));
    return Future.value(true);
  }

  Widget getFullscreenApp(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
            //brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: AppBarTheme(),
            textTheme: TextTheme(
              body1: TextStyle(color: Colors.white),
            )),
        child: WillPopScope(
          onWillPop: _prepareExit,
          child: Scaffold(
             appBar: AppBar(
            centerTitle: true,
            leading: 
            Center(
              child: (int.parse(instance.capo) != 0)?
              Text("C"+instance.capo.toString(), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),textAlign: TextAlign.center,)
              :Container(),
            ),
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(instance.song.title.toString()),
                  instance.song.author == null
                      ? Container()
                      : Text(
                          instance.song.author.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic),
                 ),]),
              backgroundColor: Colors.black,
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Screen.keepOn(false);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: SongText(
                  instance.transpose(transpose),
                  textSize: fontSize,
                  notation: _notation,
                ),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    instance = songState.instance;
    transpose = songState.transpose;
    fontSize = songState.fontsize;

    return getFullscreenApp(context);
  }
}
