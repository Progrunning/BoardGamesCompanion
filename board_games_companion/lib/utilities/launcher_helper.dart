import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: avoid_classes_with_only_static_members
class LauncherHelper {
  static Future<void> launchUri(BuildContext context, String uri) async {
    if (context == null || uri.isEmpty) {
      return;
    }

    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Sorry, we couldn't open the $uri"),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
  }
}
