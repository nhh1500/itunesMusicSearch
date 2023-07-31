import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:itunes_music/viewModel/searchResultCtr.dart';

///search bar in searchPage
class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  SearchResultCtr vm = Get.find<SearchResultCtr>();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: vm.controller,
      onSubmitted: (value) async {
        //show loading widget during api call
        EasyLoading.show(status: 'Loading');
        await Get.find<SearchResultCtr>().search(vm.controller.text);
        //dimiss loading widget when api return
        EasyLoading.dismiss();
      },
      decoration: InputDecoration(
          hintText: 'Search'.tr,
          contentPadding: const EdgeInsets.all(0),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
              onPressed: () {
                vm.controller.clear();
              },
              icon: const Icon(Icons.clear))),
    );
  }
}
