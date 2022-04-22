import 'package:csbook/src/model/mass.dart';
import 'package:flutter/material.dart';

class MassListItem extends StatelessWidget {
  final Mass mass;
  final Function()? onTap;
  final bool forceTwolines;
  final bool dense;
  final Function()? onBackTap;
  const MassListItem(
      {Key? key,
      required this.mass,
      this.onTap,
      this.forceTwolines = false,
      this.dense = false,
      this.onBackTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: (onBackTap != null)
          ? IconButton(onPressed: onBackTap, icon: const Icon(Icons.arrow_back))
          : null,
      dense: dense,
      isThreeLine: (mass.parishName != null) && !forceTwolines,
      subtitle: (mass.parishName != null) && !forceTwolines
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                  Text(mass.parishName!),
                  Opacity(
                      opacity: 0.5,
                      child: Text(
                        mass.getDate(),
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ))
                ])
          : Text(mass.getDate()),
      title: Text(
        mass.getName(),
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}
