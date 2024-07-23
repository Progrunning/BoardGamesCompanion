import 'dart:io';

import 'package:flutter/widgets.dart';

extension BuildContextExtensions on BuildContext {
  // MK There's a known issue with sharing on iPads
  // https://pub.dev/packages/share_plus#known-issues
  Rect? get iPadsShareRectangle {
    Rect? sharePositionOrigin;
    if (Platform.isIOS) {
      final box = findRenderObject() as RenderBox?;
      if (box != null) {
        sharePositionOrigin = box.localToGlobal(Offset.zero) & box.size;
      }
    }

    return sharePositionOrigin;
  }
}
