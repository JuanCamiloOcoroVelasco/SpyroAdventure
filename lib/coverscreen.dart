import 'package:flutter/material.dart';

class MyCoverScreen extends StatelessWidget {
  final bool gameHasStarted;

  MyCoverScreen({required this.gameHasStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, -0.5),
      child: Text(
        gameHasStarted ? '' : 'P U L S A   P A R A   J U G A R',
        style: TextStyle(color: Colors.lime, fontSize: 25),
      ),
    );
  }
}
