import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meiso/data_model/meiso_theme.dart';
import 'package:meiso/data_model/user_settings.dart';
import 'package:meiso/model/in_app_purchase_manager.dart';
import 'package:meiso/model/shared_prefs_repository.dart';
import 'package:meiso/model/sound_manager.dart';
import 'package:meiso/utils/constants.dart';
import 'package:meiso/view/home/home_screen.dart';

import '../model/ad_manager.dart';
import '../utils/functions.dart';

class MainViewModel extends ChangeNotifier {
  final SharedPrefsRepository sharedPrefsRepository;
  final SoundManager soundManager;
  final AdManager adManager;
  final InAppPurchaseManager inAppPurchaseManager;

  UserSettings? userSettings;
  int remainingTimeSeconds = 0;
  String get remainingTimeString => convertToTimeString(remainingTimeSeconds);
  RunningStatus runningStatus = RunningStatus.BEFORE_START;

  int intervalRemainingSeconds = INITIAL_INTERVAL_SECONDS;

  double get sliderVolume => soundManager.volume * 20;

  int timeElapsedInOneCycle = 0;

  bool isTimerCancel = true;

  bool get isDeleteAd => inAppPurchaseManager.isDeleteAd;
  bool get isSubscribed => inAppPurchaseManager.isSubscribed;

  bool isInAppPurchaseProcessing = false;

  MainViewModel({
    required this.sharedPrefsRepository,
    required this.soundManager,
    required this.adManager,
    required this.inAppPurchaseManager,
  }) {
    adManager..initAdMob()..initBannerAd()..initInterstitialAd();
  }

  Future<void> skipDialog() async{
    await sharedPrefsRepository.skipDialog();
  }

  Future<bool> isSkipIntro() async{
    return await sharedPrefsRepository.isSkipIntro();
  }

  Future<void> getUserSettings() async{
    userSettings = await sharedPrefsRepository.getUserSettings();
    remainingTimeSeconds = userSettings!.timeMinutes * 60;
    notifyListeners();
  }

  Future<void> setLevel(int index) async{
    await sharedPrefsRepository.setLevel(index);
    getUserSettings();
  }

  Future<void> setTime(int timeMinutes) async{
    await sharedPrefsRepository.setTime(timeMinutes);
    getUserSettings();
  }

  Future<void> setTheme(int index) async{
    await sharedPrefsRepository.setTheme(index);
    getUserSettings();
  }

  void changeVolume(double newVolume) {
    soundManager.changeVolume(newVolume);
    notifyListeners();
  }

  // 瞑想前処理
  void startMeditation() {
    runningStatus = RunningStatus.ON_START;
    intervalRemainingSeconds = INITIAL_INTERVAL_SECONDS;
    notifyListeners();

    Timer.periodic(Duration(seconds: 1), (timer) {
      intervalRemainingSeconds -= 1;

      if(intervalRemainingSeconds <= 0) {
        timer.cancel();
        prepareSounds();
        startMeditationTimer();
      }else if(runningStatus == RunningStatus.PAUSE) {
        timer.cancel();
        resetMeditation();
      }
      notifyListeners();
    });
  }

  // サウンド関連
  void prepareSounds() async{
    final levelId = userSettings!.levelId;
    final themeId = userSettings!.themeId;
    final isBgm = themeId != THEME_ID_SILENCE;
    final bellPath = levels[levelId].bellPath;
    final bgmPath = isBgm ? meisoThemes[themeId].soundPath : "";

    await soundManager.prepareSounds(isBgm, bellPath, bgmPath);
  }

  void startBgm() async{
    final levelId = userSettings!.levelId;
    final themeId = userSettings!.themeId;
    final isBgm = themeId != THEME_ID_SILENCE;
    final bellPath = levels[levelId].bellPath;
    final bgmPath = isBgm ? meisoThemes[themeId].soundPath : "";

    await soundManager.playSounds(isBgm, bellPath, bgmPath);
  }

  void _stopBgm() {
    final themeId = userSettings!.themeId;
    final isBgm = themeId != THEME_ID_SILENCE;

    soundManager.stopBgm(isBgm, themeId);
  }

