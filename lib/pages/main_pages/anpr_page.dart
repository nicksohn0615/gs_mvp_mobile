import 'package:flutter/material.dart';

class AnprPage extends StatelessWidget {
  const AnprPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Stack(
        children: [
          Center(
              child: Opacity(
                  opacity: 0.5, child: Image.asset('assets/images/anpr.png'))),
          Center(
            child: Text(
              '준비중입니다.',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      )),
    );
  }
}
