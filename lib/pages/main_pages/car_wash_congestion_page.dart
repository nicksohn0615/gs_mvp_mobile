import 'package:floating_tabbar/Models/tab_item.dart';
import 'package:floating_tabbar/Widgets/top_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gs_mvp/pages/main_pages/car_wash_congestion_pages/real_time.dart';
import 'package:gs_mvp/pages/main_pages/car_wash_congestion_pages/view_records.dart';

class CarWashCongesionPage extends StatelessWidget {
  const CarWashCongesionPage({Key? key}) : super(key: key);

  List<TabItem> topTabbarTabItemlist() {
    List<TabItem> topTabbarTabItemlist = [
      TabItem(
        onTap: () {},
        title: const Text(
          '실시간',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        tab: ReatimeViewer(),
      ),
      TabItem(
        // selectedLeadingIcon: Icon(
        //   CupertinoIcons.circle_fill,
        //   size: 15,
        //   color: Color(0xff1E1250),
        // ),
        // unSelectedLeadingIcon: Icon(
        //   Icons.circle_outlined,
        //   size: 15,
        //   color: Color(0xff1E1250),
        // ),
        onTap: () {},
        title: const Text(
          "기록보기",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        tab: RecordsViewer(),
      ),
    ];
    return topTabbarTabItemlist;
  }

  @override
  Widget build(BuildContext context) {
    return TopTabbar(
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0xff1E1250).withOpacity(0.2),
      ),
      labelColor: Color(0xff1E1250),
      // backgroundColor: Color(0xff1E1250).withOpacity(0.5),
      children: topTabbarTabItemlist(),
    );
    //   Container(
    //   child: Center(child: Text('page1')),
    // );
  }
}
