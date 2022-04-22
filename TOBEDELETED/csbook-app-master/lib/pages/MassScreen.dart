import 'package:csbook_app/model/Mass.dart';
import 'package:csbook_app/TabletDetector.dart';
import 'package:csbook_app/phone_pages/PhoneMassScreen.dart';
import 'package:csbook_app/tablet_pages/TabletMassScreen.dart';
import 'package:flutter/material.dart';

class MassScreen extends StatelessWidget {
  final Mass mass;
  MassScreen(this.mass);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => (orientation == Orientation.landscape && TabletDetector.isTablet(MediaQuery.of(context)))
          ? TabletMassScreen(mass)
          : PhoneMassScreen(mass),
    );
  }
}
