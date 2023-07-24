import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/viewModel/userConfig.dart';

/// choose which country itunes store should the itunes api fetch data
class SearchOnCountryPage extends StatefulWidget {
  const SearchOnCountryPage({super.key});

  @override
  State<SearchOnCountryPage> createState() => _SearchOnCountryPageState();
}

class _SearchOnCountryPageState extends State<SearchOnCountryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              var vm = Get.find<UserConfig>();
              vm.setSearchOnCountry('US');
              Get.back();
            },
            title: Row(
              children: [
                Text('United State'.tr),
                const Spacer(),
                isSelected('US')
              ],
            ),
          ),
          ListTile(
            onTap: () {
              var vm = Get.find<UserConfig>();
              vm.setSearchOnCountry('HK');
              Get.back();
            },
            title: Row(children: [
              Text('Hong Kong'.tr),
              const Spacer(),
              isSelected('HK')
            ]),
          ),
          ListTile(
            onTap: () {
              var vm = Get.find<UserConfig>();
              vm.setSearchOnCountry('JP');
              Get.back();
            },
            title: Row(
              children: [Text('Japan'.tr), const Spacer(), isSelected('JP')],
            ),
          )
        ],
      ),
    );
  }

  ///update sharedpreference value
  Widget isSelected(String value) {
    if (Get.find<UserConfig>().searchCountry == value) {
      return const Icon(
        Icons.check,
        color: Colors.blue,
      );
    } else {
      return const SizedBox();
    }
  }
}
