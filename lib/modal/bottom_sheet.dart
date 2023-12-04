import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheets {
  void openBottomSheet(String contentText) {
    Get.bottomSheet(
      Container(
        width: 300,
        height: 300,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          children: [
            // const SizedBox(height: 10),
            Align(
              child: Container(
                height: 10,
                width: 100,
                margin: EdgeInsets.only(top: 40, left: 40, right: 40),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.grey, width: 0.0),
                  borderRadius: BorderRadius.all(Radius.elliptical(100, 50)),
                ),
                child: Text('   '),
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: Text(
                '${contentText}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    '닫기',
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 30,
                )
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      isScrollControlled: true,
    );
  }
}
