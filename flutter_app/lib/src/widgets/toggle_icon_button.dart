import 'package:flutter/material.dart';

class ToggleIconButton extends StatelessWidget {
  final Function() onTap;
  final bool toggled;
  final IconData iconData;
  final IconData? unToggledIconData;
  final double? iconSize;
  const ToggleIconButton(
      {Key? key,
      required this.onTap,
      required this.toggled,
      required this.iconData,
      this.iconSize,
      this.unToggledIconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  width: 2.0,
                  color: (toggled) ? Colors.white : Colors.transparent))),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Opacity(
          child: IconButton(
              onPressed: onTap,
              icon: Icon(
                toggled ? iconData : unToggledIconData ?? iconData,
                size: iconSize,
              )),
          opacity: (toggled) ? 1 : 0.5,
        ),
      ),
    );
  }
}
