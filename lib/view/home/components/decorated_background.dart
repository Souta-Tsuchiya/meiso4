import 'package:flutter/material.dart';
import 'package:meiso/data_model/meiso_theme.dart';

class DecoratedBackground extends StatelessWidget {
  final MeisoTheme theme;

  DecoratedBackground({required this.theme});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black87,
            Colors.black26,
          ]
        )
      ),
      child: Image.asset(theme.imagePath, fit: BoxFit.cover,),
    );
  }
}
