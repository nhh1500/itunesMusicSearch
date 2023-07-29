import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/utility/internationalization.dart';
import 'package:itunes_music/viewModel/userConfig.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

///language page for user to choose different language
class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
          //extract Language metadata from Translate class
          children: List.generate(Translate().keys.length, (index) {
        var keys = Translate().keys.keys.elementAt(index);
        var lang = keys.split('_')[0];
        var cry = keys.split('_')[1];
        return ListTile(
          onTap: () {
            Get.find<UserConfig>().setLanguage(keys);
            Get.updateLocale(Locale(lang, cry));
            Get.back();
          },
          title: Text(keys.tr),
        );
      })),
    );
  }
}
