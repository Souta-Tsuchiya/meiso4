import 'package:flutter/material.dart';
import 'package:meiso/generated/l10n.dart';

class IntroSkipDialog extends StatelessWidget {
  final VoidCallback onSkipped;

  IntroSkipDialog({required this.onSkipped});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      child: Column(
        children: [
          SizedBox(height: 8.0,),
          Text(S.of(context).skipIntroConfirm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(child: Text(S.of(context).yes), onPressed: onSkipped,),
              TextButton(child: Text(S.of(context).no), onPressed: () => Navigator.pop(context),),
            ],
          )
        ],
      ),
    );
  }
}
