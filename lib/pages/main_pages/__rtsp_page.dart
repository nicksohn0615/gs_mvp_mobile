// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gs_mvp/components/rtsp_player.dart';
//
// // import 'package:gs_mvp/components/rtsp_player.dart';
// import '../login_page.dart';
//
// // to do : side_navigation, indexed stack widget 도입.
//
// class CamViewer extends StatefulWidget {
//   CamViewer({Key? key}) : super(key: key);
//
//   @override
//   State<CamViewer> createState() => _CamViewerState();
// }
//
// class _CamViewerState extends State<CamViewer> {
//   @override
//   void initState() {
//     super.initState();
//
//     // _pageController = PageController();
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   int _selectedCamIndex = 0;
//   final PageController _pageController = PageController(keepPage: false);
//
//   late final List<Widget> _pages = List<Widget>.generate(
//       10,
//       (index) => RtspPlayer(
//             rtspAddress: _getRtspAdress(index),
//           ));
//
//   //
//   // <Widget>[
//   //   for ()RtspPlayer(
//   //     rtspAddress: rtspAdress,
//   //   )
//   // ];
//
//   // void _onItemTapped(int index) {
//   //   setState(() {
//   //     _selectedCamIndex = index;
//   //     _pageController.animateToPage(index,
//   //         duration: Duration(milliseconds: 500), curve: Curves.easeOut);
//   //   });
//   // }
//
//   String? selectedValue;
//
//   final List<String> items =
//       List<String>.generate(10, (index) => '${index + 1}');
//
//   // String _getRtspAdress(int i) {
//   //   return "rtsp://admin:User1357@175.198.165.148:8523/live/main${i}";
//   // }
//
//   String _getRtspAdress(int i) {
//     return "rtsp://admin:self1004@@118.37.223.147:8522/live/main${i}";
//   }
//
//   String rtspAdress = "rtsp://admin:User1357@175.198.165.148:8523/live/main0";
//
//   Widget _buildDropDownButton() {
//     return DropdownButtonHideUnderline(
//       child: DropdownButton2<String>(
//         isExpanded: true,
//         hint: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.linked_camera,
//               size: 16,
//               color: Colors.white60,
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Expanded(
//               child: Text(
//                 '1',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white54,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//         items: items
//             .map((String item) => DropdownMenuItem<String>(
//                   value: item,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.linked_camera,
//                         size: 16,
//                         color: Colors.white60,
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       Text(
//                         item,
//                         style: const TextStyle(
//                             fontSize: 18, color: Colors.white70),
//                       ),
//                     ],
//                   ),
//                 ))
//             .toList(),
//         value: selectedValue,
//         onChanged: (String? value) {
//           setState(() {
//             selectedValue = value;
//             if (value == null) {
//               _selectedCamIndex = 1;
//               debugPrint('value null');
//             } else {
//               _selectedCamIndex = int.parse(value) - 1;
//
//               _pageController.jumpToPage(int.parse(value) - 1);
//               // _pageController.animateToPage(int.parse(value) - 1,
//               //     duration: Duration(milliseconds: 500), curve: Curves.easeOut);
//               // _selectedCamIndex = int.parse(value);
//               // debugPrint('rtsp adress: ${rtspAdress}');
//               debugPrint('value ${value}');
//             }
//           });
//         },
//         buttonStyleData: ButtonStyleData(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           height: 30,
//           width: 100,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: Colors.black54,
//             ),
//             color: Colors.black38,
//           ),
//           elevation: 2,
//         ),
//         dropdownStyleData: DropdownStyleData(
//           maxHeight: 200,
//           width: 100,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             color: Colors.black38,
//           ),
//           offset: const Offset(0, 0),
//           scrollbarTheme: ScrollbarThemeData(
//             radius: const Radius.circular(8),
//             thickness: MaterialStateProperty.all(6),
//             thumbVisibility: MaterialStateProperty.all(true),
//           ),
//         ),
//         menuItemStyleData: const MenuItemStyleData(
//             height: 30, padding: EdgeInsets.only(left: 14, right: 14)),
//         iconStyleData: IconStyleData(
//             icon: Icon(Icons.keyboard_arrow_down),
//             iconDisabledColor: Colors.white24,
//             iconEnabledColor: Colors.white70),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//         body: SingleChildScrollView(
//       child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             Text('Welcome to CamViewer Page'),
//             SizedBox(
//               height: 20,
//             ),
//             // Center(
//             //   child: Container(
//             //     color: Colors.grey,
//             //     width: 200 * (16 / 9),
//             //     height: 200 + 73,
//             //   ),
//             // ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('CCTV 카메라 번호 : '),
//                 _buildDropDownButton(),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Center(
//               child: SizedBox(
//                   width: screenWidth * 0.95,
//                   height: screenWidth * (9 / 16) * 0.95,
//                   child: PageView(
//                     controller: _pageController,
//                     physics: NeverScrollableScrollPhysics(),
//                     onPageChanged: (index) {
//                       setState(() {
//                         _selectedCamIndex = index;
//                         selectedValue = (index + 1).toString();
//                       });
//                     },
//                     children: _pages,
//                   )
//
//                   // RtspPlayer(
//                   //   rtspAddress: rtspAdress,
//                   // )
//
//                   ),
//             ),
//
//             // Center(
//             //   child: SizedBox(
//             //       width: 200 * (16 / 9),
//             //       height: 200,
//             //       child: RtspPlayer(
//             //         rtspAddress:
//             //             "rtsp://admin:User1357@175.198.165.148:8523/live/main1",
//             //       )),
//             // ),
//
//             // SizedBox(
//             //     width: 400,
//             //     height: 200,
//             //     child: RtspPlayer(
//             //       rtspAddress:
//             //           "rtsp://admin:User1357@175.198.165.148:8523/live/main1",
//             //     )),
//             TextButton(
//                 onPressed: () {
//                   Get.offAll(() => LoginPage());
//                 },
//                 child: Text('Go to LoginPage')),
//             SizedBox(
//               height: 80,
//             )
//           ]),
//     ));
//   }
// }
