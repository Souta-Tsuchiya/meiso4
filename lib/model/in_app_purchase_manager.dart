import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:meiso/utils/constants.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class InAppPurchaseManager {
  late Offerings offerings;
  bool isDeleteAd = false;
  bool isSubscribed = false;

  // 課金処理の初期化
  Future<void> init() async{
    await Purchases.setDebugLogsEnabled(true);
    if(Platform.isAndroid) {
      await Purchases.setup("goog_gwXsJSbuoWcaAYtcCjxdgapRxRc");
    }else if(Platform.isIOS) {
      await Purchases.setup("appl_KkIrHdAmlANWaQMdNTzMNZfZlET");
    }

    offerings = await Purchases.getOfferings();
  }

  // 課金アイテムの保有状況の取得
  Future<void> getPurchaseInfo() async {
    try {
      final purchaseInfo = await Purchases.getPurchaserInfo();
      updatePurchases(purchaseInfo);
    }on PlatformException catch(e) {
      print(PurchasesErrorHelper.getErrorCode(e).toString());
    }
  }

  void updatePurchases(PurchaserInfo purchaseInfo) {
    final entitlements = purchaseInfo.entitlements.all;

    if(entitlements.isEmpty) {
      isDeleteAd = false;
      isSubscribed = false;
      return;
    }

    if(!entitlements.containsKey("delete_ad")) {
      isDeleteAd = false;
    }else if(entitlements["delete_ad"]!.isActive){
      isDeleteAd = true;
    }else{
      isDeleteAd = false;
    }

    if(!entitlements.containsKey("monthly_subscription")) {
      isSubscribed = false;
    }else if(entitlements["monthly_subscription"]!.isActive) {
      isSubscribed = true;
    }else{
      isSubscribed = false;
    }
  }

  Future<void> makePurchase(PurchasePattern purchasePattern) async{
    Package? package;

    switch(purchasePattern) {
      case PurchasePattern.DONATE:
        package = offerings.all["donation"]?.getPackage("donation");
        break;
      case PurchasePattern.DELETE_AD:
        package = offerings.all["delete_ad"]?.lifetime;
        break;
      case PurchasePattern.SUBSCRIBE:
        package = offerings.all["monthly_subscription"]?.monthly;
        break;
    }

    if(package == null) return;

    try {
      final purchaseInfo = await Purchases.purchasePackage(package);
      if(purchasePattern != PurchasePattern.DONATE) updatePurchases(purchaseInfo);
    }on PlatformException catch(e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if(errorCode == PurchasesErrorCode.purchaseCancelledError){
        print("User Cancelled");
      }else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        print("Purchases not allowed on this.device.");
      }else if(errorCode == PurchasesErrorCode.purchaseInvalidError){
        print("Purchase invalid, check payment source");
      }else{
        print("Unknown Error");
      }
    }
  }

  Future<void> recoverPurchase() async{
    try{
      final purchaseInfo = await Purchases.restoreTransactions();
      updatePurchases(purchaseInfo);
    }on PlatformException catch(e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      print("restoreError: ${errorCode.toString()}");
    }
  }
}