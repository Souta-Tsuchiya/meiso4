import 'package:flutter/material.dart';
import 'package:meiso/generated/l10n.dart';
import 'package:meiso/view/home/home_screen.dart';
import 'package:meiso/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

class TimeSettingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timeSelectButtons = List.generate(
      meisoTimes.length,
      (int index) => TextButton(
        child: Text(meisoTimes[index].timeDisplayString),
        onPressed: () {
          _setTime(context, meisoTimes[index].timeMinutes);
          Navigator.pop(context);
        },
      ),
    );

    return Container(
      height: 220.0,
      child: Column(
        children: [
          SizedBox(
            height: 8.0,
          ),
          Text(S.of(context).selectTime),
          Table(
            children: [
              TableRow(children: [
                timeSelectButtons[0],
                timeSelectButtons[1],
                timeSelectButtons[2],
              ]),
              TableRow(children: [
                timeSelectButtons[3],
                timeSelectButtons[4],
                timeSelectButtons[5],
              ]),
            ],
          ),
        ],
      ),
    );
  }

  void _setTime(BuildContext context, int timeMinutes) {
    final viewModel = context.read<MainViewModel>();
    viewModel.setTime(timeMinutes);
  }
}
