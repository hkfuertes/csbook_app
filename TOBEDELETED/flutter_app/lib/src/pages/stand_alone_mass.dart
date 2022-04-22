import 'package:csbook/src/constants.dart';
import 'package:csbook/src/model/mass.dart';
import 'package:csbook/src/pages/mass_player.dart';
import 'package:csbook/src/panels/mass_pane.dart';
import 'package:csbook/src/widgets/mass_list_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StandAloneMass extends StatelessWidget {
  final Mass mass;
  const StandAloneMass({Key? key, required this.mass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Constants.BOTTOMAPPBAR_COLOR),
      child: Scaffold(
        body: SafeArea(
          child: MassPane(mass: mass),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.play_arrow),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => MassPlayer(
                      mass: mass,
                    )));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
            color: Constants.BOTTOMAPPBAR_COLOR,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: Padding(
              padding: const EdgeInsets.only(top: 6, right: 64.0),
              child: MassListItem(
                mass: mass,
                onBackTap: (Constants.isWebOrAndroid())
                    ? null
                    : () {
                        Navigator.of(context).pop();
                      },
              ),
            )),
      ),
    );
  }
}
