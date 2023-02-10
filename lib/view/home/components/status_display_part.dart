import 'package:flutter/material.dart';
import 'package:meiso/generated/l10n.dart';
import 'package:meiso/utils/constants.dart';
import 'package:meiso/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

class StatusDisplayPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final runningStatus = context.select<MainViewModel, RunningStatus>((viewModel) => viewModel.runningStatus);

    return Column(
      children: [
        SizedBox(height: 8.0,),
        Text(_upperSmallText(context, runningStatus), style: TextStyle(fontSize: 24.0),),
        Selector<MainViewModel, int>(
          selector: (context, mainViewModel) => mainViewModel.intervalRemainingSeconds,
          builder: (context, intervalRemainingSeconds, child) {
            return Text(_lowerLargeText(context, runningStatus, intervalRemainingSeconds), style: TextStyle(fontSize: 48.0),);
          },
        ),
      ],
    );
  }

  String _upperSmallText(BuildContext context, RunningStatus runningStatus) {
    final viewModel = context.read<MainViewModel>();

    switch(runningStatus) {
      case RunningStatus.BEFORE_START:
        return "";
      case RunningStatus.ON_START:
        return S.of(context).startsIn;
      case RunningStatus.INHALE:
        return S.of(context).inhale;
      case RunningStatus.HOLD:
        return S.of(context).hold;
      case RunningStatus.EXHALE:
        return S.of(context).exhale;
      case RunningStatus.FINISHED:
        showInterstitialAd(context);
        return S.of(context).finished;
      case RunningStatus.PAUSE:
        return S.of(context).pause;
    }
  }

  String _lowerLargeText(BuildContext context, RunningStatus runningStatus, int seconds) {
    if(runningStatus == RunningStatus.BEFORE_START) {
      return "";
    }else if(runningStatus == RunningStatus.FINISHED) {
      return S.of(context).finished;
    }else{
      return seconds.toString();
    }
  }

  void showInterstitialAd(BuildContext context) {
    final viewModel = context.read<MainViewModel>();
    final isDeleteAd = viewModel.isDeleteAd;
    if(!isDeleteAd) viewModel.showInterstitialAd();
  }
}
