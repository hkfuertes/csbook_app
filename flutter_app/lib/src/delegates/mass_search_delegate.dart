import 'package:csbook/src/model/mass.dart';
import 'package:csbook/src/widgets/mass_list_item.dart';
import 'package:flutter/material.dart';

class MassSearchDelegate extends SearchDelegate {
  final List<Mass> masses;
  final Function(Mass)? onTap;
  final bool autoclose;

  MassSearchDelegate(this.masses, {this.onTap, this.autoclose = false})
      : super(searchFieldLabel: "Buscar");

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          appBarTheme: super
              .appBarTheme(context)
              .appBarTheme
              .copyWith(elevation: 0.0, backgroundColor: Colors.transparent),
        );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  String _removeSpecialChars(String input) {
    var replacements = {"á": "a", "é": "e", "í": "i", "ó": "o", "ú": "u"};
    return replacements.entries
        .fold(input, (prev, e) => prev.replaceAll(e.key, e.value));
  }

  @override
  Widget buildResults(BuildContext context) {
    var filtered = masses.where((e) {
      return _removeSpecialChars(e.getName().toLowerCase())
              .contains(_removeSpecialChars(query.toLowerCase())) ||
          (e.parishName != null &&
              _removeSpecialChars(e.parishName!.toLowerCase())
                  .contains(_removeSpecialChars(query.toLowerCase()))) ||
          (_removeSpecialChars(e.getDate().toLowerCase())
              .contains(_removeSpecialChars(query.toLowerCase())));
    });

    return ListView(
        children: filtered
            .map((e) => MassListItem(
                  mass: e,
                  onTap: () {
                    if (autoclose) close(context, null);
                    if (onTap != null) onTap!(e);
                  },
                ))
            .toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
