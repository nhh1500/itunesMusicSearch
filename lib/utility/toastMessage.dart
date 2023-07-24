import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';

/// global toast Message
class ToastMessage {
  static late FToast fToast;

  static displayFloast(String text) {
    fToast = FToast();
    var curContext = navigatorKey.currentState?.overlay?.context;
    if (curContext != null) {
      fToast.init(curContext);
      fToast.showToast(
          toastDuration: const Duration(seconds: 2),
          gravity: ToastGravity.BOTTOM,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.white,
            ),
            child: Text(
              text,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ));
    }
  }
}
