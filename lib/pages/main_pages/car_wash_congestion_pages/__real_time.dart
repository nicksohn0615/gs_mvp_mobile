// import 'dart:async';
// import 'dart:math';
//
// import 'package:animated_digit/animated_digit.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gs_mvp/components/rtsp_player.dart';
// import 'package:gs_mvp/modal/dialogs.dart';
// import 'package:intl/intl.dart';
// import 'package:speedometer_chart/speedometer_chart.dart';
//
// import '../../../providers/realtime_database_provider.dart';
//
// class ReatimeViewer extends StatefulWidget {
//   const ReatimeViewer({super.key});
//
//   @override
//   State<ReatimeViewer> createState() => _ReatimeViewerState();
// }
//
// class _ReatimeViewerState extends State<ReatimeViewer> {
//   CustomDialogs dialogsInstance = CustomDialogs();
//   final _rtdbProvider = RealtimeDataBaseProviders();
//   late Timer _timer1;
//   late Timer _timer2;
//   @override
//   void initState() {
//     initializeRtrvDataList();
//     _timer1 = Timer.periodic(Duration(seconds: 3), (_) {
//       setState(() {
//         changeLatestRtrvData();
//       });
//     });
//     _timer2 = Timer.periodic(Duration(seconds: 2), (_) {
//       setState(() {
//         _congestionAdded = 0.8 * Random().nextDouble() + 0.1;
//         // debugPrint('congestion added ${_congestionAdded}');
//       });
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _timer1.cancel();
//     _timer2.cancel();
//     super.dispose();
//   }
//
//   Future<void> connect() async {
//     // final wsUrl = Uri.parse('ws://10.0.2.2:8000/ws');
//     // final wsUrlSt = Uri.parse('ws://14.36.1.6:8000/ws/bp-st');
//     final wsUrlSt = Uri.parse('ws://121.169.212.87:8001/ws/bp-st');
//     // final wsUrlCol = Uri.parse('ws://14.36.1.6:8000/ws/bp-col');
//     final wsUrlCol = Uri.parse('ws://121.169.212.87:8001/ws/bp-col');
//
//     channelSt = WebSocketChannel.connect(wsUrlSt);
//
//     debugPrint('check1');
//     channelCol = WebSocketChannel.connect(wsUrlCol);
//     debugPrint('check2');
//     await channelCol!.ready;
//     debugPrint('check3');
//     await channelSt!.ready;
//     debugPrint('check4');
//     // channel!.
//     // channel!.sink.add('ping');
//     debugPrint('stream init');
//     setState(() {
//       _isReady = true;
//     });
//     channelCol!.sink.add('ping');
//     channelSt!.sink.add('ping');
//   }
//
//   double _congestionAdded = 0.0;
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
//                 debugPrint('event snapshot: ${eventSnapshot}');
//                 // debugPrint('${eventSnapshot['realtimeWaitingTime'].runtimeType}');
//                 double congestion = eventSnapshot['congestion']['value'];
//                 int realtimeWaitingTime =
//                     eventSnapshot['realtimeWaitingTime']['value'];
//                 int numberOfWaitingCars =
//                     eventSnapshot['numberOfWaitingCars']['value'];
//                 int timeStamp =
//                     eventSnapshot['realtimeWaitingTime']['time'].round();
//                 // DateTime savedDateTime =
//                 //     DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000)
//                 //         .add(Duration(hours: 9));
//                 DateTime savedDateTime =
//                     DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
//                 // debugPrint('Date time : ${savedDateTime}');
//                 return GridView.count(
//                   padding: const EdgeInsets.all(8.0),
//                   crossAxisCount: gridCrossAxisCoount,
//                   children: <Widget>[
//                     InkWell(
//                         onTap: () {},
//                         child: buildCustomCard(
//                             congestionCardContent(
//                                 congestion + _congestionAdded),
//                             '혼잡도')),
//                     InkWell(
//                         onTap: () {},
//                         child: buildCustomCard(
//                             // numberOfWaitingCarsCardContent(),
//                             numberOfWaitingCarsCardContent(numberOfWaitingCars),
//                             '대기차량')),
//                     InkWell(
//                         onTap: () {},
//                         child: buildCustomCard(
//                             waitingTimeCardContent(
//                                 realtimeWaitingTime, savedDateTime),
//                             // waitingTimeCardContent(260),
//                             '대기시간')),
//                     InkWell(
//                       onTap: () {},
//                       child:
//                           buildCustomCard(realtimeCctvContent(), '실시간 CCTV 보기'),
//                     ),
//                     InkWell(
//                         onTap: () {},
//                         child: buildCustomCard(
//                             realtimeRecordViewContent(), '실시간 기록보기')),
//                     // InkWell(
//                     //     onTap: () {
//                     //       initializeRtrvDataList();
//                     //     },
//                     //     child: Icon(
//                     //       Icons.add_alert_outlined,
//                     //       size: 20,
//                     //     )),
//                   ],
//                 );
//               }
//             }),
//       ),
//     );
//   }
//
//   Widget numberOfWaitingCar(int numberOfCars) {
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
//       // height: double.infinity,
//       // color: Colors.grey.withOpacity(0.5),
//       child: Theme(
//         data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//         child: ExpansionTile(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 width: 10,
//               ),
//               for (int i in widgetNumbers)
//                 carIcon(
//                     numberOfCarsValue >= i
//                         ? colorOfIcon
//                         : Colors.grey.withOpacity(0.5),
//                     MediaQuery.of(context).orientation == Orientation.portrait
//                         ? (1 / 12) * MediaQuery.of(context).size.width
//                         : (1 / 25) * MediaQuery.of(context).size.width),
//               SizedBox(
//                 width: 5,
//               ),
//               SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: Icon(
//                   Icons.arrow_circle_up_outlined,
//                   color:
//                       isItOverFive ? Colors.red : Colors.grey.withOpacity(0.2),
//                 ),
//               ),
//             ],
//           ),
//           children: [
//             Column(
//               children: [
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 20, child: Text('예상 대기차량 수')),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     SizedBox(
//                       height: 20,
//                       child: Text(
//                         isItOverFive ? '5' : '${numberOfCarsValue}',
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 7,
//                     ),
//                     SizedBox(
//                         height: 15,
//                         width: 20,
//                         child: isItOverFive
//                             ? Text('이상',
//                                 style:
//                                     TextStyle(fontSize: 10, color: Colors.grey))
//                             : Text('   '))
//                   ],
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Icon carIcon(Color iconColor, double size) {
//     return Icon(
//       Icons.directions_car_filled_outlined,
//       size: size,
//       color: iconColor,
//     );
//   }
//
//   // Widget realtimeRecordViewContent() {
//   //   return Expanded(
//   //       child: AnimationLimiter(
//   //     child: ListView.builder(
//   //         padding: const EdgeInsets.all(16.0),
//   //         itemCount: realtimeRecordViewDataList.length,
//   //         itemBuilder: (BuildContext context, int index) {
//   //           // debugPrint('list view idx: ${realtimeRecordViewDataList.length}');
//   //           return AnimationConfiguration.staggeredList(
//   //             position: index,
//   //             child: SlideAnimation(
//   //               duration: Duration(milliseconds: 1000),
//   //               verticalOffset: 10.0,
//   //               child: Padding(
//   //                 padding: const EdgeInsets.all(3.0),
//   //                 child: listViewItem(index),
//   //               ),
//   //             ),
//   //           );
//   //         }),
//   //   ));
//   // }
//
//   Widget realtimeRecordViewContent() {
//     return Expanded(
//         child: ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: realtimeRecordViewDataList.length,
//             itemBuilder: (BuildContext context, int index) {
//               // debugPrint('list view idx: ${realtimeRecordViewDataList.length}');
//               return Padding(
//                 padding: const EdgeInsets.all(3.0),
//                 child: listViewItem(index),
//               );
//             }));
//   }
//
//   List<List> realtimeRecordViewDataList = List.generate(10, (index) => []);
//
//   (int, int, int, int, DateTime) makeListViewItemsNumeric() {
//     List<int> areaNumbers = [1, 3, 4];
//     int areaNumberSelectIndex = Random().nextInt(3);
//     int areaNumber = areaNumbers[areaNumberSelectIndex];
//
//     int imgNumber = Random().nextInt(12) + 1;
//
//     int directionNum1 = Random().nextInt(20);
//     int directionNum2 = Random().nextInt(20);
//
//     // DateTime nowTime = DateTime.now().add(Duration(hours: 9));
//     DateTime nowTime = DateTime.now();
//     return (imgNumber, areaNumber, directionNum1, directionNum2, nowTime);
//   }
//
//   void initializeRtrvDataList() {
//     for (int i = 0; i < 10; i++) {
//       realtimeRecordViewDataList.elementAt(i).clear();
//     }
//     for (int i = 0; i < 10; i++) {
//       realtimeRecordViewDataList.elementAt(i).add(makeListViewItemsNumeric());
//     }
//     debugPrint('rtrv data initialized! : ${realtimeRecordViewDataList}');
//     setState(() {});
//   }
//
//   void changeLatestRtrvData() {
//     realtimeRecordViewDataList.removeAt(9);
//     // realtimeRecordViewDataList.elementAt(0).clear();
//     // realtimeRecordViewDataList.elementAt(0).add(makeListViewItemsNumeric());
//     realtimeRecordViewDataList.insert(0, [makeListViewItemsNumeric()]);
//   }
//
//   // img_num : 1 ~ 13 . png
//   // Area : 1, 3, 4
//   // direction (1~20, 1~20)
//
//   Widget listViewItem(int index) {
//     (int, int, int, int, DateTime) randomData =
//         realtimeRecordViewDataList[index][0];
//     // debugPrint('random data : ${randomData}');
//     // debugPrint('random data1 : ${randomData.$1}');
//     // debugPrint('random data2 : ${randomData.$2}');
//     // debugPrint('random data3 : ${randomData.$3}');
//     // debugPrint('random data4 : ${randomData.$4}');
//     int imgNum = randomData.$1;
//     int areaNum = randomData.$2;
//     int directionNum1 = randomData.$3;
//     int directionNum2 = randomData.$4;
//     DateTime dataTime = randomData.$5;
//     return SizedBox(
//       height: 100,
//       child: Card(
//         elevation: 12.0,
//         // height: 80,
//         // color:,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Text('index: ${index}'),
//             Expanded(flex: 1, child: SizedBox()),
//             Expanded(
//               flex: 10,
//               child: Padding(
//                   padding: EdgeInsets.all(4.0),
//                   child: Image.asset('assets/images/car_images/${imgNum}.png')),
//             ),
//             // Text('IN:${imgNum}'),
//             Expanded(flex: 1, child: SizedBox()),
//             Expanded(
//               flex: 20,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(1.0),
//                     child: Text(
//                         '${DateFormat('yyyy/MM/dd  HH:mm:ss').format(dataTime)}'),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(1.0),
//                     child: Text('Area: ${areaNum}'),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(1.0),
//                     child:
//                         Text('Direction: (${directionNum1}, ${directionNum2})'),
//                   )
//                 ],
//               ),
//             ),
//             Expanded(flex: 1, child: SizedBox()),
//           ],
//         ),
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
//   Widget realtimeCctvContent() {
//     return Expanded(
//       child: Column(
//         children: [
//           Expanded(
//             flex: 1,
//             child: SizedBox(),
//           ),
//           Expanded(
//             flex: 4,
//             child: SizedBox(
//               // height: 200,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Stack(
//                   children: [
//                     Center(
//                       child: Opacity(
//                           opacity: 0.5,
//                           child: Image.asset(
//                               'assets/images/cctv_live_card_img.png')),
//                     ),
//                     Center(
//                       child: SizedBox(
//                         height: 100,
//                         width: 100,
//                         child: IconButton(
//                             onPressed: () {
//                               openRtspDialog();
//                             },
//                             icon: Icon(
//                               Icons.camera_alt_outlined,
//                               color: Color(0xff1E1250).withOpacity(0.8),
//                               size: 80,
//                             )),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: SizedBox(),
//             flex: 1,
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget waitingTimeCardContent(int timeValueInSeconds, DateTime savedTime) {
//     // var now = DateTime.now().add(Duration(hours: 9));
//     // var timeZoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
//     // var nowTime = (DateTime.now().millisecondsSinceEpoch + timeZoneOffset);
//
//     String formattedSavedTime =
//         DateFormat('yyyy/MM/dd   HH:mm:ss').format(savedTime);
//     return Expanded(
//       child: Column(
//         children: [
//           Expanded(
//             flex: 3,
//             child: SizedBox(),
//           ),
//           Expanded(
//             flex: 5,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: 30,
//                 ),
//                 SizedBox(
//                   // width: 100,
//                   child: AnimatedDigitWidget(
//                     value: secondsToWaintingTime(timeValueInSeconds) <= 6000
//                         ? secondsToWaintingTime(timeValueInSeconds)
//                         : 6000, // or use controller
//                     textStyle: TextStyle(
//                         color: Colors.black54,
//                         fontSize: 50,
//                         fontWeight: FontWeight.bold),
//                     // fractionDigits: 2,
//                     enableSeparator: true,
//                     separateSymbol: ":",
//                     separateLength: 2,
//                     // decimalSeparator: ",",
//                     // prefix: "\$",
//                     // suffix: "€",
//                   ),
//                 ),
//                 // SizedBox(
//                 //   width: 10,
//                 // ),
//                 SizedBox(
//                   width: 30,
//                   child: secondsToWaintingTime(timeValueInSeconds) <= 6000
//                       ? Text(' ')
//                       : Text(
//                           '이상',
//                           style: TextStyle(fontSize: 10, color: Colors.black45),
//                         ),
//                 ),
//                 // SizedBox(
//                 //   width: 30,
//                 // ),
//                 // IconButton(onPressed: () {}, icon: Icon(Icons.refresh))
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: SizedBox(),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(
//               '예상대기시간',
//               style: TextStyle(color: Colors.black26),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: SizedBox(),
//           ),
//           Expanded(
//             flex: 2,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Last Updated at :'),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${formattedSavedTime}',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//
//                 // SizedBox(
//                 //   width: 10,
//                 // ),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: SizedBox(),
//           ),
//         ],
//       ),
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
//     return Expanded(
//       child: Center(
//         child: SizedBox(child: numberOfWaitingCar(numberOfWaitingCarsInt)),
//       ),
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
//     return Expanded(
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
//           Expanded(
//             flex: 1,
//             child: SizedBox(),
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
//           Expanded(
//             flex: 1,
//             child: SizedBox(),
//           ),
//           Expanded(
//             flex: 10,
//             child: Center(
//               child: SpeedometerChart(
//                 dimension: 220,
//                 minValue: 0,
//                 maxValue: 10,
//                 value: congestion,
//                 minTextValue: 'Min. 0',
//                 maxTextValue: 'Max. 100',
//                 graphColor: [Colors.green, Colors.yellow, Colors.red],
//                 pointerColor: Colors.lightBlueAccent,
//                 valueVisible: false,
//                 rangeVisible: false,
//                 pointerWidth: 30,
//                 animationDuration: 1000,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: SizedBox(),
//           ),
//           Expanded(
//             flex: 3,
//             child: Stack(children: [
//               Text(bottomeTextString,
//                   style: TextStyle(
//                       // color: bottomeTextColor,
//                       foreground: Paint()
//                         ..style = PaintingStyle.stroke
//                         ..strokeWidth = 0.6
//                         ..color = Colors.black12,
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold)),
//               Text(bottomeTextString,
//                   style: TextStyle(
//                       color: bottomeTextColor,
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold))
//             ]),
//           ),
//
//           Expanded(
//             flex: 1,
//             child: SizedBox(),
//           )
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
//             inCardWidget,
//           ],
//         ),
//       ),
//     );
//   }
// }
