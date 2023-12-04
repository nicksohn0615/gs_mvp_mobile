import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialogs {
  Widget _dialog(BuildContext context, String title, String contentText) {
    // debugPrint('getX height = ${Get.height}');
    // debugPrint('ctx height = ${MediaQuery.of(context).size.height}');
    return AlertDialog(
      elevation: 8.0,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      backgroundColor: Colors.white,
      title: Text("$title"),
      content: SizedBox(
        height: Get.height * 0.15,
        width: Get.width * 0.4,
        child: Column(
          children: [
            Text("$contentText"),
            // Text('test'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              // Navigator.of(context).pop();
              Get.back();
            },
            child: const Text("닫기"))
      ],
    );
  }

  VoidCallback? scaleDialog(
      BuildContext context, String title, String contentText) {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx, title, contentText),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
