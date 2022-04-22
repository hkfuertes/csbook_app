import 'dart:async';
import 'dart:io';

import 'package:csbook/src/helpers/AndroidKeyCode.dart';
import 'package:csbook/src/helpers/volume_watcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:perfect_volume_control/perfect_volume_control.dart';

class KeyboardHelper extends StatefulWidget {
  final Widget child;
  final Function()? onUp;
  final Function()? onDown;
  const KeyboardHelper({Key? key, required this.child, this.onDown, this.onUp})
      : super(key: key);

  @override
  State<KeyboardHelper> createState() => _KeyboardHelperState();
}

class _KeyboardHelperState extends State<KeyboardHelper> {
  double? _baseVolume;
  StreamSubscription<double>? _volumeSubscription;

  final MethodChannel _channel =
      const MethodChannel('csbook.mfuertes.net/keyboard');

  @override
  Widget build(BuildContext context) => widget.child;

  bool _isAndroid() => !kIsWeb && (Platform.isAndroid);
  bool _isIOS() => !kIsWeb && (Platform.isIOS);

  @override
  void initState() {
    if (_isAndroid()) {
      _nativeAndroidKeyboardInit();
    } else if (_isIOS()) {
      PerfectVolumeControl.hideUI = true;
      _volumeSubscription =
          PerfectVolumeControl.stream.listen(_controlWithVolume);
      //Set Volume to 0, to start, by default.
      PerfectVolumeControl.setVolume(1).then((_) {
        setState(() {
          _baseVolume = 1;
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _volumeSubscription?.cancel();
    super.dispose();
  }

  void _controlWithVolume(volume) {
    if (_baseVolume != null) {
      if (_baseVolume! < volume) {
        //VolumeUpKey
        if (widget.onUp != null) widget.onUp!();
      } else if (_baseVolume! > volume) {
        //VolumeDownKey
        if (widget.onDown != null) widget.onDown!();
      }
    }
    setState(() {
      _baseVolume = volume;
    });
  }

  void _nativeAndroidKeyboardInit() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "onKeyDown":
          try {
            var keyCode = call.arguments[0];
            /*
            Now we compare Keycode with options
            */
            switch (keyCode) {
              case AndroidKeyCode.KEYCODE_VOLUME_UP:
              case AndroidKeyCode.KEYCODE_PAGE_UP:
                if (widget.onUp != null) widget.onUp!();
                break;
              case AndroidKeyCode.KEYCODE_VOLUME_DOWN:
              case AndroidKeyCode.KEYCODE_PAGE_DOWN:
              case AndroidKeyCode.KEYCODE_ENTER:
              case AndroidKeyCode.KEYCODE_HEADSETHOOK:
                if (widget.onDown != null) widget.onDown!();
                break;
            }
          } catch (e, trace) {
            print("$e\n$trace");
          }
          break;
      }
      return 0;
    });
  }
}
