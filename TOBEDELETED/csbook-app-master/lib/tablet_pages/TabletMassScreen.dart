import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:csbook_app/model/Chord.dart';
import 'package:csbook_app/pages/MassSongFullScreen.dart';
import 'package:csbook_app/pages/SongScreen.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:share/share.dart';

import '../Api.dart';

class TabletMassScreen extends StatefulWidget {
  Mass mass;
  TabletMassScreen(this.mass);
  @override
  _TabletMassScreenState createState() => _TabletMassScreenState(mass);
}

class _TabletMassScreenState extends State<TabletMassScreen> {
  Mass _mass;

  Widget _selectedSong = Container();

  _TabletMassScreenState(this._mass);

  int _currentMoment = 0;
  bool _showChords = false;

  final DateFormat formatterFullDate = new DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    getInstances(_mass);
  }

  void getInstances(Mass mass) {
    mass.retrieveAllInstances().then((Mass mass) {
      setState(() {
        _mass = mass;
      });
    });
  }

  void _openFullScreenMass() {
    /*
    int transpose = Chord(massSong.getInstance().tone)
        .semiTonesDiferentWith(Chord(massSong.tone));
    */
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MassSongFullScreen(),
        settings: RouteSettings(arguments: _mass)));
  }

  Widget _createListView(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          accentColor: (Theme.of(context).brightness == Brightness.dark)
              ? Colors.white
              : Colors.black),
      child: ListView(
        children: _mass.songs.map((MassSong ms) {
          return ListTile(
            title: Text(
              ms.moment,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              ms.getInstance().song.getTitle(),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            onTap: () {
              setState(() {
                _selectedSong = SongScreen(
                    key: Key(ms.getInstance().song.id.toString()),
                    song: ms.getInstance().song,
                    instance: ms.getInstance(),
                    transpose: Chord(ms.getInstance().tone).semiTonesDiferentWith(Chord(ms.tone)),
                    standAlone: false);
              });
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RoundedBlackContainer(
      bottomOnly: true,
      radius: Constants.APP_RADIUS,
      child: Row(
        children: <Widget>[
          Container(
            child: _makeBody(),
            width: MediaQuery.of(context).size.width * 0.35,
          ),
          Container(
            child: _selectedSong,
            width: MediaQuery.of(context).size.width * 0.65,
          )
        ],
      ),
    );
  }

  Widget _makeBody() {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            _mass.hasName() ? _mass.name : formatterFullDate.format(_mass.date),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.share,
              ),
              onPressed: () {
                Share.share(Api.BaseUrl + "mass/view/" + _mass.id);
              },
            ),
            _mass.instancesRecovered()
                ? IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      _openFullScreenMass();
                    },
                  )
                : Container()
          ],
        ),
        body: _mass.instancesRecovered()
            ? _createListView(context)
            : FetchingWidget(Constants.SONGS_WAITING));
  }
}
