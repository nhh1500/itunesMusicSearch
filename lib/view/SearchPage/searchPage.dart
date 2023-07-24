import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/viewModel/overlayPlayerVM.dart';
import 'package:itunes_music/viewModel/viewModeCtr.dart';
import 'package:itunes_music/services/ApiController.dart';
import 'package:itunes_music/view/SearchPage/entityDropdown.dart';
import 'package:itunes_music/view/SearchPage/resultView.dart';
import 'package:itunes_music/view/SearchPage/searchTextField.dart';
import 'package:itunes_music/view/SettingsPage/settingsPage.dart';
import 'package:itunes_music/view/SearchPage/songItem.dart';

import '../../utility/customTransition.dart';
import '../appDrawer.dart';

///search page able to search music,artist, or album
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    var modeCtr = Get.find<ViewModeCtr>();
    return Scaffold(
      drawer: const Drawer(
        child: SafeArea(child: AppDrawer()),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Music Search'.tr),
        actions: [
          IconButton(
              onPressed: () {
                //toggle gridview or listview
                if (modeCtr.viewMode == ViewMode.list) {
                  modeCtr.setMode(ViewMode.grid);
                } else {
                  modeCtr.setMode(ViewMode.list);
                }
                Navigator.of(context)
                    .pushReplacement(createRoute(const SearchPage()));
              },
              icon: modeCtr.viewMode == ViewMode.list
                  ? const Icon(Icons.grid_3x3)
                  : const Icon(Icons.list)),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            child: Row(
              children: const [
                Expanded(child: SearchTextField()),
                EntityDropDown()
              ],
            ),
          ),
          const Expanded(child: ResultView())
        ],
      ),
    );
  }
}
