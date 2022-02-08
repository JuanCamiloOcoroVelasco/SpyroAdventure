import 'package:flutter/material.dart';

class SpyroMuneco extends StatelessWidget {
  final spyroY;
  final double anchoSpyro;
  final double altoSpyro;

  SpyroMuneco({this.spyroY, required this.anchoSpyro, required this.altoSpyro});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment(0, (2 * spyroY + altoSpyro) / (2 - altoSpyro)),
        child: Image.asset(
          'lib/images/Spyro.png',
          width: MediaQuery.of(context).size.height * anchoSpyro / 2,
          height: MediaQuery.of(context).size.height * 3 / 4 * altoSpyro / 2,
          fit: BoxFit.fill,
        ));
  }
}
