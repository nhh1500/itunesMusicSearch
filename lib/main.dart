import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:itunes_music/services/DB/dbManager.dart';
import 'package:itunes_music/services/audio/audioController.dart';
import 'package:itunes_music/utility/internationalization.dart';
import 'package:itunes_music/viewModel/overlayPlayerVM.dart';
import 'package:itunes_music/viewModel/searchModeCtr.dart';
import 'package:itunes_music/viewModel/searchResultCtr.dart';
import 'package:itunes_music/viewModel/userConfig.dart';
import 'package:itunes_music/viewModel/viewModeCtr.dart';
import 'package:itunes_music/utility/sharedPrefs.dart';
import 'package:itunes_music/view/SearchPage/searchPage.dart';

///navigatorKey for global use
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//var logger = Logger();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Translate(),
      builder: EasyLoading.init(
          // builder: (context, child) {
          //   return Stack(
          //     children: [
          //       child!,
          //       Positioned(
          //         bottom: MediaQuery.of(context).viewInsets.bottom,
          //         child: OverlayPlayer(),
          //       ),
          //     ],
          //   );
          // },
          ),
      locale: getLocale(),
      //default English
      fallbackLocale: const Locale('en', 'US'),
      title: 'Itunes Music Search',
      navigatorKey: navigatorKey,
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(useMaterial3: true),
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      home: const SearchPage(),
    );
  }
}

Future init() async {
  await Future.wait([SharedPrefs.init(), DBManager.init()]);
  initGetxController();
  await Get.find<AudioController>().init();
  initConfig();
  configEasyLoading();
}

///init GetxController
void initGetxController() {
  //Get.put(AudioPlayerVM(), permanent: true);
  Get.put(AudioController(), permanent: true);
  Get.put(SearchModelCtr(), permanent: true);
  Get.put(SearchResultCtr(), permanent: true);
  Get.put(ViewModeCtr(), permanent: true);
  Get.put(UserConfig(), permanent: true);
  Get.put(OverLayPlayerVM(), permanent: true);
}

/// init Userconfig
void initConfig() {
  var config = Get.find<UserConfig>();
  config.getConfig();
  config.initApp();
}

///extract language code from sharedPreference
Locale getLocale() {
  String language = Get.find<UserConfig>().language;
  return Locale(language.split('_')[0], language.split('_')[1]);
}

/// init Easyloading
void configEasyLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}
