import 'package:csbook/src/model/chord.dart';
import 'package:flutter/material.dart';

class FormattedSongText extends StatefulWidget {
  static const NOTATION_SPANISH = 0x01;
  static const NOTATION_ENGLISH = 0x02;

  FormattedSongText(
      {required this.songText,
      this.textSize = 16,
      this.notation = NOTATION_SPANISH,
      this.alignment = CrossAxisAlignment.start,
      this.textScaleFactor = 1.0,
      this.backgroundColor = Colors.transparent,
      this.onTap,
      this.onPinch});
  final String songText;
  final double textSize;
  final int notation;
  final CrossAxisAlignment alignment;
  final Function()? onTap;
  final Function(double)? onPinch;
  final Color backgroundColor;
  double textScaleFactor;

  @override
  State<FormattedSongText> createState() => _FormattedSongTextState();
}

class _FormattedSongTextState extends State<FormattedSongText> {
  double _scaleFactor = 1.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: GestureDetector(
        onTap: widget.onTap,
        onScaleStart: (widget.onPinch != null)
            ? (_) {
                _scaleFactor = widget.textScaleFactor;
              }
            : null,
        onScaleUpdate: (widget.onPinch != null)
            ? (details) {
                setState(() {
                  widget.textScaleFactor = _scaleFactor * details.scale;
                });
                widget.onPinch!(widget.textScaleFactor);
              }
            : null,
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: widget.alignment,
              children: _createWidgetList(widget.songText),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _createWidgetList(String songText) {
    List<String> paragraphs = songText.split("\r\n\r\n");
    List<String> parts;
    List<Widget> widgets = [];

    bool chorus = false;

    for (var f in paragraphs) {
      parts = f.split("\r\n");
      for (var e in parts) {
        if (e.contains("{start_of_chorus}")) {
          chorus = true;
        } else if (e.contains("{end_of_chorus}")) {
          chorus = false;
          widgets.add(Text("\r\n", textScaleFactor: widget.textScaleFactor));
        } else {
          _processLine(widgets, e, chorus);
        }
      }
      widgets.add(Text("\r\n", textScaleFactor: widget.textScaleFactor));
    }

    return widgets;
  }

  //Primero simplemente ASCII;
  void _processLine(List<Widget> widgets, String line, bool chorus) {
    List<Widget> currentLine = [];

    //Tenemos troceada la cadena sin notas...
    List<String> parts = line.split(Chord.chordRegex);
    //... y las notas
    List<Match> matches = Chord.chordRegex.allMatches(line).toList();

    //if (parts[0] == "") parts.removeAt(0);
    if (parts.length == 1) {
      widgets.add(Text(parts[0],
          textScaleFactor: widget.textScaleFactor,
          style: TextStyle(
            fontSize: widget.textSize,
            fontWeight: chorus ? FontWeight.bold : FontWeight.normal,
          )));
    } else {
      for (var i = 0; i < parts.length; i++) {
        String currentChord;
        String currentPart;

        if (parts.length > matches.length) {
          currentChord = (i == 0) ? "" : matches[i - 1].group(1) ?? "";
        } else {
          currentChord = matches[i].group(1) ?? "";
        }

        currentPart = parts[i];
        currentLine.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                Chord(currentChord).paint(
                    (widget.notation == FormattedSongText.NOTATION_SPANISH)
                        ? Chord.CHORD_SET_SPANISH
                        : Chord.CHORD_SET_ENGLISH),
                textScaleFactor: widget.textScaleFactor,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: widget.textSize,
                  fontWeight: chorus ? FontWeight.bold : FontWeight.normal,
                )),
            Text(currentPart,
                textScaleFactor: widget.textScaleFactor,
                style: TextStyle(
                  fontSize: widget.textSize,
                  fontWeight: chorus ? FontWeight.bold : FontWeight.normal,
                ))
          ],
        ));
      }

      widgets.add(Wrap(children: currentLine));
    }
  }
}
