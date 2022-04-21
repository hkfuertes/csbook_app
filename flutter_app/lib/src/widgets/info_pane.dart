import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InfoPane extends StatelessWidget {
  final IconData iconData;
  final String text;
  InfoPane({required this.iconData, required this.text});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Opacity(
          opacity: 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: constraints.maxWidth / 4,
              ),
              Container(
                height: 32,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontSize: constraints.maxHeight / 32,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
