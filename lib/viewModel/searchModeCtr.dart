import 'package:get/get.dart';

class SearchModelCtr extends GetxController {
  String _mode = 'Song';
  String get mode => _mode;

  void setMode(String mode) {
    _mode = mode;
    update();
  }
}
