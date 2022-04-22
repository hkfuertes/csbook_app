import 'package:ccnero_app/widgets/logo_text.dart';
import 'package:ccnero_app/widgets/songs/song_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).scaffoldBackgroundColor,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor),
      child: Scaffold(
          body: SafeArea(
        child: Row(
          children: [_buildSideMenu(), Expanded(child: SongList())],
        ),
      )),
    );
  }

  Container _buildSideMenu() {
    return Container(
      decoration: BoxDecoration(
        //color: Theme.of(context).primaryColorDark
        border: Border(
            right: BorderSide(color: Colors.white.withOpacity(0.0), width: 2)),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.dove),
          RotatedBox(
            quarterTurns: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LogoText(),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.music)),
          IconButton(onPressed: null, icon: Icon(FontAwesomeIcons.bible)),
          /*Expanded(
            child: Container(),
          ),*/
          Container(
            height: 32.0,
          ),
          IconButton(onPressed: null, icon: Icon(Icons.settings))
        ],
      ),
    );
  }
}
