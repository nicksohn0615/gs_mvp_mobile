import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gs_mvp/pages/main_pages/car_wash_congestion_page.dart';
import 'package:gs_mvp/pages/main_pages/conflict_point.dart';
import 'package:gs_mvp/pages/main_pages/home_page.dart';
import 'package:gs_mvp/pages/main_pages/live_page.dart';
import 'package:gs_mvp/pages/main_pages/mypage.dart';
import 'package:gs_mvp/providers/rt_data_provider.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // RealtimeDataProvider? rtDataProvider;
  RealtimeDataProvider rtDataProvider = RealtimeDataProvider();
  @override
  void initState() {
    super.initState();
    // _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await rtDataProvider!.connect();
      await rtDataProvider!.listenChannel();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    if (rtDataProvider != null) {
      rtDataProvider!.dispose();
    }
    super.dispose();
  }

  final List<Widget> _pages = <Widget>[
    HomePage(),
    CarWashCongesionPage(),
    // AnprPage(),
    ConflictPointPage(),
    CamViewer(),
    MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  int _selectedIndex2 = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;

  @override
  Widget build(BuildContext context) {
    double machineWidth = MediaQuery.of(context).size.width;
    double machineHeight = MediaQuery.of(context).size.height;
    bool portraitMode = machineWidth <= machineHeight;
    // return machineWidth <= machineHeight ? TabBarPage() : SideBarPage();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 130,
                height: 40,
                child: Center(
                  child: Text(
                    'Admin Panel',
                    style: TextStyle(fontSize: 18),
                  ),
                )),
            SizedBox(
              width: 1,
            ),
            SizedBox(
                width: 20,
                height: 40,
                child: Center(
                  child: Text(
                    'by ',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                )),
            SizedBox(
              width: 5,
            ),
            Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 70,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/logo/main_logo.svg',
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        backgroundColor: Color(0xff1E1250).withOpacity(0.85),
        elevation: 0,
      ),
      body: Row(
        children: [
          portraitMode
              ? SizedBox()
              : LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(child: _myNavigationRail())),
                  );
                }),
          const VerticalDivider(thickness: 1, width: 4),
          Expanded(child: _buildPageView(portraitMode)),
        ],
      ),
      // _pages.elementAt(_selectedIndex),

      bottomNavigationBar: portraitMode ? _myBottomNavBar() : null,
    );
  }

  PageView _buildPageView(bool isPortraitMode) {
    return PageView(
      controller: _pageController,
      scrollDirection: isPortraitMode ? Axis.horizontal : Axis.vertical,
      onPageChanged: (index) {
        setState(() => _selectedIndex = index);
      },
      children: _pages,
    );
  }

  SizedBox _myBottomNavBar() {
    return SizedBox(
      height: 100,
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_car_wash_outlined,
            ),
            label: '세차장 혼잡도',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.numbers_outlined,
          //   ),
          //   label: '차량번호판',
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.car_crash_outlined,
            ),
            label: '상충지점',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_camera_front_outlined),
            label: 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: '마이페이지',
          ),
        ],
        elevation: 4,
        type: BottomNavigationBarType.fixed,
        // backgroundColor: Colors.lightBlueAccent.withOpacity(0.5),
        backgroundColor: Color(0xff1E1250).withOpacity(0.85),
        // fixedColor: Colors.black12,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        selectedFontSize: 12,
        selectedLabelStyle: TextStyle(color: Colors.black),
        onTap: _onItemTapped,
        unselectedItemColor: Colors.white54,
        unselectedLabelStyle: TextStyle(color: Colors.black26),
        unselectedFontSize: 10,
      ),
    );
  }

  Widget _myNavigationRail() {
    return NavigationRail(
      backgroundColor: Color(0xff1E1250).withOpacity(0.85),
      selectedLabelTextStyle: TextStyle(color: Colors.white),
      unselectedLabelTextStyle: TextStyle(color: Colors.white54),
      minWidth: 120,
      // extended: true,
      selectedIndex: _selectedIndex,
      groupAlignment: groupAlignment,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
          _onItemTapped(index);
        });
      },
      labelType: labelType,
      leading: showLeading
          ? FloatingActionButton(
              elevation: 0,
              onPressed: () {
                // Add your onPressed code here!
              },
              child: const Icon(Icons.add),
            )
          : const SizedBox(),
      trailing: showTrailing
          ? IconButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              icon: const Icon(Icons.more_horiz_rounded),
            )
          : const SizedBox(),
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(
            Icons.home,
            color: Colors.white54,
          ),
          selectedIcon: Icon(
            Icons.local_car_wash_outlined,
            color: Colors.white,
          ),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.local_car_wash_outlined,
            color: Colors.white54,
          ),
          selectedIcon: Icon(
            Icons.local_car_wash_outlined,
            color: Colors.white,
          ),
          label: Text('세차장 혼잡도'),
        ),
        // NavigationRailDestination(
        //   icon: Icon(
        //     Icons.numbers_outlined,
        //     color: Colors.white54,
        //   ),
        //   selectedIcon: Icon(
        //     Icons.numbers_outlined,
        //     color: Colors.white,
        //   ),
        //   label: Text('차량번호판'),
        // ),
        NavigationRailDestination(
          icon: Icon(
            Icons.car_crash_outlined,
            color: Colors.white54,
          ),
          selectedIcon: Icon(
            Icons.car_crash_outlined,
            color: Colors.white,
          ),
          label: Text('상충지점'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.video_camera_front_outlined,
            color: Colors.white54,
          ),
          selectedIcon: Icon(
            Icons.video_camera_front_outlined,
            color: Colors.white,
          ),
          label: Text('Live'),
        ),
        NavigationRailDestination(
          icon: Icon(
            Icons.account_circle_outlined,
            color: Colors.white54,
          ),
          selectedIcon: Icon(
            Icons.account_circle_outlined,
            color: Colors.white,
          ),
          label: Text('마이페이지'),
        ),
      ],
    );
  }

  Row _myNavRail(Widget mainContentChild) {
    return Row(children: <Widget>[
      LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: NavigationRail(
              backgroundColor: Color(0xff1E1250).withOpacity(0.85),
              selectedLabelTextStyle: TextStyle(color: Colors.white),
              unselectedLabelTextStyle: TextStyle(color: Colors.white54),
              minWidth: 120,
              // extended: true,
              selectedIndex: _selectedIndex2,
              groupAlignment: groupAlignment,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex2 = index;
                });
              },
              labelType: labelType,
              leading: showLeading
                  ? FloatingActionButton(
                      elevation: 0,
                      onPressed: () {
                        // Add your onPressed code here!
                      },
                      child: const Icon(Icons.add),
                    )
                  : const SizedBox(),
              trailing: showTrailing
                  ? IconButton(
                      onPressed: () {
                        // Add your onPressed code here!
                      },
                      icon: const Icon(Icons.more_horiz_rounded),
                    )
                  : const SizedBox(),
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(
                    Icons.local_car_wash_outlined,
                    color: Colors.white54,
                  ),
                  selectedIcon: Icon(
                    Icons.local_car_wash_outlined,
                    color: Colors.white,
                  ),
                  label: Text('세차장 혼잡도'),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.numbers_outlined,
                    color: Colors.white54,
                  ),
                  selectedIcon: Icon(
                    Icons.numbers_outlined,
                    color: Colors.white,
                  ),
                  label: Text('차량번호판'),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.car_crash_outlined,
                    color: Colors.white54,
                  ),
                  selectedIcon: Icon(
                    Icons.car_crash_outlined,
                    color: Colors.white,
                  ),
                  label: Text('상충지점'),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.video_camera_front_outlined,
                    color: Colors.white54,
                  ),
                  selectedIcon: Icon(
                    Icons.video_camera_front_outlined,
                    color: Colors.white,
                  ),
                  label: Text('RTSP'),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white54,
                  ),
                  selectedIcon: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white,
                  ),
                  label: Text('마이페이지'),
                ),
              ],
            ),
          ),
        );
      }),
      const VerticalDivider(thickness: 4, width: 4),
      // This is the main content.
      Expanded(
        child: mainContentChild,
        //
        // child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //   Text('selectedIndex: $_selectedIndex'),
        //   const SizedBox(height: 20),
        //   Text('Label type: ${labelType.name}'),
        //   const SizedBox(height: 10),
        //   OverflowBar(
        //     spacing: 10.0,
        //     children: <Widget>[
        //       ElevatedButton(
        //         onPressed: () {
        //           setState(() {
        //             labelType = NavigationRailLabelType.none;
        //           });
        //         },
        //         child: const Text('None'),
        //       ),
        //       ElevatedButton(
        //         onPressed: () {
        //           setState(() {
        //             labelType = NavigationRailLabelType.selected;
        //           });
        //         },
        //         child: const Text('Selected'),
        //       ),
        //       ElevatedButton(
        //         onPressed: () {
        //           setState(() {
        //             labelType = NavigationRailLabelType.all;
        //           });
        //         },
        //         child: const Text('All'),
        //       ),
        //     ],
        //   ),
        //   const SizedBox(height: 20),
        //   Text('Group alignment: $groupAlignment'),
        //   const SizedBox(height: 10),
        //   OverflowBar(
        //     spacing: 10.0,
        //     children: <Widget>[
        //       ElevatedButton(
        //         onPressed: () {
        //           setState(() {
        //             groupAlignment = -1.0;
        //           });
        //         },
        //         child: const Text('Top'),
        //       ),
        //       ElevatedButton(
        //         onPressed: () {
        //           setState(() {
        //             groupAlignment = 0.0;
        //           });
        //         },
        //         child: const Text('Center'),
        //       ),
        //       ElevatedButton(
        //         onPressed: () {
        //           setState(() {
        //             groupAlignment = 1.0;
        //           });
        //         },
        //         child: const Text('Bottom'),
        //       ),
        //     ],
        //   ),
        //   const SizedBox(height: 20),
        //   OverflowBar(
        //     spacing: 10.0,
        //     children: <Widget>[
        //       ElevatedButton(
        //         onPressed: () {
        //           setState(() {
        //             showLeading = !showLeading;
        //           });
        //         },
        //         child: Text(showLeading ? 'Hide Leading' : 'Show Leading'),
        //       ),
        //       ElevatedButton(
        //         onPressed: () {
        //           setState(() {
        //             showTrailing = !showTrailing;
        //           });
        //         },
        //         child: Text(showTrailing ? 'Hide Trailing' : 'Show Trailing'),
        //       ),
        //     ],
        //   ),
        // ])
      )
    ]);
  }
}