  // 再開
  void resumeMeditation() {
    startMeditationTimer();
  }

  // 初期状態に
  void resetMeditation() {
    runningStatus = RunningStatus.BEFORE_START;
    intervalRemainingSeconds = INITIAL_INTERVAL_SECONDS;
    remainingTimeSeconds = userSettings!.timeMinutes * 60;
    notifyListeners();
  }

  // 一時停止
  void pauseMeditation() {
    isTimerCancel = false;
    runningStatus = RunningStatus.PAUSE;
    notifyListeners();
  }

  // 本瞑想処理
  void startMeditationTimer() {
    // runningStatus = RunningStatus.INHALE;
    remainingTimeSeconds = _adjustMeditationTime(remainingTimeSeconds);
    notifyListeners();

    timeElapsedInOneCycle = 0;
    _evaluateStatus();
    startBgm();

    Timer.periodic(Duration(seconds: 1), (timer) {
      remainingTimeSeconds -= 1;
      if(runningStatus == RunningStatus.INHALE || runningStatus == RunningStatus.HOLD
          || runningStatus == RunningStatus.EXHALE || runningStatus == RunningStatus.FINISHED) {
        _evaluateStatus();
      }
      if(runningStatus == RunningStatus.PAUSE) {
        timer.cancel();
        isTimerCancel = true;
        _stopBgm();
      }else if(runningStatus == RunningStatus.FINISHED) {
        timer.cancel();
        isTimerCancel = true;
        _stopBgm();
        _ringFinalGong();
      }

      notifyListeners();
    });
  }

  // 瞑想時間の調整
  int _adjustMeditationTime(int remainingTimeSeconds) {
    final int totalInterval = levels[userSettings!.levelId].totalInterval;

    final remainder = remainingTimeSeconds.remainder(totalInterval);

    if(remainder > (totalInterval / 2)) {
      return remainingTimeSeconds + (totalInterval - remainder);
    }else{
      return remainingTimeSeconds - remainder;
    }
  }

  // 瞑想の自動判定
  void _evaluateStatus() {
    if(remainingTimeSeconds <= 0) {
      runningStatus = RunningStatus.FINISHED;
      return;
    }

    final inhaleInterval = levels[userSettings!.levelId].inhaleInterval;
    final holdInterval = levels[userSettings!.levelId].holdInterval;
    final totalInterval = levels[userSettings!.levelId].totalInterval;

    if(timeElapsedInOneCycle >= 0 && timeElapsedInOneCycle < inhaleInterval) {
      runningStatus = RunningStatus.INHALE;
      intervalRemainingSeconds = inhaleInterval - timeElapsedInOneCycle;
    }else if(timeElapsedInOneCycle < inhaleInterval + holdInterval) {
      runningStatus = RunningStatus.HOLD;
      intervalRemainingSeconds = inhaleInterval + holdInterval - timeElapsedInOneCycle;
    }else if(timeElapsedInOneCycle < totalInterval) {
      runningStatus = RunningStatus.EXHALE;
      intervalRemainingSeconds = totalInterval - timeElapsedInOneCycle;
    }

    timeElapsedInOneCycle = (timeElapsedInOneCycle >= totalInterval - 1)
        ? 0
        : timeElapsedInOneCycle + 1;
  }

  void _ringFinalGong() {
    soundManager.ringFinalGong();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    soundManager.dispose();
  }

  void loadBannerAd() {
    adManager.loadBannerAd();
  }

  void showInterstitialAd() {
    adManager.showInterstitialAd();
  }

  void initInAppPurchase() async{
    await inAppPurchaseManager.init();
    await inAppPurchaseManager.getPurchaseInfo();
    notifyListeners();
  }

  void makePurchase(PurchasePattern purchasePattern) async{
    isInAppPurchaseProcessing = true;
    notifyListeners();

    await inAppPurchaseManager.makePurchase(purchasePattern);
    isInAppPurchaseProcessing = false;
    notifyListeners();
  }

  void recoverPurchase() async{
    await inAppPurchaseManager.recoverPurchase();
    notifyListeners();
  }
}
