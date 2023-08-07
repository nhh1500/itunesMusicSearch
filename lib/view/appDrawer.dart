import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/view/SearchPage/searchPage.dart';
import 'package:itunes_music/view/playList/playListPage.dart';
import 'package:itunes_music/view/SettingsPage/settingsPage.dart';

/// side menu used by searchPage
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.back();
            Get.to(const SearchPage());
          },
          leading: const Icon(Icons.home),
          title: Text('Home'.tr),
        ),
        ListTile(
          leading: const Icon(Icons.favorite),
          title: Text('Favorite'.tr),
        ),
        ListTile(
          onTap: () async {
            Get.back();
            Get.to(const PlayListPage());
          },
          leading: Icon(Icons.list),
          title: Text('PlayList'.tr),
        ),
        ListTile(
          onTap: () {
            Get.back();
            Get.to(const SettingsPage());
          },
          leading: const Icon(Icons.settings),
          title: Text('Settings'.tr),
        )
      ],
    );
  }
}
