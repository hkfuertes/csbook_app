import 'package:csbook_app/TabletDetector.dart';
import 'package:csbook_app/phone_pages/PhoneListPage.dart';
import 'package:csbook_app/tablet_pages/TabletListPage.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => (Orientation.landscape == orientation && TabletDetector.isTablet(MediaQuery.of(context)))
          ? TabletListPage()
          : PhoneListPage(),
    );
  }
}
