import 'package:meiso/model/ad_manager.dart';
import 'package:meiso/model/in_app_purchase_manager.dart';
import 'package:meiso/model/shared_prefs_repository.dart';
import 'package:meiso/model/sound_manager.dart';
import 'package:meiso/view_model/main_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModel,
  ...viewModels,
];

List<SingleChildWidget> independentModels = [
  Provider<SharedPrefsRepository>(
    create: (context) => SharedPrefsRepository(),
  ),
  Provider<SoundManager>(
    create: (context) => SoundManager(),
  ),
  Provider<AdManager>(
    create: (context) => AdManager(),
  ),
  Provider<InAppPurchaseManager>(
    create: (context) => InAppPurchaseManager(),
  ),
];

List<SingleChildWidget> dependentModel = [];

List<SingleChildWidget> viewModels = [
  ChangeNotifierProvider(
    create: (context) => MainViewModel(
      sharedPrefsRepository: context.read<SharedPrefsRepository>(),
      soundManager: context.read<SoundManager>(),
      adManager: context.read<AdManager>(),
      inAppPurchaseManager: context.read<InAppPurchaseManager>(),
    ),
  ),
];
