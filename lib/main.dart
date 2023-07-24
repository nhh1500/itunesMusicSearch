import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:itunes_music/utility/internationalization.dart';
import 'package:itunes_music/view/AudioPlayView/overlayPlayer.dart';
import 'package:itunes_music/viewModel/audioPlayer.dart';
import 'package:itunes_music/viewModel/overlayPlayerVM.dart';
import 'package:itunes_music/viewModel/playListHeaderVM.dart';
import 'package:itunes_music/viewModel/playlistbdyVM.dart';
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
  initGetxController();
  await Future.wait([SharedPrefs.init()]);
  initConfig();
  configEasyLoading();
  initDB();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

///init GetxController
void initGetxController() {
  Get.put(AudioPlayerVM(), permanent: true);
  Get.put(SearchModelCtr(), permanent: true);
  Get.put(SearchResultCtr(), permanent: true);
  Get.put(ViewModeCtr(), permanent: true);
  Get.put(UserConfig(), permanent: true);
  Get.put(PlayListHeaderVM(), permanent: true);
  Get.put(PlayListbdyVM(), permanent: true);
  Get.put(OverLayPlayerVM(), permanent: true);
}

/// init Database
void initDB() {
  Get.find<PlayListHeaderVM>().init();
  Get.find<PlayListbdyVM>().init();
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
