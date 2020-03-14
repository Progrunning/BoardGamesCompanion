import 'package:flutter/material.dart';

class AddBoardGames extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddBoardGames();
}

class _AddBoardGames extends State<AddBoardGames> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Board Games'),
      ),
      body: Center(child: Text('Test')),
    );
  }
}
