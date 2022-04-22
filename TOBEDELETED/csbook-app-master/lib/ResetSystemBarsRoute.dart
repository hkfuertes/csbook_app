import 'package:csbook_app/Constants.dart';
import 'package:flutter/material.dart';

class ResetSystemBarsRoute<T> extends MaterialPageRoute<T> {
  ResetSystemBarsRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Constants.systemBarsSetup(Theme.of(context));
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }
}
