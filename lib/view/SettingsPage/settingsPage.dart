import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:itunes_music/utility/sharedPrefs.dart';
import 'package:itunes_music/view/SettingsPage/languagePage.dart';
import 'package:itunes_music/view/SettingsPage/searchOnCountryPage.dart';
import 'package:itunes_music/view/SettingsPage/searchOnLang.dart';
import 'package:itunes_music/viewModel/userConfig.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final config = Get.find<UserConfig>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            commonSection(),
            playbackSection(),
            playerUISection(),
            memorySection()
          ],
        ),
      ),
    );
  }

  Widget commonSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, bottom: 5),
            child: Text('General'.tr),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Get.to(LanguagePage());
                  },
                  leading: Icon(Icons.language),
                  title: Text('Language'.tr),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(Get.locale.toString().tr),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.color_lens),
                  title: Text('Theme'.tr),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {
                    Get.to(const SearchOnCountryPage());
                  },
                  leading: const Icon(Icons.search),
                  title: Text('Search on specific country'.tr),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {
                    Get.to(const SearchOnLangPage());
                  },
                  leading: const Icon(Icons.search),
                  title: Text('Search result language'.tr),
                  trailing: const Icon(Icons.arrow_forward_ios),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget playbackSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, bottom: 5),
            child: Text('Playback'.tr),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.play_circle),
                  title: Text('Autoplay'.tr),
                  trailing: Switch(
                    activeTrackColor: Colors.green,
                    thumbColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    value: config.autoPlay,
                    onChanged: (value) {
                      setState(() {
                        print(value);
                        config.setAutoPlay(value);
                      });
                    },
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.remember_me),
                  title: Text('Resume playback'.tr),
                  trailing: Switch(
                    activeTrackColor: Colors.green,
                    thumbColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    value: config.resumePlayBack,
                    onChanged: (value) {
                      setState(() {
                        config.setResumePlayBack(value);
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget playerUISection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 5),
            child: Text('Player UI'.tr),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.equalizer),
                  title: Text('Equalizer'.tr),
                  trailing: Switch(
                    activeTrackColor: Colors.green,
                    thumbColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    value: config.equalizer,
                    onChanged: (value) {
                      setState(() {
                        config.setEqualizer(value);
                      });
                    },
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.volume_up),
                  title: Text('LoudnessEnhancer'.tr),
                  trailing: Switch(
                    activeTrackColor: Colors.green,
                    thumbColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    value: config.loudnessEnhancer,
                    onChanged: (value) {
                      setState(() {
                        config.setLoudnessEnhancer(value);
                      });
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget memorySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 5),
            child: Text('Memory'.tr),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.delete),
                  title: Text('Clear cache'.tr),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.history),
                  title: Text('Clear search history'.tr),
                ),
                ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.history_toggle_off),
                    title: Text('Record search history'.tr),
                    trailing: Switch(
                      activeTrackColor: Colors.green,
                      thumbColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      value: config.recordSearchHistory,
                      onChanged: (value) {
                        setState(() {
                          config.setRecordSearchHistory(value);
                        });
                      },
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
