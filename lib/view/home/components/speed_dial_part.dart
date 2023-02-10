import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meiso/generated/l10n.dart';
import 'package:meiso/utils/constants.dart';
import 'package:meiso/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

class SpeedDialPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final runningStatus =
        context.select<MainViewModel, RunningStatus>((viewModel) => viewModel.runningStatus);

    return (runningStatus == RunningStatus.BEFORE_START || runningStatus == RunningStatus.PAUSE)
        ? Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: Colors.white,
              overlayColor: Colors.white60.withOpacity(0.2),
              children: [
                SpeedDialChild(
                  child: Icon(FontAwesomeIcons.donate),
                  backgroundColor: Colors.teal,
                  label: S.of(context).donation,
                  labelBackgroundColor: Colors.grey,
                  onTap: () => _donate(context),
                ),
                SpeedDialChild(
                  child: Icon(FontAwesomeIcons.ad),
                  backgroundColor: Colors.teal,
                  label: S.of(context).deleteAd,
                  labelBackgroundColor: Colors.grey,
                  onTap: () => _deleteAd(context),
                ),
                SpeedDialChild(
                  child: Icon(FontAwesomeIcons.subscript),
                  backgroundColor: Colors.teal,
                  label: S.of(context).subscription,
                  labelBackgroundColor: Colors.grey,
                  onTap: () => _subscribe(context),
                ),
                SpeedDialChild(
                  child: Icon(FontAwesomeIcons.undo),
                  backgroundColor: Colors.teal,
                  label: S.of(context).recoverPurchase,
                  labelBackgroundColor: Colors.grey,
                  onTap: () => _recoverPurchase(context),
                ),
              ],
            ),
        )
        : Container();
  }

  // 寄附
  _donate(BuildContext context) {
    final viewModel = context.read<MainViewModel>();
    viewModel.makePurchase(PurchasePattern.DONATE);
  }

  // 広告を消す
  _deleteAd(BuildContext context) {
    final viewModel = context.read<MainViewModel>();
    if(!viewModel.isDeleteAd) {
      viewModel.makePurchase(PurchasePattern.DELETE_AD);
    }else{
      Fluttertoast.showToast(msg: S.of(context).alreadyPurchased);
    }
  }

  // サブスク
  _subscribe(BuildContext context) {
    final viewModel = context.read<MainViewModel>();
    if(!viewModel.isDeleteAd) {
      viewModel.makePurchase(PurchasePattern.SUBSCRIBE);
    }else{
      Fluttertoast.showToast(msg: S.of(context).alreadyPurchased);
    }
  }

  // 購入の復元
  _recoverPurchase(BuildContext context) {
    if(Platform.isIOS) {
      final viewModel = context.read<MainViewModel>();
      viewModel.recoverPurchase();
      return;
    }
    Fluttertoast.showToast(msg: S.of(context).recoverPurchaseNotEnabledInAndroid, gravity: ToastGravity.BOTTOM, toastLength: Toast.LENGTH_LONG);

  }
}
