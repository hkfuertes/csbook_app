import 'package:csbook/src/api/song_api.dart';
import 'package:csbook/src/constants.dart';
import 'package:csbook/src/model/mass.dart';
import 'package:csbook/src/model/song.dart';
import 'package:csbook/src/model/song_state.dart';
import 'package:csbook/src/settings_controller.dart';
import 'package:csbook/src/widgets/song_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SongPane extends StatefulWidget {
  final bool viewMode;
  final Song song;
  final MassSong? massSong;
  final bool showTitle;
  final Function()? onBlackModeRequested;
  final Function()? onBackPressed;
  SongPane(this.song,
      {this.viewMode = false,
      this.massSong,
      this.onBlackModeRequested,
      this.showTitle = true,
      this.onBackPressed});

  @override
  State<SongPane> createState() => _SongPaneState();
}

class _SongPaneState extends State<SongPane> {
  SongState songState = SongState();
  double _textScaleFactor = 1.0;
  int _semitonesFactor = 0;

  SettingsController? settings;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Song?>(
        future: SongApi.getSong(widget.song.id),
        builder: (context, snapshot) => snapshot.hasData
            ? _buildBody(context, snapshot.data!)
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget _buildBody(BuildContext context, Song song) {
    settings = Provider.of<SettingsController>(context);
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomRight,
      children: [
        SongTextWidget(
            song: song,
            textScaleFactor: _textScaleFactor,
            semitonesFactor: _semitonesFactor,
            english: settings!.english,
            showChords: settings!.showChords,
            onTap: () {
              if (!widget.viewMode) {
                if (widget.onBlackModeRequested != null) {
                  widget.onBlackModeRequested!();
                }
              }
            }),
        Positioned(
            right: 0, bottom: 0, child: _buildSettingsPane(context, song)),
      ],
    );
  }

  Widget _buildSettingsPane(context, Song song) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight.withOpacity(0.2),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!widget.viewMode)
              Column(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _textScaleFactor += 0.1;
                        });
                      },
                      icon: const Icon(Icons.zoom_in)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _textScaleFactor = 1.0;
                        });
                      },
                      icon: const Icon(Icons.fullscreen)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _textScaleFactor -= 0.1;
                        });
                      },
                      icon: const Icon(Icons.zoom_out)),
                  Container(
                    height: 32,
                  ),
                  if (settings?.showChords ?? true)
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _semitonesFactor++;
                          });
                        },
                        icon: const Icon(Icons.add)),
                  if (settings?.showChords ?? true)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _semitonesFactor = 0;
                          });
                        },
                        child: Text(
                          song.getTone(),
                          style: const TextStyle(color: Colors.white),
                        )),
                  if (settings?.showChords ?? true)
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _semitonesFactor--;
                          });
                        },
                        icon: const Icon(Icons.remove)),
                  Container(
                    height: 32,
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: const Icon(Icons.refresh)),
                  //IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                ],
              ),
            //Only if back is needed
            if (!Constants.isWebOrAndroid())
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  if (widget.onBackPressed != null) {
                    widget.onBackPressed!();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
