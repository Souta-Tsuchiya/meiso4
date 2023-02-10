import 'package:flutter/material.dart';

showModalDialog({required BuildContext context, required Widget dialogWidget, required bool isScrollable}) {
  showModalBottomSheet(
    context: context,
    builder: (context) => dialogWidget,
    backgroundColor: Colors.white60.withOpacity(0.2),
    isScrollControlled: isScrollable,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(8.0),
      ),
    ),
  );
}
