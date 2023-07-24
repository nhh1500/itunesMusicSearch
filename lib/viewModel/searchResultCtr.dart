import 'package:get/get.dart';

import '../model/MediaObject.dart';

///search results view model
///once API complete it will notify resultPage Widget to update
class SearchResultCtr extends GetxController {
  final List<MediaObject> _result = [];
  List<MediaObject> get result => _result;

  void notify() {
    update();
  }
}
