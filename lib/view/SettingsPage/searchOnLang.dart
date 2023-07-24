import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../viewModel/userConfig.dart';

class SearchOnLangPage extends StatefulWidget {
  const SearchOnLangPage({super.key});

  @override
  State<SearchOnLangPage> createState() => _SearchOnLangPageState();
}

/// choose which language that the itunes api should return
class _SearchOnLangPageState extends State<SearchOnLangPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              var vm = Get.find<UserConfig>();
              vm.setSearchOnLang('en_us');
              Get.back();
            },
            title: Row(
              children: [
                Text('English'.tr),
                const Spacer(),
                isSelected('en_us')
              ],
            ),
          ),
          ListTile(
            onTap: () {
              var vm = Get.find<UserConfig>();
              vm.setSearchOnLang('zh_hk');
              Get.back();
            },
            title: Row(children: [
              Text('Chinese'.tr),
              const Spacer(),
              isSelected('zh_hk')
            ]),
          ),
          ListTile(
            onTap: () {
              var vm = Get.find<UserConfig>();
              vm.setSearchOnLang('ja_jp');
              Get.back();
            },
            title: Row(
              children: [
                Text('Japanese'.tr),
                const Spacer(),
                isSelected('ja_jp')
              ],
            ),
          )
        ],
      ),
    );
  }

  ///update searchLang sharedPreference value
  Widget isSelected(String value) {
    if (Get.find<UserConfig>().searchLang == value) {
      return const Icon(
        Icons.check,
        color: Colors.blue,
      );
    } else {
      return const SizedBox();
    }
  }
}
