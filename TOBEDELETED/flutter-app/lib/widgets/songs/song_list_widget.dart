import 'package:ccnero_app/api_old/song_api.dart';
import 'package:ccnero_app/model/lyric.dart';
import 'package:ccnero_app/widgets/info_pane.dart';
import 'package:ccnero_app/widgets/songs/song_search_delegate.dart';
import 'package:flutter/material.dart';

class SongListWidget extends StatefulWidget {
  final Function(Lyric) onTap;
  SongListWidget(this.onTap);

  @override
  State<SongListWidget> createState() => _SongListWidgetState();
}

class _SongListWidgetState extends State<SongListWidget> {
  Key? _futureKey;
  bool _searching = false;
  List<Lyric> _lyrics = [], _filtered = [];
  TextEditingController _searchBoxController = TextEditingController();

  @override
  void initState() {
    _getSongs();
    super.initState();
  }

  _getSongs() {
    SongApi.getLyrics().then((value) {
      setState(() {
        _lyrics = value;
        _filtered = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _getSongs();
        });
      },
      child: _lyrics.isNotEmpty
          ? Column(
              //fit: StackFit.expand,
              children: [
                Expanded(
                  child: ListView(
                      children: _filtered
                          .map((e) => LyricTile(e, (lyric) {
                                FocusScope.of(context).unfocus();
                                widget.onTap(lyric);
                                setState(() {
                                  //_searching = false;
                                  //_filtered = _lyrics;
                                });
                              }))
                          .toList()),
                ),
                /*!_searching
                    ? Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                          backgroundColor: Colors.grey,
                          onPressed: () {
                            //showSearch(context: context, delegate: SongSearchDelegate());
                            setState(() {
                              _searching = true;
                            });
                          },
                          child: Icon(Icons.search),
                        ),
                      )
                    : */
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                            controller: _searchBoxController,
                            onChanged: (value) {
                              setState(() {
                                _filtered = _lyrics
                                    .where((element) => element.title
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                                hintText: "Buscar",
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                //contentPadding: EdgeInsets.only(top: 8.0),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                )))),
                    if (_searchBoxController.value.text != "")
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _searching = false;
                              _filtered = _lyrics;
                              FocusScope.of(context).unfocus();
                              _searchBoxController.clear();
                            });
                          },
                          icon: Icon(Icons.close))
                  ],
                )
              ],
            )
          : InfoPane(iconData: Icons.download, text: "Obteniendo el listado"),
    );
  }
}

class LyricTile extends StatelessWidget {
  final Lyric lyric;
  final Function(Lyric) onTap;
  LyricTile(this.lyric, this.onTap);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(lyric.title),
      subtitle: lyric.author == null ? null : Text(lyric.author!),
      onTap: () {
        onTap(lyric);
      },
    );
  }
}
