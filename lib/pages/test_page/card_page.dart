// import 'package:animated_digit/animated_digit.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gs_mvp/modal/dialogs.dart';
// import 'package:intl/intl.dart';
// import 'package:speedometer_chart/speedometer_chart.dart';
//
// import '../../components/rtsp_player.dart';
// import '../../providers/realtime_database_provider.dart';
//
// class CardPage extends StatefulWidget {
//   const CardPage({super.key});
//
//   @override
//   State<CardPage> createState() => _CardPageState();
// }
//
// class _CardPageState extends State<CardPage> {
//   CustomDialogs dialogsInstance = CustomDialogs();
//   final _rtdbProvider = RealtimeDataBaseProviders();
//
//   Container numberOfWaitingCar(int numberOfCars) {
//     List<int> widgetNumbers = <int>[1, 2, 3, 4, 5];
//     Color colorOfIcon = Colors.grey.withOpacity(0.5);
//     int numberOfCarsValue = numberOfCars > 5 ? 6 : numberOfCars;
//     bool isItOverFive = false;
//
//     switch (numberOfCarsValue) {
//       case 0:
//       // colorOfIcon = Colors.green.withOpacity(0.5);
//       case 1:
//         colorOfIcon = Colors.green;
//         isItOverFive = false;
//         break;
//       case 2:
//         colorOfIcon = Colors.lightGreen;
//         isItOverFive = false;
//         break;
//       case 3:
//         colorOfIcon = Colors.amber;
//         isItOverFive = false;
//         break;
//       case 4:
//         colorOfIcon = Colors.orange;
//         isItOverFive = false;
//         break;
//       case 5:
//         colorOfIcon = Colors.red;
//         isItOverFive = false;
//         break;
//       case 6:
//         colorOfIcon = Colors.red;
//         isItOverFive = true;
//     }
//     return Container(
//       // width: 500,
//       // height: 500,
//       color: Colors.grey.withOpacity(0.0),
//       child: Column(
//         children: [
//           SizedBox(
//             height: 100,
//           ),
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
//                     carIcon(numberOfCarsValue >= i
//                         ? colorOfIcon
//                         : Colors.grey.withOpacity(0.5)),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: Icon(
//                       Icons.arrow_circle_up_outlined,
//                       color: isItOverFive
//                           ? Colors.red
//                           : Colors.grey.withOpacity(0.2),
//                     ),
//                   ),
//                 ],
//               ),
//               children: [
//                 Column(
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(height: 20, child: Text('예상 대기차량 수')),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         SizedBox(
//                           height: 20,
//                           child: Text(
//                             '${numberOfCarsValue}',
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         SizedBox(
//                             height: 20,
//                             width: 30,
//                             child: isItOverFive
//                                 ? Text('이상',
//                                     style: TextStyle(
//                                         fontSize: 12, color: Colors.grey))
//                                 : Text('   '))
//                       ],
//                     ),
//                   ],
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
//
//   @override
//   Widget build(BuildContext context) {
//     double machineWidth = MediaQuery.of(context).size.width;
//     debugPrint('machine width = ${machineWidth}');
//     int gridCrossAxisCoount = machineWidth ~/ 350;
//     return Scaffold(
//       body: SafeArea(
//         child: StreamBuilder(
//             stream: _rtdbProvider.rtdb.ref("bcokgil").onValue,
//             builder: (BuildContext context, snshot) {
//               if (!snshot.hasData) {
//                 debugPrint("Waiting");
//                 return const CircularProgressIndicator(color: Colors.white);
//               } else if (snshot.hasError) {
//                 debugPrint("Error occured...");
//                 return const CircularProgressIndicator(color: Colors.white);
//               } else {
//                 var eventSnapshot;
//                 // Map eventSnapshot = snshot.data!.snapshot.value;
//                 eventSnapshot = snshot.data!.snapshot.value;
//                 // debugPrint('${eventSnapshot['realtimeWaitingTime'].runtimeType}');
//                 double congestion = eventSnapshot['congestion'];
//                 int realtimeWaitingTime = eventSnapshot['realtimeWaitingTime'];
//                 int numberOfWaitingCars = eventSnapshot['numberOfWaitingCars'];
//                 return GridView.count(
//                   padding: const EdgeInsets.all(8.0),
//                   crossAxisCount: gridCrossAxisCoount,
//                   children: <Widget>[
//                     InkWell(
//                         onTap: () {},
//                         child: buildCustomCard(
//                             congestionCardContent(congestion), '혼잡도')),
//                     InkWell(
//                         onTap: () {},
//                         child: buildCustomCard(
//                             // numberOfWaitingCarsCardContent(),
//                             numberOfWaitingCarsCardContent(numberOfWaitingCars),
//                             '대기차량')),
//                     InkWell(
//                         onTap: () {},
//                         child: buildCustomCard(
//                             waitingTimeCardContent(realtimeWaitingTime),
//                             // waitingTimeCardContent(260),
//                             '대기시간')),
//                     InkWell(
//                       onTap: () {
//                         openRtspDialog();
//                       },
//                       child:
//                           buildCustomCard(realtimeCctvContent(), '실시간 CCTV 보기'),
//                     ),
//                     InkWell(
//                         onTap: () {
//                           dialogsInstance.scaleDialog(
//                               context, 'hello5', 'texxt');
//                         },
//                         child: buildCustomCard(
//                             realtimeRecordViewContent(), '실시간 기록보기')),
//                   ],
//                 );
//               }
//             }),
//       ),
//     );
//   }
//
//   Widget realtimeRecordViewContent() {
//     return Text('!');
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
//   Widget realtimeCctvContent() {
//     return Column(
//       children: [
//         SizedBox(
//           height: 50,
//         ),
//         SizedBox(
//           height: 200,
//           child: Stack(
//             children: [
//               Center(
//                 child: Opacity(
//                     opacity: 0.5,
//                     child: Image.asset('assets/images/cctv_live_card_img.png')),
//               ),
//               Center(
//                 child: Icon(
//                   Icons.camera_alt_outlined,
//                   color: Color(0xff1E1250).withOpacity(0.8),
//                   size: 100,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget waitingTimeCardContent(int timeValueInSeconds) {
//     var now = DateTime.now().add(Duration(hours: 9));
//     // var timeZoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
//     // var nowTime = (DateTime.now().millisecondsSinceEpoch + timeZoneOffset);
//     String formattedNowTime = DateFormat('yyyy/MM/dd   HH:mm:ss').format(now);
//     return Column(
//       children: [
//         SizedBox(
//           height: 100,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 30,
//             ),
//             SizedBox(
//               // width: 100,
//               child: AnimatedDigitWidget(
//                 value: secondsToWaintingTime(timeValueInSeconds) <= 6000
//                     ? secondsToWaintingTime(timeValueInSeconds)
//                     : 6000, // or use controller
//                 textStyle: TextStyle(
//                     color: Colors.black54,
//                     fontSize: 50,
//                     fontWeight: FontWeight.bold),
//                 // fractionDigits: 2,
//                 enableSeparator: true,
//                 separateSymbol: ":",
//                 separateLength: 2,
//                 // decimalSeparator: ",",
//                 // prefix: "\$",
//                 // suffix: "€",
//               ),
//             ),
//             // SizedBox(
//             //   width: 10,
//             // ),
//             SizedBox(
//               width: 30,
//               child: secondsToWaintingTime(timeValueInSeconds) <= 6000
//                   ? Text(' ')
//                   : Text(
//                       '이상',
//                       style: TextStyle(fontSize: 10, color: Colors.black45),
//                     ),
//             ),
//             // SizedBox(
//             //   width: 30,
//             // ),
//             // IconButton(onPressed: () {}, icon: Icon(Icons.refresh))
//           ],
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         Text(
//           '예상대기시간',
//           style: TextStyle(color: Colors.black26),
//         ),
//         SizedBox(
//           height: 50,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Last Updated at :'),
//             SizedBox(
//               width: 5,
//             ),
//             Text(
//               '${formattedNowTime}',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             // SizedBox(
//             //   width: 10,
//             // ),
//           ],
//         )
//       ],
//     );
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
//   Widget numberOfWaitingCarsCardContent(int numberOfWaitingCarsInt) {
//     return Center(
//       child: SizedBox(child: numberOfWaitingCar(numberOfWaitingCarsInt)),
//     );
//   }
//
//   Widget congestionCardContent(double congestion) {
//     double congestionValue = congestion < 10 ? congestion : 9.99999999999;
//     String bottomeTextString = '여유';
//     Color bottomeTextColor = Colors.green;
//
//     if (congestionValue <= 2.5) {
//       bottomeTextColor = Colors.green;
//       bottomeTextString = '여유';
//     } else if (congestionValue > 2.5 && congestionValue <= 5.0) {
//       bottomeTextColor = Colors.yellow;
//       bottomeTextString = '보통';
//     } else if (congestionValue > 5.0 && congestionValue <= 7.5) {
//       bottomeTextColor = Colors.orangeAccent;
//       bottomeTextString = '혼잡';
//     } else if (congestionValue > 7.5) {
//       bottomeTextColor = Colors.red;
//       bottomeTextString = '매우 혼잡';
//     }
//
//     return Container(
//         // decoration: BoxDecoration(
//         //     gradient: LinearGradient(
//         //         begin: Alignment.topLeft,
//         //         end: Alignment.bottomRight,
//         //         colors: [
//         //       Colors.white,
//         //       // Colors.white,
//         //       Color(0xff1E1250).withOpacity(0.5),
//         //       Color(0xff1E1250).withOpacity(0.5),
//         //       Colors.white,
//         //     ])),
//         child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           SizedBox(
//             height: 10,
//           ),
//           // Row(
//           //   children: [
//           //     SizedBox(
//           //       width: 20,
//           //     ),
//           //     Text(
//           //       '혼잡도',
//           //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           //     ),
//           //   ],
//           // ),
//           SizedBox(
//             height: 40,
//           ),
//           SpeedometerChart(
//             dimension: 240,
//             minValue: 0,
//             maxValue: 10,
//             value: congestion,
//             minTextValue: 'Min. 0',
//             maxTextValue: 'Max. 100',
//             graphColor: [Colors.green, Colors.yellow, Colors.red],
//             pointerColor: Colors.lightBlueAccent,
//             valueVisible: false,
//             rangeVisible: false,
//             pointerWidth: 30,
//             animationDuration: 1000,
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           Stack(children: [
//             Text(bottomeTextString,
//                 style: TextStyle(
//                     // color: bottomeTextColor,
//                     foreground: Paint()
//                       ..style = PaintingStyle.stroke
//                       ..strokeWidth = 0.6
//                       ..color = Colors.black12,
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold)),
//             Text(bottomeTextString,
//                 style: TextStyle(
//                     color: bottomeTextColor,
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold))
//           ]),
//           // SizedBox(
//           //   height: 40,
//           // )
//         ],
//       ),
//     )
//
//         // CircleChart(
//         //     backgroundColor: Colors.grey,
//         //     progressColor: progressionColor,
//         //     showRate: false,
//         //     progressNumber: congestionValue,
//         //     maxNumber: 10,
//         //     children: [])
//         );
//   }
//
//   Widget buildCustomCard(Widget inCardWidget, String titleText) {
//     return Padding(
//       padding: EdgeInsets.all(32.0),
//       child: Card(
//         // color: Colors.),
//         elevation: 8.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         // Define how the card's content should be clipped
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         // Define the child widget of the card
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                       height: 50,
//                       padding: EdgeInsets.all(8.0),
//                       color: Color(0xff1E1250).withOpacity(0.9),
//                       // decoration: BoxDecoration(
//                       //     gradient: LinearGradient(
//                       //         begin: Alignment.centerLeft,
//                       //         end: Alignment.centerRight,
//                       //         colors: [
//                       //       // Colors.white,
//                       //       Colors.white,
//                       //       Color(0xff1E1250),
//                       //       Color(0xff1E1250),
//                       //       Colors.white,
//                       //     ])),
//                       child: Center(
//                           child: Text(titleText,
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold)))),
//                 ),
//               ],
//             ),
//             // Add padding around the row widget
//             Padding(
//                 padding: EdgeInsets.all(0.0),
//                 child: Center(child: inCardWidget)),
//           ],
//         ),
//       ),
//     );
//   }
// }
