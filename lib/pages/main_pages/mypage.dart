import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs_mvp/pages/login_page.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

import '../../providers/rt_data_provider.dart';

class MyPage extends StatelessWidget {
  MyPage({Key? key}) : super(key: key);
  // Authentication _auth = Authentication();
  RealtimeDataProvider rtDataProvider = RealtimeDataProvider();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
              child: Text(
            'Welcome, Bucheon Ok-gil Station!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    // _auth.signOut();
                    // rtDataProvider.dispose();
                    // rtDataProvider.
                    Get.offAll(() => LoginPage());
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 15),
                  )),
              IconButton(
                  onPressed: () {
                    // _auth.signOut();
                    // rtDataProvider.dispose();
                    Get.offAll(() => LoginPage());
                  },
                  icon: Icon(
                    Icons.logout_outlined,
                    color: Colors.blue,
                    size: 30,
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset('assets/images/gas_station1.gif'),
          ),
          // ElevatedButton(
          //   child: Text('Find Korean Postal Address'),
          //   onPressed: () async {
          //     KopoModel? model = await Navigator.push(
          //       context,
          //       CupertinoPageRoute(
          //         builder: (context) => RemediKopo(),
          //       ),
          //     );
          //     debugPrint('kopo : ${model?.addressEnglish}');
          //   },
          // ),
        ],
      ),
    );
  }
}
