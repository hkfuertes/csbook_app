import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/Widgets/SongTextWidget.dart';
import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Chord.dart';
import 'package:csbook_app/model/Settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:screen/screen.dart';

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class MassSongFullScreen extends StatefulWidget {
  static const routeName = '/song_view_fs';

  @override
  _MassSongFullScreenState createState() => _MassSongFullScreenState();
}

class _MassSongFullScreenState extends State<MassSongFullScreen> {
  Instance _instance;

  int _transpose = 0;
  double defaultFontSize = 16;
  double initfontSize, fontSize = 16;

  int _notation = Settings.NOTATION_SPANISH;

  Mass _mass;

  int _currentSong = 0;

  PageController _pageController = PageController();

  _MassSongFullScreenState();

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
      data: Constants.getBlackTheme(context),
      child: WillPopScope(
        onWillPop: _prepareExit,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: 
            Center(
              child: (_mass.songs[_currentSong].capo != 0)?
              Text("C"+_mass.songs[_currentSong].capo.toString(), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),textAlign: TextAlign.center,)
              :Container(),
            ),
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_mass.songs[_currentSong].instance.song.title.toString()),
                  _mass.songs[_currentSong].instance.song.author == null
                      ? Container()
                      : Text(
                          _mass.songs[_currentSong].instance.song.author.toString(),
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
            bottomNavigationBar: Opacity(
              opacity: 0.8,
              child: BottomAppBar(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _pageController.previousPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.searchMinus),
                        onPressed: () {
                          setState(() {
                            fontSize -= 2;
                          });
                        },
                      ),
                      Text(
                        _mass.songs[_currentSong].moment,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        //textAlign: TextAlign.center,
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.searchPlus),
                        onPressed: () {
                          setState(() {
                            fontSize += 2;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: PageView(
              controller: _pageController,
              onPageChanged: (pageNum) {
                setState(() {
                  _currentSong = pageNum;
                });
              },
              key: Key(_mass.id),
              children: _mass.songs.map((ms) => _createPage(ms)).toList(),
            )),
      ),
    );
  }

  Widget _createPage(MassSong ms) {
    var instance = ms.getInstance();
    var transpose = Chord(instance.tone).semiTonesDiferentWith(Chord(ms.tone));
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: SongText(
          instance.transpose(transpose),
          textSize: fontSize,
          notation: _notation,
          //alignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_mass == null) {
      _mass = ModalRoute.of(context).settings.arguments;
      _currentSong = 0;
    }

    return _mass != null ? getFullscreenApp(context) : Container();
  }
}
