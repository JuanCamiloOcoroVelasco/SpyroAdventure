import 'package:flutter/material.dart';

class BarreraTextura extends StatelessWidget {
  final anchoBarrera;
  final alturaBarrera;
  final barreraX;
  final bool esBarreraInferior;

  BarreraTextura(
      {this.alturaBarrera,
      this.anchoBarrera,
      required this.esBarreraInferior,
      this.barreraX});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barreraX + anchoBarrera) / (2 - anchoBarrera),
          esBarreraInferior ? 1 : -1),
      child: Container(
        color: Colors.purple,
        width: MediaQuery.of(context).size.width * anchoBarrera / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * alturaBarrera / 2,
      ),
    );
  }
}
