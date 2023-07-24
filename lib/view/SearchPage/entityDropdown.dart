import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/viewModel/searchModeCtr.dart';

///dropdown button to choose either song,artist, or album to search
class EntityDropDown extends StatefulWidget {
  const EntityDropDown({
    super.key,
  });

  @override
  State<EntityDropDown> createState() => _EntityDropDownState();
}

class _EntityDropDownState extends State<EntityDropDown> {
  List<DropdownMenuItem<String>> menuItem = [];
  String? item;

  @override
  void initState() {
    super.initState();
    menuItem.add(DropdownMenuItem(
      value: 'Song',
      child: Text('Song'.tr),
    ));
    menuItem.add(DropdownMenuItem(
      value: 'Artist',
      child: Text('Artist'.tr),
    ));
    menuItem.add(DropdownMenuItem(
      value: 'Album',
      child: Text('Album'.tr),
    ));
    item = menuItem.first.value;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchModelCtr>(
      builder: (controller) {
        return Container(
          width: 100,
          child: DropdownButtonFormField<String>(
            isDense: true,
            decoration: InputDecoration(
                label: Text('Search by'.tr),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
            items: menuItem,
            value: controller.mode,
            onChanged: (value) {
              controller.setMode(value!);
            },
          ),
        );
      },
    );
  }
}
