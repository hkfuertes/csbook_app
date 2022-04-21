import 'package:csbook/src/api/mass_api.dart';
import 'package:csbook/src/model/mass.dart';
import 'package:csbook/src/pages/stand_alone_song.dart';
import 'package:csbook/src/pages/stand_alone_song_page.dart';
import 'package:flutter/material.dart';

class MassPane extends StatelessWidget {
  final Mass mass;
  const MassPane({Key? key, required this.mass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Mass>(
        future: MassApi.getMass(mass),
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView(
                children: snapshot.data!.songs
                    //.where((e) => e.song != null)
                    .map((e) => ListTile(
                          subtitle: Text(e.getSongName()),
                          title: Text(e.moment),
                          onTap: () => (e.song != null)
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => StandAloneSongPage(
                                        e.song!,
                                        massSong: e,
                                      )))
                              : null,
                        ))
                    .toList());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
