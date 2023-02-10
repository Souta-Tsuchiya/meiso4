import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meiso/utils/constants.dart';
import 'package:meiso/view/common/ripple_widget.dart';
import 'package:meiso/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

class PlayButtonPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final runningStatus =
    context.select<MainViewModel, RunningStatus>((viewModel) => viewModel.runningStatus);

    final isTimerCanceled = context.select<MainViewModel, bool>((viewModel) => viewModel.isTimerCancel);

    return Stack(
      children: [
        Center(
          child: RippleWidget(
              onTap: () => _onPlayButtonPressed(context, runningStatus),
              child: _playButtonLargeIcon(context, runningStatus),
          ),
        ),
        Positioned(
          left: 32.0,
          bottom: 0.0,
          child: (runningStatus == RunningStatus.PAUSE && isTimerCanceled)
              ? RippleWidget(
              onTap: () => _onStopButtonPressed(context),
              // ignore: deprecated_member_use
              child: Icon(FontAwesomeIcons.stopCircle, size: 48.0,),)
              : Container(),
        ),
      ],
    );
  }

  Widget _playButtonLargeIcon(BuildContext context, RunningStatus runningStatus) {
    if(runningStatus == RunningStatus.BEFORE_START || runningStatus == RunningStatus.PAUSE) {
      // ignore: deprecated_member_use
      return Icon(FontAwesomeIcons.playCircle, size: 200.0,);
    }else if(runningStatus == RunningStatus.PAUSE) {
      // ignore: deprecated_member_use
      return Icon(FontAwesomeIcons.stopCircle, size: 200.0,);
    }else{
      // ignore: deprecated_member_use
      return Icon(FontAwesomeIcons.pauseCircle, size: 200.0,);
    }
  }

  _onPlayButtonPressed(BuildContext context, RunningStatus runningStatus) {
    final viewModel = context.read<MainViewModel>();

    if(runningStatus == RunningStatus.BEFORE_START){
      viewModel.startMeditation();
    }else if(runningStatus == RunningStatus.PAUSE) {
      if(viewModel.isTimerCancel) viewModel.resumeMeditation();
    }else if(runningStatus == RunningStatus.FINISHED) {
      if(viewModel.isTimerCancel) viewModel.resetMeditation();
    }else{
      viewModel.pauseMeditation();
    }
  }

  _onStopButtonPressed(BuildContext context) {
    final viewModel = context.read<MainViewModel>();
    viewModel.resetMeditation();
  }
}
