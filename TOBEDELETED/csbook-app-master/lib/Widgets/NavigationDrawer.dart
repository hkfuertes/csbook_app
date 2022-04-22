import 'package:csbook_app/NoAnimationRoute.dart';
import 'package:csbook_app/pages/ListPage.dart';
import 'package:csbook_app/pages/ParishPage.dart';
import 'package:csbook_app/pages/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigationDrawer  {
  static const LIST_PAGE = 0x01;
  static const PARISH_PAGE = 0x02;
 
 static Widget drawer(BuildContext context, {end, currentPage}) {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              end ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            end
                ? Expanded(
                    child: Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).backgroundColor,
                    ),
                  )
                : Container(),
            Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).primaryColorDark
                  : Theme.of(context).backgroundColor,
              height: MediaQuery.of(context).padding.top,
            ),
            Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).primaryColorDark
                  : Theme.of(context).backgroundColor,
              child: ListTile(
                title: Text(
                  "CSBook",
                  style:
                      Theme.of(context).textTheme.title.copyWith(fontSize: 32),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                  ),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).primaryColorLight,
              height: 2,
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.music,
              ),
              title: new Text(
                'Canciones',
              ),
              onTap: () {
                Navigator.of(context).pop();
                if(currentPage != LIST_PAGE)
                  Navigator.of(context).pushReplacement(NoAnimationRoute(builder: (context) => ListPage()));
              },
            ),
            ListTile(
              leading: new Icon(
                FontAwesomeIcons.bible,
              ),
              title: new Text(
                'Misas',
              ),
              onTap: () {
                Navigator.of(context).pop();
                if(currentPage != PARISH_PAGE)
                  Navigator.of(context).pushReplacement(NoAnimationRoute(builder: (context) => ParishPage()));
              },
            ),
            ListTile(
              leading: new Icon(
                Icons.settings,
              ),
              title: new Text(
                'Ajustes',
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            end
                ? Container(
                    height: 64,
                  )
                : Expanded(
                    child: Container(),
                  ),
            Padding(
              child: Opacity(
                  opacity: 0.4,
                  child: Text(
                    "hkfuertes",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )),
              padding: EdgeInsets.all(16),
            ),
            Container(height:4, color: Theme.of(context).primaryColorLight)
          ],
        ),
      ),
    );
  }


}