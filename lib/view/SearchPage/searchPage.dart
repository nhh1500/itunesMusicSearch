import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/main.dart';
import 'package:itunes_music/viewModel/viewModeCtr.dart';
import 'package:itunes_music/view/SearchPage/entityDropdown.dart';
import 'package:itunes_music/view/SearchPage/resultView.dart';
import 'package:itunes_music/view/SearchPage/searchTextField.dart';
import '../../utility/customTransition.dart';
import '../appDrawer.dart';

///search page able to search music,artist, or album
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: SafeArea(child: AppDrawer()),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Music Search'.tr),
        actions: [
          setModeButton(),
        ],
      ),
      body: Column(
        children: [searchComponent(), const Expanded(child: ResultView())],
      ),
    );
  }

  Widget searchComponent() {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        children: const [Expanded(child: SearchTextField()), EntityDropDown()],
      ),
    );
  }

  ///button to toggle girdview and listview
  Widget setModeButton() {
    return GetBuilder<ViewModeCtr>(
      builder: (controller) {
        return IconButton(
            onPressed: () {
              if (controller.viewMode == ViewMode.list) {
                controller.setMode(ViewMode.grid);
              } else {
                controller.setMode(ViewMode.list);
              }
              Navigator.of(navigatorKey.currentContext!)
                  .pushReplacement(createRoute(const SearchPage()));
            },
            icon: controller.viewMode == ViewMode.list
                ? const Icon(Icons.grid_3x3)
                : const Icon(Icons.list));
      },
    );
  }
}
