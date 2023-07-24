import 'package:get/get.dart';

enum ViewMode { grid, list }

///notify searchPage to display whether listview or gridview
class ViewModeCtr extends GetxController {
  ViewMode _viewMode = ViewMode.list;
  ViewMode get viewMode => _viewMode;

  void setMode(ViewMode mode) {
    _viewMode = mode;
    update();
  }
}
