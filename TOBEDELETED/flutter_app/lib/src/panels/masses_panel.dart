import 'package:csbook/src/api/mass_api.dart';
import 'package:csbook/src/model/mass.dart';
import 'package:csbook/src/model/song.dart';
import 'package:csbook/src/panels/song_pane.dart';
import 'package:csbook/src/widgets/info_pane.dart';
import 'package:csbook/src/widgets/search_row.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class MassesPanel extends StatefulWidget {
  const MassesPanel({Key? key}) : super(key: key);

  @override
  State<MassesPanel> createState() => _MassesPanelState();
}

class _MassesPanelState extends State<MassesPanel> {
  List<Mass>? _masses;
  final TextEditingController _searchController = TextEditingController();
  String? _query;
  Mass? _selectedMass;
  MassSong? _selectedMassSong;

  Map<String, List<Mass>> _sortMasses(List<Mass> masses) {
    Map<String, List<Mass>> retVal = {};
    masses.forEach((e) {
      var key = DateFormat("MM_yyyy").format(e.date);
      if (retVal.containsKey(key)) {
        retVal[key]!.add(e);
      } else {
        retVal.putIfAbsent(key, () => [e]);
      }
    });
    return retVal;
  }

  Future<void> _getMasses() async {
    var masses = await MassApi.getMasses();
    setState(() {
      _masses = masses;
    });
  }

  Future<void> _getMass(Mass mass) async {
    setState(() {
      _selectedMass = null;
    });
    var filledMass = await MassApi.getMass(mass);
    setState(() {
      _selectedMass = filledMass;
    });
  }

  @override
  void initState() {
    super.initState();
    if (_masses == null) {
      _getMasses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildLarge(context);
  }

  Widget buildLarge(BuildContext context) {
    return _masses == null
        ? InfoPane(iconData: FontAwesomeIcons.church, text: "Obteniendo misas")
        : Row(
            children: [
              Container(
                child: _buildMassList(),
                width: 375,
                decoration: BoxDecoration(
                    border: Border(
                        right:
                            BorderSide(color: Colors.grey.withOpacity(0.5)))),
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border(
                          right:
                              BorderSide(color: Colors.grey.withOpacity(0.5)))),
                  width: 375,
                  child: _selectedMass != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          _selectedMass!.getName(),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _selectedMass!.getDate(),
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16),
                                        ),
                                        Container()
                                      ]),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Expanded(
                                  child: ListView(
                                    controller: ScrollController(),
                                    children: _selectedMass!.songs
                                        //.where((e) => e.song != null)
                                        .map((e) => ListTile(
                                              title: Text(e.getSongName()),
                                              subtitle: Text(e.moment),
                                              onTap: () {
                                                setState(() {
                                                  _selectedMassSong = e;
                                                });
                                              },
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              child: FloatingActionButton(
                                child: Icon(Icons.play_arrow),
                                onPressed: () {},
                              ),
                              bottom: 16,
                              right: 16,
                            )
                          ],
                        )
                      : Container()),
              Expanded(
                  child: _selectedMassSong != null
                      ? SongPane(_selectedMassSong!.song!)
                      : Container()),
            ],
          );
  }

  Column _buildMassList() {
    return Column(
      children: [
        SearchRow(
          searchController: _searchController,
          onChange: (value) {
            setState(() {
              _query = value;
            });
          },
          onClose: () {
            setState(() {
              _query = null;
            });
          },
        ),
        Expanded(
          child: ListView(
            children: _masses!
                .map((e) => ListTile(
                      subtitle: Text(e.getDate()),
                      title: Text(e.getName()),
                      onTap: () => _getMass(e).then((_) => null),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
