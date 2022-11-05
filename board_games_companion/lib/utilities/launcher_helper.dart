import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: avoid_classes_with_only_static_members
class LauncherHelper {
  static Future<void> launchUri(
    BuildContext context,
    String uri, {
    LaunchMode launchMode = LaunchMode.platformDefault,
  }) async {
    if (context == null || uri.isEmpty) {
      return;
    }

    final Uri? parsedUri = Uri.tryParse(uri);
    if (parsedUri == null) {
      return;
    }

    if (await canLaunchUrl(parsedUri)) {
      await launchUrl(parsedUri, mode: launchMode);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
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
