// import 'dart:async';
// import 'dart:math';
//
// import 'package:animate_gradient/animate_gradient.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
//
// import '../../providers/rt_data_provider.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   double congestion = 0.0;
//   int realtimeWaitingTime = 0;
//   int numberOfWaitingCars = 0;
//
//   @override
//   void initState() {
//     // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//     //   // await connect();
//     //   // stream();
//     // });
//     // stream();
//
//     _broadCast = _realtimeDataProvider.streamController.stream;
//     _sub = _broadCast!.listen((event) {
//       // debugPrint('event in homepage from provider ${event}');
//       if (mounted) {
//         totalCnt = event['totalCnt'];
//         congestion = event['congestion'] as double;
//         // debugPrint('check2');
//         // realtimeWaitingTime = dataMap['waiting_time'];
//         // debugPrint('check3');
//         numberOfWaitingCars = event['numberOfWaitingCars'];
//         // debugPrint('check4');
//         // debugPrint(
//         //     'electric_charging_waiting_cnt : ${dataMap['electric_charging_waiting_cnt']}');
//         electricChargingWaitingCnt =
//             event['electricChargingWaitingCnt']; // <--problem
//         // debugPrint('check5');
//         carInteriorWashCnt = event['carInteriorWashCnt'];
//         flSpotsList = event['flSpotsList'];
//         maxXValue = event['maxXValue'];
//         setState(() {
//           _isReady = true;
//         });
//       }
//     }, onDone: () {
//       debugPrint('homepage sub done');
//       if (_sub != null) {
//         _sub!.cancel();
//       }
//       setState(() {
//         _isReady = false;
//       });
//     }, onError: (e) {
//       debugPrint('homepage sub error, e = ${e}');
//       if (_sub != null) {
//         _sub!.cancel();
//       }
//       setState(() {
//         _isReady = false;
//       });
//     });
//
//     super.initState();
//   }
//
//   // late Timer _serverConnectTimer;
//
//   Stream? _broadCast;
//   StreamSubscription? _sub;
//
//   @override
//   void dispose() {
//     // _channel!.sink.close();
//     // if (isServerConnectTimerActive) {
//     //   _serverConnectTimer!.cancel();
//     // }
//     if (_sub != null) {
//       _sub!.cancel();
//     }
//     super.dispose();
//   }
//
//   bool isServerConnectTimerActive = false;
//   // WebSocketChannel? _channel;
//   bool _isReady = false;
//
//   // int cnt = 1;
//
//   int electricChargingWaitingCnt = 0;
//   int carInteriorWashCnt = 0;
//   int totalCnt = 0;
//   //
//   // Future<void> connect() async {
//   //   try {
//   //     final wsUrl = Uri.parse('ws://121.169.212.87:8001/mobile/realtime');
//   //     debugPrint('check1');
//   //     _channel = WebSocketChannel.connect(wsUrl);
//   //     debugPrint('check2');
//   //     await _channel!.ready;
//   //     debugPrint('check3');
//   //     debugPrint('home stream init');
//   //     setState(() {
//   //       _isReady = true;
//   //     });
//   //   } catch (e) {
//   //     try {
//   //       _serverConnectTimer.cancel();
//   //     } catch (e) {
//   //       debugPrint('timer cancel error on try home: ${e}');
//   //     }
//   //     debugPrint('error home page when connect ${e}');
//   //   }
//   //
//   //   // _channel!.sink.add('ping');
//   //   _channel!.stream.listen(
//   //     (dynamic message) {
//   //       // debugPrint('message in homepage : $message');
//   //       Map<String, dynamic> dataMap = jsonDecode(jsonDecode(message));
//   //       debugPrint('datamap : $dataMap');
//   //       // debugPrint('check1');
//   //       totalCnt = dataMap['total_cnt'];
//   //       congestion = dataMap['congestion'] as double;
//   //       // debugPrint('check2');
//   //       realtimeWaitingTime = dataMap['waiting_time'];
//   //       // debugPrint('check3');
//   //       numberOfWaitingCars = dataMap['num_of_waiting_cars'];
//   //       // debugPrint('check4');
//   //       // debugPrint(
//   //       //     'electric_charging_waiting_cnt : ${dataMap['electric_charging_waiting_cnt']}');
//   //       electricChargingWaitingCnt =
//   //           dataMap['electric_charging_waiting_cnt']; // <--problem
//   //       // debugPrint('check5');
//   //       carInteriorWashCnt = dataMap['car_interior_wash_cnt'];
//   //       // debugPrint('check6');
//   //       setState(() {
//   //         flSpotsList.add(FlSpot(cnt.toDouble(), congestion));
//   //         if (flSpotsList.length > 100) {
//   //           flSpotsList.removeAt(0);
//   //         }
//   //         maxXValue = max(cnt, 5);
//   //       });
//   //       // debugPrint('flspotlist ${flSpotsList}');
//   //       cnt++;
//   //     },
//   //     onDone: () {
//   //       debugPrint('ws channel closed');
//   //       if (mounted) {
//   //         debugPrint('mounted home page');
//   //         setState(() {
//   //           _isReady = false;
//   //         });
//   //         _serverConnectTimer = Timer.periodic(Duration(seconds: 5), (_) async {
//   //           debugPrint('retry home connect');
//   //           isServerConnectTimerActive = true;
//   //           await connect();
//   //           _serverConnectTimer.cancel();
//   //           isServerConnectTimerActive = false;
//   //         });
//   //       } else {
//   //         debugPrint('unmounted home page');
//   //         // setState(() {
//   //         //   _isReady = false;
//   //         // });
//   //         // debugPrint(
//   //         //     '_serverConnectTimer.isActive ${_serverConnectTimer.isDefinedAndNotNull}');
//   //         try {
//   //           _serverConnectTimer.cancel();
//   //         } catch (e) {
//   //           debugPrint('timer cancel error home: ${e}');
//   //         }
//   //       }
//   //     },
//   //     onError: (error) {
//   //       debugPrint('ws home error $error');
//   //       setState(() {
//   //         _isReady = false;
//   //       });
//   //       try {
//   //         _serverConnectTimer.cancel();
//   //       } catch (e) {
//   //         debugPrint('home timer cancel error: ${e}');
//   //       }
//   //     },
//   //   );
//   //   setState(() {
//   //     _isReady = true;
//   //   });
//   // }
//
//   // late List<FlSpot> flSpotsList;
//   // List<FlSpot> flSpotsList = [FlSpot(0, 0)];
//   List<FlSpot> flSpotsList = [];
//   int maxXValue = 5;
//
//   final _realtimeDataProvider = RealtimeDataProvider();
//
//   final spinkit = SpinKitRotatingCircle(
//     color: Colors.blueGrey,
//     size: 50.0,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     double machineWidth = MediaQuery.of(context).size.width;
//     int gridCrossAxisCount = machineWidth ~/ 350;
//     return _isReady
//         ? GridView.count(
//             padding: const EdgeInsets.all(8.0),
//             crossAxisCount: gridCrossAxisCount,
//             children: [
//                 buildCustomCard(
//                     Expanded(
//                         child: AnimateGradient(
//                       duration: Duration(milliseconds: 5000),
//                       primaryBegin: Alignment.topLeft,
//                       primaryEnd: Alignment.bottomLeft,
//                       secondaryBegin: Alignment.bottomLeft,
//                       secondaryEnd: Alignment.topRight,
//                       primaryColors: [
//                         // Color(0xff1E1250).withOpacity(0.1),
//                         // Color(0xff1E1250).withOpacity(0.2),
//                         // Colors.white.withOpacity(0.1)
//                         Colors.pink.withOpacity(0.05),
//                         Colors.pinkAccent.withOpacity(0.05),
//                         Colors.white.withOpacity(0.1),
//                       ],
//                       secondaryColors: [
//                         Colors.white.withOpacity(0.1),
//                         Colors.blueAccent.withOpacity(0.1),
//                         Colors.blue.withOpacity(0.1),
//                       ],
//                       child: Center(
//                           child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               // Text('주유소 이용 차량 대수 : '),
//                               SizedBox(
//                                   width: 18,
//                                   height: 18,
//                                   child: Image.asset('assets/images/home.png')),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Text(
//                                 // '${electricChargingWaitingCnt + carInteriorWashCnt + numberOfWaitingCars}',
//                                 '${totalCnt}',
//                                 style: TextStyle(
//                                     color: Colors.black45, fontSize: 28),
//                               ),
//                               // IconButton(
//                               //     onPressed: () {},
//                               //     icon: Icon(Icons.question_mark_outlined)),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Tooltip(
//                                 triggerMode: TooltipTriggerMode.tap,
//                                 showDuration: Duration(milliseconds: 3000),
//                                 message: '주유소 이용 전체 차량 대수',
//                                 child: Icon(
//                                   Icons.info_outlined,
//                                   size: 16,
//                                   color: Colors.grey,
//                                 ),
//                               )
//                             ],
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                   width: 18,
//                                   height: 18,
//                                   child: Image.asset(
//                                       'assets/images/electric_charging.png')),
//                               // Text('전기차 충전소 이용 차량 대수 : '),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Text(
//                                 '${electricChargingWaitingCnt}',
//                                 style: TextStyle(
//                                     color: Colors.black45, fontSize: 28),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Tooltip(
//                                 triggerMode: TooltipTriggerMode.tap,
//                                 showDuration: Duration(milliseconds: 3000),
//                                 message: '전기차 충전소 이용 차량 대수',
//                                 child: Icon(
//                                   Icons.info_outlined,
//                                   size: 16,
//                                   color: Colors.grey,
//                                 ),
//                               )
//                             ],
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               // Text('차량 내부세차장 이용 차량 대수 : '),
//                               SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: Image.asset(
//                                       'assets/images/car_interior_cleaning.png')),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Text('${carInteriorWashCnt}',
//                                   style: TextStyle(
//                                       color: Colors.black45, fontSize: 28)),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Tooltip(
//                                 triggerMode: TooltipTriggerMode.tap,
//                                 showDuration: Duration(milliseconds: 3000),
//                                 message: '차량 내부세차장 이용 차량 대수',
//                                 child: Icon(
//                                   Icons.info_outlined,
//                                   size: 16,
//                                   color: Colors.grey,
//                                 ),
//                               )
//                             ],
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Icon(
//                                 Icons.analytics_outlined,
//                                 size: 10,
//                                 color: Colors.grey,
//                               ),
//                               Text(
//                                 ' Working... ',
//                                 style:
//                                     TextStyle(fontSize: 8, color: Colors.grey),
//                               ),
//                               SizedBox(width: 6, height: 6, child: spinkit),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                             ],
//                           )
//                         ],
//                       )),
//                     )),
//                     '실시간 이용현황'),
//                 buildCustomCard(
//                     Expanded(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             height: 6,
//                           ),
//                           // SizedBox(
//                           //   height: 6,
//                           // ),
//                           SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: SizedBox(
//                                     width: 300,
//                                     height: 180,
//                                     child: MyLineChart(
//                                       flSpotsList: flSpotsList,
//                                       maxXValue: maxXValue,
//                                     )),
//                               )),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 height: 10,
//                                 width: 10,
//                                 child: SpinKitPulse(
//                                     duration: Duration(milliseconds: 1000),
//                                     itemBuilder:
//                                         (BuildContext context, int index) {
//                                       // debugPrint('index : ${index}');
//                                       return DecoratedBox(
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: Colors.redAccent,
//                                         ),
//                                       );
//                                     }),
//                               ),
//                               SizedBox(
//                                 width: 4,
//                               ),
//                               Text(
//                                 '${congestion}',
//                                 style:
//                                     TextStyle(color: Colors.grey, fontSize: 8),
//                               )
//                             ],
//                           ),
//                           SizedBox(
//                             height: 6,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 'up to 200s',
//                                 style:
//                                     TextStyle(fontSize: 6, color: Colors.grey),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     '실시간 주유소 혼잡도 추이'),
//                 buildCustomCard(
//                     Expanded(
//                         child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Center(
//                         child: SizedBox(
//                           height: 240,
//                           width: 240,
//                           child: SingleChildScrollView(
//                             child: HeatMapCalendar(
//                               // size: ,
//                               defaultColor: Colors.white,
//                               flexible: true,
//                               colorMode: ColorMode.opacity,
//                               datasets: {
//                                 DateTime(2023, 11, 8): 3,
//                                 DateTime(2023, 11, 9): 7,
//                                 DateTime(2023, 11, 10): 10,
//                                 DateTime(2023, 11, 11): 13,
//                                 DateTime(2023, 11, 12): 6,
//                                 DateTime(2023, 11, 13): 13,
//                                 DateTime(2023, 11, 14): 8,
//                               },
//                               colorsets: const {
//                                 1: Colors.red,
//                                 3: Colors.red,
//                                 5: Colors.red,
//                                 7: Colors.red,
//                                 9: Colors.red,
//                                 11: Colors.red,
//                                 13: Colors.red,
//                               },
//                               onClick: (value) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text(value.toString())));
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     )),
//                     '월간 누적 혼잡도 추이')
//
//                 // buildCustomCard(
//                 //     Expanded(
//                 //         child: Center(
//                 //             child: Text(
//                 //       '${electricChargingWaitingCnt} 대',
//                 //       style: TextStyle(color: Colors.black45, fontSize: 20),
//                 //     ))),
//                 //     '전기차 충전소 이용 차량'),
//                 // buildCustomCard(
//                 //     Expanded(
//                 //         child: Center(
//                 //             child: Text('${carInteriorWashCnt} 대',
//                 //                 style: TextStyle(
//                 //                     color: Colors.black45, fontSize: 20)))),
//                 //     '내부 세차장 이용 차량'),
//               ])
//         : Center(child: CircularProgressIndicator());
//   }
// }
//
// class MyLineChart extends StatefulWidget {
//   const MyLineChart(
//       {super.key, required this.flSpotsList, required this.maxXValue});
//
//   final List<FlSpot> flSpotsList;
//   final int maxXValue;
//   @override
//   State<MyLineChart> createState() => _MyLineChartState();
// }
//
// class _MyLineChartState extends State<MyLineChart> {
//   List<Color> gradientColors = [
//     // AppColors.contentColorCyan,
//     // AppColors.contentColorBlue,
//     Colors.lightBlueAccent,
//     Colors.blueAccent,
//     Colors.blueGrey,
//     // Colors.cyanAccent
//     // Colors.deepOrangeAccent
//   ];
//
//   bool showAvg = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return LineChart(
//       mainData(widget.flSpotsList),
//       duration: Duration(milliseconds: 500),
//     );
//
//     //   Stack(
//     //   children: <Widget>[
//     //     AspectRatio(
//     //       aspectRatio: 1.8,
//     //       child: Padding(
//     //         padding: const EdgeInsets.only(
//     //           right: 18,
//     //           left: 12,
//     //           top: 24,
//     //           bottom: 12,
//     //         ),
//     //         child: LineChart(
//     //           showAvg ? avgData() : mainData(),
//     //         ),
//     //       ),
//     //     ),
//     //     SizedBox(
//     //       width: 44,
//     //       height: 30,
//     //       child: TextButton(
//     //         style: TextButton.styleFrom(backgroundColor: Colors.blue),
//     //         onPressed: () {
//     //           setState(() {
//     //             showAvg = !showAvg;
//     //           });
//     //         },
//     //         child: Text(
//     //           'avg',
//     //           style: TextStyle(
//     //             fontSize: 12,
//     //             color: showAvg ? Colors.black87 : Colors.black38,
//     //           ),
//     //         ),
//     //       ),
//     //     ),
//     //   ],
//     // );
//   }
//
//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.w300,
//       fontSize: 6,
//     );
//     Widget text;
//     if (value.toInt() % 10 == 0) {
//       text = Text('${2 * value.toInt()}', style: style);
//     } else {
//       text = const Text('', style: style);
//     }
//
//     // switch (value.toInt()) {
//     //   case 0:
//     //     // text = const Text('11:00', style: style);
//     //     text = const Text('0', style: style);
//     //     break;
//     //   case 20:
//     //     // text = const Text('14:00', style: style);
//     //     text = const Text('20', style: style);
//     //     break;
//     //   case 40:
//     //     // text = const Text('18:00', style: style);
//     //     text = const Text('40', style: style);
//     //     break;
//     //   case 60:
//     //     text = const Text('60', style: style);
//     //     break;
//     //   case 80:
//     //     text = const Text('80', style: style);
//     //     break;
//     //   default:
//     //     text = const Text('', style: style);
//     //     break;
//     // }
//
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: text,
//     );
//   }
//
//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.w500,
//       fontSize: 6,
//     );
//     String text;
//     switch (value.toInt()) {
//       case 0:
//         text = '0';
//         break;
//       case 5:
//         text = '5';
//         break;
//       case 10:
//         text = '10';
//         break;
//       default:
//         return Container();
//     }
//
//     return Text(text, style: style, textAlign: TextAlign.left);
//   }
//
//   LineChartData mainData(List<FlSpot> flSpotsList) {
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         horizontalInterval: 2,
//         verticalInterval: 2,
//         getDrawingHorizontalLine: (value) {
//           return const FlLine(
//             color: Colors.black26,
//             strokeWidth: 0.15,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return const FlLine(
//             color: Colors.black26,
//             strokeWidth: 0.15,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             interval: 1,
//             getTitlesWidget: bottomTitleWidgets,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             interval: 1,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 42,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         // border: Border.all(color: const Color(0xff37434d)),
//         border: Border.all(color: Colors.grey),
//       ),
//       minX: max(0, widget.maxXValue.toDouble() - 99),
//       maxX: widget.maxXValue.toDouble(),
//       minY: 0,
//       maxY: 10,
//       lineBarsData: [
//         LineChartBarData(
//           spots: flSpotsList,
//           // [
//           //   FlSpot(0, 5),
//           //   FlSpot(2.6, 2),
//           //   FlSpot(4.9, 5),
//           //   FlSpot(6.8, 3.1),
//           //   FlSpot(8, 4),
//           //   FlSpot(9.5, 3),
//           //   FlSpot(11, 4),
//           // ],
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors,
//           ),
//           barWidth: 2.0,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors:
//                   // [
//                   //   ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                   //       .lerp(0.2)!
//                   //       .withOpacity(0.1),
//                   //   ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                   //       .lerp(0.2)!
//                   //       .withOpacity(0.1),
//                   // ],
//
//                   gradientColors
//                       .map((color) => color.withOpacity(0.3))
//                       .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// Widget buildCustomCard(Widget inCardWidget, String titleText) {
//   return Padding(
//     padding: EdgeInsets.all(32.0),
//     child: Card(
//       // color: Colors.),
//       elevation: 8.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       // Define how the card's content should be clipped
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       // Define the child widget of the card
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                     height: 50,
//                     padding: EdgeInsets.all(8.0),
//                     color: Color(0xff1E1250).withOpacity(0.9),
//                     // decoration: BoxDecoration(
//                     //     gradient: LinearGradient(
//                     //         begin: Alignment.centerLeft,
//                     //         end: Alignment.centerRight,
//                     //         colors: [
//                     //       // Colors.white,
//                     //       Colors.white,
//                     //       Color(0xff1E1250),
//                     //       Color(0xff1E1250),
//                     //       Colors.white,
//                     //     ])),
//                     child: Center(
//                         child: Text(titleText,
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold)))),
//               ),
//             ],
//           ),
//           inCardWidget,
//         ],
//       ),
//     ),
//   );
// }
