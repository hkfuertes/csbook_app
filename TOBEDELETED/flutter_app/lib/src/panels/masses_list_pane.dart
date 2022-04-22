import 'package:csbook/src/api/mass_api.dart';
import 'package:csbook/src/delegates/mass_search_delegate.dart';
import 'package:csbook/src/model/mass.dart';
import 'package:csbook/src/pages/stand_alone_mass.dart';
import 'package:csbook/src/panels/searchable.dart';
import 'package:csbook/src/widgets/mass_list_item.dart';
import 'package:flutter/material.dart';

class MassesListPane extends StatelessWidget implements Searchable {
  MassSearchDelegate? msd;
  MassesListPane({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Mass>>(
        future: MassApi.getMasses(),
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            msd = MassSearchDelegate(snapshot.data!, onTap: (mass) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => StandAloneMass(mass: mass)));
            });
            return ListView(
              children: snapshot.data!
                  .map((e) => MassListItem(
                        mass: e,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => StandAloneMass(mass: e)));
                        },
                      ))
                  .toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  void onSearchRequested(BuildContext context) {
    if (msd != null) showSearch(context: context, delegate: msd!);
  }

  @override
  IconData getSearchButtonIcon() {
    return Icons.search;
  }
}
