// import 'package:animated_digit/animated_digit.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gs_mvp/components/rtsp_player.dart';
// import 'package:gs_mvp/pages/test_page/card_page.dart';
// import 'package:gs_mvp/pages/test_page/firebase_rtdb_provider_test_page.dart';
//
// import '../../../providers/realtime_database_provider.dart';
//
// class RealTimeViewer extends StatefulWidget {
//   const RealTimeViewer({Key? key}) : super(key: key);
//
//   @override
//   State<RealTimeViewer> createState() => _RealTimeViewerState();
// }
//
// class _RealTimeViewerState extends State<RealTimeViewer> {
//   int numberOfWaitingCarsInt = 3;
//   int timeValueInSeconds = 100;
//   Color colorOfCircle = Colors.grey;
//
//   void openInfoDialog() {
//     Get.dialog(
//       AlertDialog(
//         title: const Text(
//           '실시간 혼잡도에 대해서',
//           style: TextStyle(color: Colors.grey),
//         ),
//         content: const Text(
//             ' 실시간 혼잡도는 세차장 대기차량 뿐만 아니라, \n세차장 주변 환경의 여러가지 요소를 고려한 수치입니다.'),
//         actions: [
//           TextButton(
//             child: const Text("닫기"),
//             onPressed: () => Get.back(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void openRtspDialog() {
//     double width = MediaQuery.of(context).size.width;
//     debugPrint('dialog width = ${width}');
//     // Orientation orientation = MediaQuery.of(context).orientation;
//     Get.dialog(
//       AlertDialog(
//         title: const Text(
//           '실시간 세차장 CCTV',
//           style: TextStyle(color: Colors.grey),
//         ),
//         content: SizedBox(
//           // width: width * 0.8,
//           // height: width * 0.8 * (9 / 16),
//           child: AspectRatio(
//             aspectRatio: 1.777,
//             child: RtspPlayer(
//               rtspAddress:
//                   "rtsp://admin:self1004@@118.37.223.147:8522/live/main7",
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             child: const Text("닫기"),
//             onPressed: () => Get.back(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // bool isPortrait = true;
//   Orientation orient = Orientation.portrait;
//   // late double screenWidth;
//
//   final _rtdbProvider = RealtimeDataBaseProviders();
//   var streamResult;
//
//   // void test(){_r}
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint('rebuilded!');
//     // double screenWidth = MediaQuery.of(context).size.width;
//     // if (MediaQuery.of(context).orientation != orientation) {
//     //   if (orientation == Orientation.portrait) {
//     //     orientation = Orientation.landscape;
//     //   } else {
//     //     orientation = Orientation.portrait;
//     //   }
//     //   setState(() {
//     //     screenWidth = MediaQuery.of(context).size.width;
//     //   });
//     // }
//
//     // Stream<DatabaseEvent> _stream = _rtdbProvider.rtdb.ref("bcokgil").onValue;
//     // _stream.listen((event) {
//     //   setState(() {
//     //     streamResult = event.snapshot.value;
//     //   });
//     //   debugPrint('stream result = ${streamResult}');
//     // });
//
//     // var streamResult = snshot.data!.snapshot.value
//
//     return OrientationBuilder(builder: (context, orientation) {
//       if (orient != orientation) {
//         Get.back();
//       }
//
//       orient = orientation;
//       return Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           SizedBox(
//             height: 20,
//           ),
//           // Text('realtime view page'),
//           Divider(
//             height: 4,
//             thickness: 4,
//           ),
//           SizedBox(height: 20),
//           SizedBox(
//             height: 30,
//             child: Stack(
//               children: [
//                 Row(
//                     // mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Text(
//                         '실시간 혼잡도',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 20),
//                       ),
//                       // SizedBox(
//                       //   width: 100,
//                       // ),
//                       //   IconButton(onPressed: () {}, icon: Icon(Icons.info_outline)),
//                       // ],
//                     ]),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           openInfoDialog();
//                         },
//                         icon: Icon(
//                           Icons.info_outline,
//                           color: Colors.grey,
//                           size: 20,
//                         )),
//                     SizedBox(
//                       width: 20,
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//           // Icon(
//           //   Icons.circle_outlined,
//           //   color: colorOfCircle,
//           //   size: 150,
//           // ),
//           SizedBox(
//             width: 200,
//             height: 200,
//             child: Center(
//               child: Stack(
//                 children: [
//                   Center(
//                     child: ShaderMask(
//                       shaderCallback: (Rect bounds) {
//                         return LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [Colors.red, Colors.orange],
//                         ).createShader(bounds);
//                       },
//                       child: Icon(
//                         Icons.circle_outlined,
//                         color: Colors.white,
//                         size: 160,
//                       ),
//                     ),
//                   ),
//                   Center(
//                       child: Text(
//                     '매우 혼잡',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 24,
//                         color: Colors.red),
//                   ))
//                 ],
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Column(
//                 children: [
//                   SizedBox(
//                     width: 40,
//                     height: 25,
//                     child: Center(
//                       child: IconButton(
//                           onPressed: () {
//                             // if (MediaQuery.of(context).orientation ==
//                             //     Orientation.portrait) {
//                             //   openRtspDialog();
//                             // } else {
//                             //   openRtspDialog();
//                             // }
//                             openRtspDialog();
//                           },
//                           icon: Icon(
//                             Icons.camera_alt_outlined,
//                             color: Colors.grey,
//                             size: 25,
//                           )),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 25,
//                     height: 20,
//                     child: Center(
//                       child: Text(
//                         'Live',
//                         style: TextStyle(
//                             fontSize: 10,
//                             color: Colors.grey,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 width: 10,
//               )
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Divider(
//             height: 4,
//             thickness: 4,
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             children: [
//               SizedBox(
//                 width: 20,
//               ),
//               Text(
//                 '대기차량',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           SizedBox(
//               height: 80, child: numberOfWaitingCar(numberOfWaitingCarsInt)),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                   onPressed: () {
//                     setState(() {
//                       if (numberOfWaitingCarsInt <= 0) {
//                         numberOfWaitingCarsInt = 0;
//                       } else {
//                         numberOfWaitingCarsInt--;
//                       }
//                     });
//                   },
//                   icon: Icon(Icons.remove_circle_outline)),
//               IconButton(
//                   onPressed: () {
//                     setState(() {
//                       if (numberOfWaitingCarsInt >= 5) {
//                         numberOfWaitingCarsInt = 5;
//                       } else {
//                         numberOfWaitingCarsInt++;
//                       }
//                     });
//                   },
//                   icon: Icon(Icons.add_circle_outline))
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Divider(
//             height: 4,
//             thickness: 4,
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             children: [
//               SizedBox(
//                 width: 20,
//               ),
//               Text(
//                 '대기시간',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 width: 120,
//               ),
//               SizedBox(
//                 width: 100,
//                 child: AnimatedDigitWidget(
//                   value: secondsToWaintingTime(timeValueInSeconds) <= 6000
//                       ? secondsToWaintingTime(timeValueInSeconds)
//                       : 6000, // or use controller
//                   textStyle: TextStyle(
//                       color: Colors.black87,
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold),
//                   // fractionDigits: 2,
//                   enableSeparator: true,
//                   separateSymbol: ":",
//                   separateLength: 2,
//                   // decimalSeparator: ",",
//                   // prefix: "\$",
//                   // suffix: "€",
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               SizedBox(
//                 width: 30,
//                 child: secondsToWaintingTime(timeValueInSeconds) <= 6000
//                     ? Text(' ')
//                     : Text(
//                         '이상',
//                         style: TextStyle(fontSize: 10, color: Colors.black45),
//                       ),
//               ),
//               SizedBox(
//                 width: 30,
//               ),
//               IconButton(onPressed: () {}, icon: Icon(Icons.refresh))
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Text(
//                 'Last Updated at ',
//                 style: TextStyle(color: Colors.grey),
//               ),
//               Text(
//                 '14:21:20',
//                 style: TextStyle(
//                     color: Colors.black87, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 width: 20,
//               )
//             ],
//           ),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                   onPressed: () {
//                     setState(() {
//                       timeValueInSeconds -= 20 * 60;
//                     });
//                   },
//                   icon: Icon(Icons.remove)),
//               IconButton(
//                   onPressed: () {
//                     setState(() {
//                       timeValueInSeconds += 20 * 60;
//                     });
//                   },
//                   icon: Icon(Icons.add)),
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Divider(
//             height: 4,
//             thickness: 4,
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           IconButton(
//               onPressed: () {
//                 Get.to(() => CardPage());
//               },
//               icon: Icon(Icons.ad_units_outlined)),
//           IconButton(
//               onPressed: () {
//                 Get.to(() => RTDBTest());
//               },
//               icon: Icon(Icons.tab_sharp)),
//           // Text('waiting time = ${streamResult['realtimeWaitingTime']}')
//         ],
//       ));
//     });
//   }
//
//   int secondsToWaintingTime(int seconds) {
//     int result;
//     if (seconds >= 0) {
//       int minute = seconds ~/ 60;
//       int remainder = seconds - minute * 60;
//       result = 100 * minute + remainder;
//     } else {
//       result = 0;
//     }
//     return result;
//   }
//
//   Container numberOfWaitingCar(int numberOfCars) {
//     List<int> widgetNumbers = <int>[1, 2, 3, 4, 5];
//     Color colorOfIcon = Colors.grey.withOpacity(0.5);
//     switch (numberOfCars) {
//       case 0:
//       // colorOfIcon = Colors.green.withOpacity(0.5);
//       case 1:
//         colorOfIcon = Colors.green;
//         break;
//       case 2:
//         colorOfIcon = Colors.lightGreen;
//         break;
//       case 3:
//         colorOfIcon = Colors.amber;
//         break;
//       case 4:
//         colorOfIcon = Colors.orange;
//         break;
//       case 5:
//         colorOfIcon = Colors.red;
//         break;
//     }
//     return Container(
//       width: 500,
//       color: Colors.grey.withOpacity(0.0),
//       child: Column(
//         children: [
//           Theme(
//             data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//             child: ExpansionTile(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 10,
//                   ),
//                   for (int i in widgetNumbers)
//                     carIcon(numberOfCars >= i
//                         ? colorOfIcon
//                         : Colors.grey.withOpacity(0.5)),
//                   // carIcon(numberOfCars >= 1
//                   //     ? colorOfIcon
//                   //     : Colors.grey.withOpacity(0.5)),
//                   // carIcon(numberOfCars >= 2
//                   //     ? colorOfIcon
//                   //     : Colors.grey.withOpacity(0.5)),
//                   // carIcon(numberOfCars >= 3
//                   //     ? colorOfIcon
//                   //     : Colors.grey.withOpacity(0.5)),
//                   // carIcon(numberOfCars >= 4
//                   //     ? colorOfIcon
//                   //     : Colors.grey.withOpacity(0.5)),
//                   // carIcon(numberOfCars >= 5
//                   //     ? colorOfIcon
//                   //     : Colors.grey.withOpacity(0.5)),
//                   // carIcon(Colors.grey.withOpacity(0.6)),
//                   // SizedBox(
//                   //   width: 20,
//                   // )
//                 ],
//               ),
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [Text('예상 대기차량 수 :  ${numberOfCars}')],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Icon carIcon(Color iconColor) {
//     return Icon(
//       Icons.directions_car_filled_outlined,
//       size: 40,
//       color: iconColor,
//     );
//   }
// }
