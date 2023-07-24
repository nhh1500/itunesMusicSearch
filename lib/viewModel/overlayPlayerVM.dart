import 'package:get/get.dart';

///not implemented
class OverLayPlayerVM extends GetxController {
  bool _show = false;
  bool _animated = true;
  bool get show => _show;
  bool get animated => _animated;

  void setShow(bool show) {
    _show = show;
    _animated = false;
    update();
  }

  void done(bool finish) {
    _animated = true;
  }
}
