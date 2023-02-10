import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:meiso/generated/l10n.dart';
import 'package:meiso/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

import '../common/show_modal_dialog.dart';
import '../home/home_screen.dart';
import 'components/intro_skip_dialog.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: _createSlides(context),
      onDonePress: () => _openHomeScreen(context),
      onSkipPress: () => showModalDialog(
        context: context,
        dialogWidget: IntroSkipDialog(
          onSkipped: () => _skipDialog(context),
        ),
        isScrollable: false,
      ),
    );
  }

  _createSlides(BuildContext context) {
    final appTheme = Theme.of(context);

    return [
      Slide(
        title: S.of(context).introTitle1,
        description: S.of(context).introDesc1,
        pathImage: "assets/images/intro_image01.png",
        backgroundColor: appTheme.primaryColorDark,
      ),
      Slide(
        title: S.of(context).introTitle2,
        description: S.of(context).introDesc2,
        pathImage: "assets/images/intro_image02.png",
        backgroundColor: appTheme.primaryColor,
      ),
      Slide(
        title: S.of(context).introTitle3,
        description: S.of(context).introDesc3,
        pathImage: "assets/images/intro_image03.png",
        backgroundColor: appTheme.primaryColorDark,
      ),
    ];
  }

  _openHomeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  _skipDialog(BuildContext context) async {
    final viewModel = context.read<MainViewModel>();
    await viewModel.skipDialog();

    _openHomeScreen(context);
  }
}
