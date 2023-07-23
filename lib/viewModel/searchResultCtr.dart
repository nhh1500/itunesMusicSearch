import 'package:get/get.dart';

import '../model/MediaObject.dart';

class SearchResultCtr extends GetxController {
  final List<MediaObject> _result = [];
  List<MediaObject> get result => _result;

  void notify() {
    update();
  }
}
