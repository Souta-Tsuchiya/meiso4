import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meiso/di/providers.dart';
import 'package:meiso/generated/l10n.dart';
import 'package:meiso/view/home/home_screen.dart';
import 'package:meiso/view/intro/intro_screen.dart';
import 'package:meiso/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: globalProviders,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<MainViewModel>();

    return MaterialApp(
      title: "瞑想",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: FutureBuilder(
        future: viewModel.isSkipIntro(),
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.hasData && snapshot.data == true) {
            return HomeScreen();
          }else{
            return IntroScreen();
          }
        },
      ),
    );
  }
}
