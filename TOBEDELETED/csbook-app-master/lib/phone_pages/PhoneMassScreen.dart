import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:csbook_app/pages/MassSongFullScreen.dart';
import 'package:flutter/material.dart';

import 'package:csbook_app/Widgets/SongTextWidget.dart';
import 'package:intl/intl.dart';

import 'package:share/share.dart';

import '../Api.dart';

class PhoneMassScreen extends StatefulWidget {
  static const routeName = '/mass_view';

  Mass mass;
  PhoneMassScreen(this.mass);

  @override
  _PhoneMassScreenState createState() => _PhoneMassScreenState(mass);
}

class _PhoneMassScreenState extends State<PhoneMassScreen> {
  Mass _mass;

  _PhoneMassScreenState(this._mass);

  final DateFormat formatterFullDate = new DateFormat('dd/MM/yyyy');

  void _openFullScreenMass() {
    /*
    int transpose = Chord(massSong.getInstance().tone)
        .semiTonesDiferentWith(Chord(massSong.tone));
    */
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MassSongFullScreen(),
        settings: RouteSettings(arguments: _mass)));
  }

  Widget _createListView(BuildContext context, Mass _mass) {
    return Theme(
      data: Theme.of(context).copyWith(
          accentColor: (Theme.of(context).brightness == Brightness.dark)
              ? Colors.white
              : Colors.black),
      child: ListView(
        children: _mass.songs.map((MassSong ms) {
          return ExpansionTile(
            title: ListTile(
              title: Text(
                ms.moment,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                ms.getInstance().song.getTitle(),
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),

            //leading: Icon(Icons.arrow_drop_down_circle),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      BoxShadow(
                        color: Theme.of(context).backgroundColor,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: SongText(ms.getInstance().removeChords()),
                ),
              )
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _loadingScaffold(){
    return Scaffold(body: SafeArea(child: FetchingWidget(Constants.SONGS_WAITING)),);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Mass>(
      future: _mass.retrieveAllInstances(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return _loadingScaffold();
        } else {
          _mass = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  _mass.hasName()
                      ? _mass.name
                      : Constants.MASS_VIEW_TITLE +
                          formatterFullDate.format(_mass.date),
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
              body: RoundedBlackContainer(
                child: _mass.instancesRecovered()
                    ? _createListView(context, _mass)
                    : FetchingWidget(Constants.SONGS_WAITING),
                bottomOnly: true,
                radius: Constants.APP_RADIUS,
              ));
        }
      },
    );
  }
}
