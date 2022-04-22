import 'package:csbook/src/constants.dart';
import 'package:csbook/src/panels/masses_list_pane.dart';
import 'package:csbook/src/panels/searchable.dart';
import 'package:csbook/src/panels/songs_list_pane.dart';
import 'package:csbook/src/panels/settings_pane.dart';
import 'package:csbook/src/widgets/logo.dart';
import 'package:csbook/src/widgets/toggle_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Displays detailed information about a SampleItem.
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final Map<String, Widget> _pages = {
    "Canciones": SongsListPane(),
    "Misas": MassesListPane(),
    "Ajustes": SettingsPane()
  };

  _MainPageState();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Constants.BOTTOMAPPBAR_COLOR), //#ff303332
      child: Scaffold(
        body: SafeArea(child: _pages.values.toList()[_selectedIndex]),
        floatingActionButton: FloatingActionButton(
          child: ((_pages.values.toList()[_selectedIndex] is Searchable))
              ? Icon((_pages.values.toList()[_selectedIndex] as Searchable)
                  .getSearchButtonIcon())
              : const Icon(Icons.search),
          onPressed: () {
            if (_pages.values.toList()[_selectedIndex] is Searchable) {
              (_pages.values.toList()[_selectedIndex] as Searchable)
                  .onSearchRequested(context);
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
            color: Constants.BOTTOMAPPBAR_COLOR,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: LayoutBuilder(builder: (context, constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  (constraints.maxWidth < 380)
                      ? const Padding(
                          padding:
                              EdgeInsets.only(left: 12, right: 12, top: 12),
                          child: Icon(FontAwesomeIcons.dove),
                        )
                      : Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 8),
                          child: Logo(
                            subtitle: Opacity(
                                opacity: 0.7,
                                child: Text(
                                  _pages.keys.toList()[_selectedIndex],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w100),
                                )),
                          ),
                        ),
                  ToggleIconButton(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    toggled: _selectedIndex == 0,
                    iconData: Icons.list,
                  ),
                  ToggleIconButton(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      toggled: _selectedIndex == 1,
                      iconData: FontAwesomeIcons.bible,
                      iconSize: 16),
                  ToggleIconButton(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                      /*
                        showBottomSheet(
                            context: context,
                            builder: (_) => SettingsView(modal: true));
                        */
                    },
                    toggled: _selectedIndex == 2,
                    iconData: Icons.settings,
                    unToggledIconData: Icons.settings_outlined,
                  ),
                ],
              );
            })),
      ),
    );
  }
}
