import 'package:csbook_app/Constants.dart';
import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/model/Parish.dart';
import 'package:csbook_app/Widgets/NavigationDrawer.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:csbook_app/model/Settings.dart';
import 'package:csbook_app/pages/MassScreen.dart';
import 'package:csbook_app/pages/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class ParishPage extends StatefulWidget {
  @override
  _ParishPageState createState() => _ParishPageState();
}

class _ParishPageState extends State<ParishPage> {

  final DateFormat formatterFullDate = new DateFormat('dd/MM/yyyy');


  Parish _parish;

  List<Widget> getActions(BuildContext context) {
    return [Builder(builder: (context) => Container())];
  }

  Widget makeBody() {
    return Consumer<Settings>(
      builder: (context, settings, _) {
        _parish = settings.getParish();
        return FutureBuilder(
            future: Mass.get(parishId: _parish.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null && snapshot.data?.length == 0) {
                return _selectParishWidget(context);
              } else {
                return ListView.builder(
                    itemCount: (snapshot.data==null) ? 0: snapshot.data.length,
                    itemBuilder: (BuildContext context, int position) {
                      return MassTile(
                        snapshot.data[position],
                        onTap: (mass) {
                          print(mass.songs);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MassScreen(mass)));
                        },
                      );
                    });
              }
            });
      },
    );
  }

  Widget _selectParishWidget(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.download,
            size: 128,
            color: Theme.of(context).primaryColorLight,
          ),
          Container(
            height: 32,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Constants.FETCHING_TEXT + Constants.PARISH_WAITING + " ...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ),
          FlatButton(
            child: Text("Seleccionar parroquia",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: Theme.of(context).primaryColorLight,
                )),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SettingsScreen()));
            },
          ),
          FlatButton(
            child: Text("Refrescar",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: Theme.of(context).primaryColorLight,
                )),
            onPressed: () {
              setState(() {});
            },
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    //Constants.systemBarsSetup(Theme.of(context));

    return Scaffold(
      appBar: AppBar(
        title: Text("Misas"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: getActions(context),
      ),
      body: RoundedBlackContainer(
          bottomOnly: true, radius: Constants.APP_RADIUS, child: makeBody()),
      drawer: NavigationDrawer.drawer(context,
          end: false, currentPage: NavigationDrawer.PARISH_PAGE),
      endDrawer: NavigationDrawer.drawer(context,
          end: true, currentPage: NavigationDrawer.PARISH_PAGE),
    );
  }

}
