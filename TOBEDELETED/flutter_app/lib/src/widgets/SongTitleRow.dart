import 'package:csbook/src/model/song.dart';
import 'package:flutter/material.dart';

class SongTitleRow extends StatelessWidget {
  const SongTitleRow(
      {Key? key,
      required this.song,
      this.onBackTap,
      this.showBackButton,
      this.displayBackAsCross = false,
      this.tryTrimTitle = false,
      this.baseTextStyle,
      this.contentPadding = EdgeInsets.zero})
      : super(key: key);

  final Song song;
  final Function()? onBackTap;
  final bool? showBackButton;
  final bool displayBackAsCross;
  final bool tryTrimTitle;
  final TextStyle? baseTextStyle;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!displayBackAsCross && _isBackVisible())
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
                onPressed: onBackTap, icon: const Icon(Icons.arrow_back)),
          ),
        Expanded(
          child: Padding(
            padding: (displayBackAsCross)
                ? contentPadding
                : contentPadding.copyWith(left: 0),
            child: Row(
              children: [
                if (song.capo != null && song.capo! > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                        padding: const EdgeInsets.only(right: 8),
                        decoration: const BoxDecoration(
                            border:
                                Border(right: BorderSide(color: Colors.white))),
                        child: Text(
                          "C" + song.capo!.toString(),
                          textScaleFactor: 1.2,
                          style: baseTextStyle,
                        )),
                  ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getTrimmedText(tryTrimTitle, song.title)!,
                          overflow: TextOverflow.ellipsis,
                          style: baseTextStyle,
                        ),
                        if (song.author != null)
                          Text(
                            _getTrimmedText(tryTrimTitle, song.author)!,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 0.9,
                            style: (baseTextStyle != null)
                                ? baseTextStyle!.copyWith(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w100)
                                : const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w100),
                          )
                      ]),
                ),
              ],
            ),
          ),
        ),
        if (displayBackAsCross && _isBackVisible())
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 12),
            child:
                IconButton(onPressed: onBackTap, icon: const Icon(Icons.close)),
          ),
      ],
    );
  }

  bool _isBackVisible() {
    if (showBackButton == null) {
      return onBackTap != null;
    } else {
      return showBackButton! && onBackTap != null;
    }
  }

  String? _getTrimmedText(bool trimed, String? text) {
    if (text == null) return null;
    if (!trimed) {
      return text;
    } else {
      return text.split("(")[0].trim();
    }
  }
}
