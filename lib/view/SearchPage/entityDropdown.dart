import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_music/viewModel/searchModeCtr.dart';

///dropdown button to choose either song,artist, or album to search
class EntityDropDown extends StatelessWidget {
  const EntityDropDown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchModelCtr>(
      builder: (controller) {
        return SizedBox(
          width: 100,
          child: DropdownButtonFormField<String>(
            isDense: true,
            decoration: InputDecoration(
                label: Text('Search by'.tr),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
            items: List.generate(controller.modeList.length,
                (index) => dropdownItm(controller.modeList[index])),
            value: controller.mode,
            onChanged: (value) {
              controller.setMode(value!);
            },
          ),
        );
      },
    );
  }

  DropdownMenuItem<String> dropdownItm(String value) {
    return DropdownMenuItem<String>(value: value, child: Text(value.tr));
  }
}
