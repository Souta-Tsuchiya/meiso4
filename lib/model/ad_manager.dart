import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;

  Future<void> initAdMob() {
    return MobileAds.instance.initialize();
  }

  // バナー広告の初期化
  void initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      listener: BannerAdListener(),
      request: AdRequest(),
    );
  }

  // バナー広告のロード
  void loadBannerAd() {
    bannerAd?.load();
  }

  int maxAttempt = 3;
  int numAttempt = 0;
  // 全画面広告の初期化とロード
  void initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          numAttempt = 0;
        },
        onAdFailedToLoad: (LoadAdError loadAdError) {
          interstitialAd = null;
          numAttempt++;
          if(numAttempt <= maxAttempt) initInterstitialAd();
        },
      ),
    );
  }

  // 全画面広告の表示処理
  void showInterstitialAd() {
    if(interstitialAd == null) return;
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        initInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError adError) {
        ad.dispose();
        initInterstitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  // バナー広告と全画面広告の破棄
  void dispose() {
    bannerAd?.dispose();
    interstitialAd?.dispose();
  }

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6066803035743206~5231250928";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6066803035743206~4656535854";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6066803035743206/7745733629";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6066803035743206/4966708805";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6066803035743206/2493406948";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6066803035743206/1440443057";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "<YOUR_ANDROID_REWARDED_AD_UNIT_ID>";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_REWARDED_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}