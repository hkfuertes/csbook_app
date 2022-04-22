import 'package:flutter/material.dart';

class LogoText extends StatelessWidget {
  const LogoText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textSize = 24.0;
    return Row(
      children: [
        Text(
          "CC",
          style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
        ),
        Text("NERO",
            style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w100)),
      ],
    );
  }
}
