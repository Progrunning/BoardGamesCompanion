import 'package:flutter/material.dart';

class GenericErrorMessage extends StatelessWidget {
  const GenericErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Oops, we ran into an issue. Please contact support at feedback@progrunning.net',
    );
  }
}
