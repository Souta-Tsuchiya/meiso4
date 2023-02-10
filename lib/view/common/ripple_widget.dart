import 'package:flutter/material.dart';

class RippleWidget extends StatelessWidget {
  final Widget child;

  final VoidCallback onTap;

  RippleWidget({required this.child, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.white60,
        child: child,
        onTap: onTap,
      ),
    );
  }
}
