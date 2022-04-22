import 'dart:async';

import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/Widgets/SongTextWidget.dart';
import 'package:csbook_app/databases/CSDB.dart';
import 'package:csbook_app/model/Chord.dart';
import 'package:csbook_app/model/Instance.dart';
import 'package:csbook_app/model/Settings.dart';
import 'package:csbook_app/model/Song.dart';
import 'package:csbook_app/pages/songfullscreen.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongScreen extends StatefulWidget {
  final Song song;
  final bool standAlone;
  final Instance instance;
  final int transpose;
  SongScreen(
      {Key key,
      this.song,
      this.standAlone = true,
      this.instance,
      this.transpose = 0})
      : super(key: key);

  @override
  _SongScreenState createState() => _SongScreenState(song, standAlone,
      instance: instance, transpose: transpose);
}

class _SongScreenState extends State<SongScreen> {
  Song _song;
  final bool _standAlone;
  Instance instance;

  int transpose = 0;
  double defaultFontSize = 16;
  double initfontSize, fontSize = 16;

  var searchBar;

  bool _controlDisplayed = false;


  _SongScreenState(this._song, this._standAlone,
      {this.instance, this.transpose});

 

  Future<List<Instance>> _retrieveInstances(Song song,
      {bool forceOnline = false}) async {
    CSDB db = CSDB();
    List<Instance> instances = new List<Instance>();
    for (int id in song.instances.keys) {
      Instance instance = await db.fetchInstance(id);
      if (instance == null || forceOnline) {
        instance = await Instance.get(id);
        db.saveOrUpdateInstance(instance);
      }
      instances.add(instance);
    }
    return instances;
  }

  Widget _loadedBody(Instance instance) {
    return Consumer<Settings>(
      builder: (context, settings, _) {
        return GestureDetector(
          onTap: () {
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SongFullScreen(
                          SongState(transpose, fontSize, instance))));
            });
          },
          child: SingleChildScrollView(
            child: SongText(instance.transpose(transpose),
                textSize: fontSize, notation: settings.notation),
          ),
        );
      },
    );
  }

  Widget _loadingAppBar() {
    return AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: _standAlone,
        title: Text(Constants.APP_TITLE));
  }

  Widget _loadedAppBar(Instance instance) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      automaticallyImplyLeading: _standAlone,
      title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  ),
          ]),
      actions: <Widget>[
        Opacity(
          opacity: 0.8,
          child: IconButton(
            icon: Icon(FontAwesomeIcons.searchMinus),
            onPressed: () {
              setState(() {
                fontSize--;
              });
            },
          ),
        ),
        Opacity(
          opacity: 0.8,
          child: IconButton(
            icon: Icon(FontAwesomeIcons.searchPlus),
            onPressed: () {
              setState(() {
                fontSize++;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _floatingActionButtonExtended() {
    return Consumer<Settings>(builder: (context, settings, _) {
      return FloatingActionButton.extended(
        backgroundColor: Colors.black,
        label: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _retrieveInstances(_song, forceOnline: true)
                    .then((List<Instance> instances) {
                  setState(() {
                    instance = instances[0];
                  });
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  transpose--;
                });
              },
            ),
            FlatButton(
              child: Text(
                //"Original " +
                instance.getTone(settings.notation == Settings.NOTATION_SPANISH
                    ? Chord.CHORD_SET_SPANISH
                    : Chord.CHORD_SET_ENGLISH),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                setState(() {
                  transpose = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  transpose++;
                });
              },
            ),
            IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () {
                  setState(() {
                    setState(() {
                      _controlDisplayed = false;
                    });
                  });
                }),
          ],
        ),
        onPressed: () {},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return (instance != null)
        ? _loadedScaffold(instance)
        : FutureBuilder<List<Instance>>(
            future: _retrieveInstances(_song),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null &&
                  snapshot.data?.length == 0) {
                return _loadingScaffold();
              } else {
                if (snapshot.data != null && snapshot.data.length > 0) {
                  instance = snapshot.data[0];
                  return _loadedScaffold(instance);
                } else
                  return _loadingScaffold();
              }
            },
          );
  }

  Widget _loadingScaffold(){
    return Scaffold(body: SafeArea(child: FetchingWidget(Constants.SONG_WAITING)),);
  }

  Widget _loadedScaffold(Instance instance){
    return Scaffold(
      appBar: _loadedAppBar(instance),
      body: Column(
        children: <Widget>[
          Expanded(
            child: RoundedBlackContainer(
              child: _loadedBody(instance),
              bottomOnly: true,
              radius: Constants.APP_RADIUS,
              displayBorder: _standAlone,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
           !_controlDisplayed
              ? FloatingActionButton(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.settings),
                  onPressed: () {
                    setState(() {
                      _controlDisplayed = true;
                    });
                  },
                )
              : _floatingActionButtonExtended(),
    );
  
  }
}
