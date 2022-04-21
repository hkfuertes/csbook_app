import 'package:csbook/src/api/parish_api.dart';
import 'package:csbook/src/panels/searchable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsPane extends StatelessWidget implements Searchable {
  final bool modal;
  SettingsPane({Key? key, this.modal = false}) : super(key: key);

  static const routeName = '/settings';

  SettingsController? controller;

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<SettingsController>(context);
    return ListView(shrinkWrap: modal, children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Ajustes",
          style: Theme.of(context).textTheme.caption,
        ),
      ),
      /*
      const ListTile(
        leading: Icon(FontAwesomeIcons.church),
        title: Text("Parroquia"),
        subtitle: Text("San Bruno"),
      ),
      */
      SwitchListTile(
          title: const Text("Mostrar notas"),
          subtitle: const Text("Ver las canciones con notas"),
          //subtitle: const Text("Notación inglesa o española"),
          value: controller!.showChords,
          onChanged: controller!.setShowChords),
      SwitchListTile(
          title: const Text("Notación Inglesa"),
          subtitle: const Text("Ver las notas en Inglés"),
          //subtitle: const Text("Notación inglesa o española"),
          value: controller!.english,
          onChanged: controller!.setEnglish),
/*
      FutureBuilder<Map<int, String>>(
        future: ParishApi.getParishes(),
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListTile(
              title: const Text("Parroquia"),
              subtitle:
                  Text(controller!.getParishName() ?? "Elige tu parroquia"),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: SingleChildScrollView(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: snapshot.data!
                                    .map((key, value) => MapEntry<int, Widget>(
                                          key,
                                          ListTile(
                                            title: Text(value),
                                            onTap: () {
                                              controller!.setParish(key, value);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ))
                                    .values
                                    .toList()),
                          ),
                        ));
              },
            );
          } else {
            return Container();
          }
        },
      ),
      */
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Información",
          style: Theme.of(context).textTheme.caption,
        ),
      ),
      const Opacity(
        opacity: 0.5,
        child: ListTile(
          dense: true,
          trailing: Icon(FontAwesomeIcons.globeEurope),
          title: Text("Servidor"),
          subtitle: Text("https://parroquias.csbook.es"),
        ),
      ),
    ]);
  }

  @override
  IconData getSearchButtonIcon() {
    return Icons.save;
  }

  @override
  void onSearchRequested(BuildContext context) {
    controller?.savePreferences().then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Configuracion guardada con éxito"),
            )));
  }
}
