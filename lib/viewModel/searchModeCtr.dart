import 'package:get/get.dart';

class SearchModelCtr extends GetxController {
  //mode can be song / album / artist
  final List<String> _modeList = ['Song', 'Artist', 'Album'];
  List<String> get modeList => _modeList;
  String _mode = 'Song';
  String get mode => _mode;

  void setMode(String mode) {
    _mode = mode;
    update();
  }
}
