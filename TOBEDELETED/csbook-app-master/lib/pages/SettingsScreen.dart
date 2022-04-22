import 'package:csbook_app/Api.dart';
import 'package:csbook_app/model/Parish.dart';
import 'package:csbook_app/Widgets/widgets.dart';
import 'package:csbook_app/model/Settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../Constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Parish _parish;

  int _notation = Settings.NOTATION_SPANISH;

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Ajustes"),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: RoundedBlackContainer(
          bottomOnly: true,
          radius: Constants.APP_RADIUS,
          child: ListView(
            children: <Widget>[
              //Divider(),
              ListTile(
                leading: Icon(FontAwesomeIcons.paintBrush),
                trailing: Switch(
                    activeColor: Colors.white,
                    activeTrackColor: Theme.of(context).primaryColorLight,
                    onChanged: (value) {
                      settings?.setDarkTheme(value);
                    },
                    value: settings.darkTheme ?? false),
                title: new Text(
                  'Tema oscuro',
                ),
                onTap: () {
                  settings?.setDarkTheme(!settings.darkTheme);
                },
              ),
              //Divider(),
              ListTile(
                title: Text("Parroquia"),
                subtitle:
                    Text((settings.parishId == null) ? "No seleccionado" : settings.parishName),
                leading: Icon(FontAwesomeIcons.church),
                onTap: () {
                  Parish.getAll().then((parishes) {
                    _selectParish(parishes);
                  });
                },
              ),
              //Divider(),
              ListTile(
                title: Text("Notación"),
                subtitle: Text((_notation == Settings.NOTATION_SPANISH)
                    ? "Española"
                    : "Inglesa"),
                leading: Icon(FontAwesomeIcons.music),
                onTap: () {
                  _selectNotation();
                },
              ),
              Divider(),
              ListTile(
                dense: false,
                title: Text("Direccion"),
                subtitle: Text(Api.BaseUrl),
                leading: Icon(FontAwesomeIcons.globe),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _selectParish(List<Parish> parishes) {
    showDialog(
      context: context,
      builder: (context) => Consumer<Settings>(
        builder: (context, settings, _) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(0.0),
            titlePadding: EdgeInsets.zero,
            title: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Parroquias",
                //textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            children: parishes
                .map((parish) => ListTile(
                      title: Text(parish.name),
                      onTap: () {
                        _parish = settings.setParish(parish);
                        Navigator.of(context).pop();
                      },
                    ))
                .toList(),
          );
        }
      ),
    );
  }

  void _selectNotation() {
    showDialog(
      context: context,
      builder: (context) => Consumer<Settings>(
        builder: (context, settings, _) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(0.0),
            titlePadding: EdgeInsets.zero,
            title: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Notacion",
                //textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            children: [
              RadioListTile(
                groupValue: _notation,
                value: Settings.NOTATION_ENGLISH,
                title: Text("Inglesa"),
                subtitle: Text("A, B, C, D, E, F, G"),
                onChanged: (value) {
                  _notation = settings.setNotation(value);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile(
                groupValue: _notation,
                value: Settings.NOTATION_SPANISH,
                title: Text("Española"),
                subtitle: Text("La, Si, Do, Re, Mi, Fa, Sol"),
                onChanged: (value) {
                  _notation = settings.setNotation(value);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      ),
    );
  }
}
