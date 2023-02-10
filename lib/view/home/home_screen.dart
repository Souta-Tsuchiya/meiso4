import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meiso/data_model/user_settings.dart';
import 'package:meiso/generated/l10n.dart';
import 'package:meiso/model/ad_manager.dart';
import 'package:meiso/view_model/main_view_model.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../../data_model/level.dart';
import '../../data_model/meiso_theme.dart';
import '../../data_model/meiso_time.dart';
import 'components/decorated_background.dart';
import 'components/header_part.dart';
import 'components/play_button_part.dart';
import 'components/speed_dial_part.dart';
import 'components/status_display_part.dart';
import 'components/volume_slider_part.dart';

List<Level> levels = [];
List<MeisoTheme> meisoThemes = [];
List<MeisoTime> meisoTimes = [];

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    levels = setLevels(context);
    meisoThemes = setMeisoThemes(context);
    meisoTimes = setMeisoTimes(context);

    Future(() {
      final viewModel = context.read<MainViewModel>();
      viewModel
        ..getUserSettings()
        ..loadBannerAd()
        ..initInAppPurchase();
    });

    return SafeArea(
      child: Scaffold(
        floatingActionButton: SpeedDialPart(),
        body: Selector<MainViewModel, UserSettings?>(
          selector: (context, viewModel) => viewModel.userSettings,
          builder: (context, userSettings, child) {
            return userSettings == null
                ? Center(child: CircularProgressIndicator())
                : Selector<MainViewModel, bool>(
                    selector: (context, viewModel) => viewModel.isInAppPurchaseProcessing,
                    builder: (context, isInAppPurchaseProcessing, child) => Opacity(
                      opacity: isInAppPurchaseProcessing ? 0.25: 1.0,
                      child: AbsorbPointer(
                        absorbing: isInAppPurchaseProcessing,
                        child: Stack(
                              fit: StackFit.expand,
                              children: [
                                DecoratedBackground(
                                  theme: meisoThemes[userSettings.themeId],
                                ),
                                Column(
                                  children: [
                                    HeaderPart(
                                      userSettings: userSettings,
                                    ),
                                    StatusDisplayPart(),
                                    PlayButtonPart(),
                                    VolumeSliderPart(),
                                  ],
                                ),
                                Selector<MainViewModel, Tuple2<AdManager, bool>>(
                                  selector: (context, viewModel) =>
                                      Tuple2(viewModel.adManager, viewModel.isDeleteAd),
                                  builder: (context, data, child) {
                                    final bannerAd = data.item1.bannerAd;
                                    final isDeleteAd = data.item2;

                                    return Positioned(
                                      bottom: 8.0,
                                      left: 24.0,
                                      right: 24.0,
                                      child: (bannerAd == null || isDeleteAd)
                                          ? Container(
                                              height: 0.0,
                                              width: 0.0,
                                            )
                                          : Container(
                                              height: bannerAd.size.height.toDouble(),
                                              width: bannerAd.size.width.toDouble(),
                                              child: AdWidget(ad: bannerAd),
                                            ),
                                    );
                                  },
                                ),
                              ],
                            ),
                      ),
                    ));
          },
        ),
      ),
    );
  }

  List<Level> setLevels(BuildContext context) {
    return [
      Level(
        levelId: LEVEL_ID_EASY,
        levelName: S.of(context).levelEasy,
        explanation: S.of(context).levelSelectEasy,
        bellPath: "assets/sounds/bells_easy.mp3",
        totalInterval: 12,
        inhaleInterval: 4,
        holdInterval: 4,
        exhaleInterval: 4,
      ),
      Level(
        levelId: LEVEL_ID_NORMAL,
        levelName: S.of(context).levelNormal,
        explanation: S.of(context).levelSelectNormal,
        bellPath: "assets/sounds/bells_normal.mp3",
        totalInterval: 16,
        inhaleInterval: 4,
        holdInterval: 4,
        exhaleInterval: 8,
      ),
      Level(
        levelId: LEVEL_ID_MID,
        levelName: S.of(context).levelMid,
        explanation: S.of(context).levelSelectMid,
        bellPath: "assets/sounds/bells_mid.mp3",
        totalInterval: 20,
        inhaleInterval: 4,
        holdInterval: 8,
        exhaleInterval: 8,
      ),
      Level(
        levelId: LEVEL_ID_HIGH,
        levelName: S.of(context).levelHigh,
        explanation: S.of(context).levelSelectHigh,
        bellPath: "assets/sounds/bells_advanced.mp3",
        totalInterval: 28,
        inhaleInterval: 4,
        holdInterval: 16,
        exhaleInterval: 8,
      ),
    ];
  }

  List<MeisoTheme> setMeisoThemes(BuildContext context) {
    return [
      MeisoTheme(
        themeId: THEME_ID_SILENCE,
        themeName: S.of(context).themeSilence,
        imagePath: "assets/images/silence.jpg",
        soundPath: null,
      ),
      MeisoTheme(
        themeId: THEME_ID_CAVE,
        themeName: S.of(context).themeCave,
        imagePath: "assets/images/cave.jpg",
        soundPath: "assets/sounds/bgm_cave.mp3",
      ),
      MeisoTheme(
        themeId: THEME_ID_SPRING,
        themeName: S.of(context).themeSpring,
        imagePath: "assets/images/spring.jpg",
        soundPath: "assets/sounds/bgm_spring.mp3",
      ),
      MeisoTheme(
        themeId: THEME_ID_SUMMER,
        themeName: S.of(context).themeSummer,
        imagePath: "assets/images/summer.jpg",
        soundPath: "assets/sounds/bgm_summer.mp3",
      ),
      MeisoTheme(
        themeId: THEME_ID_AUTUMN,
        themeName: S.of(context).themeAutumn,
        imagePath: "assets/images/autumn.jpg",
        soundPath: "assets/sounds/bgm_autumn.mp3",
      ),
      MeisoTheme(
        themeId: THEME_ID_STREAM,
        themeName: S.of(context).themeStream,
        imagePath: "assets/images/stream.jpg",
        soundPath: "assets/sounds/bgm_stream.mp3",
      ),
      MeisoTheme(
        themeId: THEME_ID_WIND_BELLS,
        themeName: S.of(context).themeWindBell,
        imagePath: "assets/images/wind_bell.jpg",
        soundPath: "assets/sounds/bgm_wind_bell.mp3",
      ),
      MeisoTheme(
        themeId: THEME_ID_BONFIRE,
        themeName: S.of(context).themeBonfire,
        imagePath: "assets/images/bonfire.jpg",
        soundPath: "assets/sounds/bgm_bonfire.mp3",
      ),
    ];
  }

  List<MeisoTime> setMeisoTimes(BuildContext context) {
    return [
      MeisoTime(
        timeDisplayString: S.of(context).min5,
        timeMinutes: 5,
      ),
      MeisoTime(
        timeDisplayString: S.of(context).min10,
        timeMinutes: 10,
      ),
      MeisoTime(
        timeDisplayString: S.of(context).min15,
        timeMinutes: 15,
      ),
      MeisoTime(
        timeDisplayString: S.of(context).min20,
        timeMinutes: 20,
      ),
      MeisoTime(
        timeDisplayString: S.of(context).min30,
        timeMinutes: 30,
      ),
      MeisoTime(
        timeDisplayString: S.of(context).min60,
        timeMinutes: 60,
      ),
    ];
  }
}
