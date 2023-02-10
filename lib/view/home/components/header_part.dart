import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meiso/data_model/user_settings.dart';
import 'package:meiso/generated/l10n.dart';
import 'package:meiso/utils/constants.dart';
import 'package:meiso/view/common/ripple_widget.dart';
import 'package:meiso/view/common/show_modal_dialog.dart';
import 'package:meiso/view/home/components/dialog/level_setting_dialog.dart';
import 'package:meiso/view/home/components/dialog/theme_setting_dialog.dart';
import 'package:meiso/view/home/components/dialog/time_setting_dialog.dart';
import 'package:meiso/view/home/home_screen.dart';
import 'package:meiso/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

class HeaderPart extends StatelessWidget {
  final UserSettings userSettings;

  HeaderPart({required this.userSettings});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _createItem(context, HeaderType.LEVELS, userSettings.levelId)),
        Expanded(child: _createItem(context, HeaderType.THEME, userSettings.themeId)),
        Expanded(child: _createItem(context, HeaderType.TIME, userSettings.timeMinutes)),
      ],
    );
  }

  Widget _createItem(BuildContext context, HeaderType headerType, int id) {
    return Selector<MainViewModel, RunningStatus>(
      selector: (context, viewModel) => viewModel.runningStatus,
      builder: (BuildContext context, runningStatus, child) {
        return RippleWidget(
          onTap: (runningStatus == RunningStatus.BEFORE_START  || runningStatus == RunningStatus.FINISHED)
              ? () => _openSettingDialog(context, headerType)
              : () => Fluttertoast.showToast(
                    msg: S.of(context).skipIntroConfirm,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.white60,
                  ),
          child: Column(
            children: [
              _createItemIcon(context, headerType),
              _createItemText(context, headerType, id),
            ],
          ),
        );
      },
    );
  }

  Widget _createItemIcon(BuildContext context, HeaderType headerType) {
    switch (headerType) {
      case HeaderType.LEVELS:
        return FaIcon(FontAwesomeIcons.mountain);
      case HeaderType.THEME:
        return FaIcon(FontAwesomeIcons.images);
      case HeaderType.TIME:
        return FaIcon(FontAwesomeIcons.stopwatch);
    }
  }

  Widget _createItemText(BuildContext context, HeaderType headerType, int id) {
    switch (headerType) {
      case HeaderType.LEVELS:
        return Text(levels[id].levelName);
      case HeaderType.THEME:
        return Text(meisoThemes[id].themeName);
      case HeaderType.TIME:
        return Selector<MainViewModel, String>(
          selector: (context, viewModel) => viewModel.remainingTimeString,
          builder: (context, remainingTimeString, child) {
            return Text(remainingTimeString);
          },
        );
    }
  }

  _openSettingDialog(BuildContext context, HeaderType headerType) {
    switch (headerType) {
      case HeaderType.LEVELS:
        return showModalDialog(context: context, dialogWidget: LevelSettingDialog(), isScrollable: false);
      case HeaderType.THEME:
        return showModalDialog(context: context, dialogWidget: ThemeSettingDialog(), isScrollable: true);
      case HeaderType.TIME:
        return showModalDialog(context: context, dialogWidget: TimeSettingDialog(), isScrollable: false);
    }
  }
}
