import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:gs_mvp/components/rtsp_player.dart';
import 'package:gs_mvp/modal/dialogs.dart';
import 'package:intl/intl.dart';
import 'package:speedometer_chart/speedometer_chart.dart';

import '../../../providers/rt_data_provider.dart';

class ReatimeViewer extends StatefulWidget {
  const ReatimeViewer({super.key});

  @override
  State<ReatimeViewer> createState() => _ReatimeViewerState();
}

class _ReatimeViewerState extends State<ReatimeViewer> {
  Uint8List getImage(String str) {
    Uint8List imgArr = base64Decode(str);
    return imgArr;
  }

  double congestion = 0.0;
  int realtimeWaitingTime = 0;
  int numberOfWaitingCars = 0;

  CustomDialogs dialogsInstance = CustomDialogs();

  Future<void> listenStream() async {
    await Future.delayed(Duration(milliseconds: 500));
    _broadCast = _realtimeDataProvider.streamController.stream;
    _sub = _broadCast!.listen((event) {
      // debugPrint('event in homepage from provider ${event}');
      if (mounted) {
        // totalCnt = event['totalCnt'];
        congestion = event['congestion'] as double;
        // debugPrint('check2');
        // realtimeWaitingTime = dataMap['waiting_time'];
        // debugPrint('check3');
        numberOfWaitingCars = event['numberOfWaitingCars'];
        // croppedImg = event['croppedImg'];

        // croppedImgList = event['croppedImgList'];
        // croppedImgDateTimeList = event['croppedImgDateTimeList'];
        // croppedImgAreaList = event['croppedImgAreaList'];

        // if (croppedImg != null) {
        //   realtimeImgCheck = croppedImg;
        //   // croppedImgList.add(croppedImg!);
        //   croppedImgList.insert(0, croppedImg!);
        //   DateTime now = DateTime.now().toUtc().toLocal();
        //   String nowString = DateFormat('yy/MM/dd HH:mm:ss').format(now);
        //   // croppedImgDateTimeList.add(nowString);
        //   croppedImgDateTimeList.insert(0, nowString);
        //   if (croppedImgList.length > 10) {
        //     croppedImgList.removeLast();
        //   }
        //   if (croppedImgDateTimeList.length > 10) {
        //     croppedImgDateTimeList.removeLast();
        //   }
        // }

        setState(() {
          _isReady = true;
        });
      }
    }, onDone: () {
      debugPrint('realtime sub done');
      if (_sub != null) {
        _sub!.cancel();
      }
      setState(() {
        _isReady = false;
      });
    }, onError: (e) {
      debugPrint('realtime sub error, e = ${e}');
      if (_sub != null) {
        _sub!.cancel();
      }
      setState(() {
        _isReady = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      listenConnectionReady();
      await listenStream();
    });
  }

  bool isDataProviderReady = false;

  Stream<bool>? _connectionReadyStream;
  StreamSubscription? _subConnectionReady;
  void listenConnectionReady() {
    debugPrint('listen connection ready init');
    _connectionReadyStream = _realtimeDataProvider.connectionReady.stream;
    debugPrint('_connectionReadyStream $_connectionReadyStream');
    _subConnectionReady = _connectionReadyStream!.listen(
        (event) {
          setState(() {
            if (event) {
              isDataProviderReady = true;
              debugPrint('isDataProviderReady in rt $isDataProviderReady');
              // _isReady = true;
            } else {
              isDataProviderReady = false;
              debugPrint('isDataProviderReady in rt $isDataProviderReady');
              // _isReady = false;
            }
          });
        },
        onDone: () {},
        onError: (e) {
          debugPrint('error sub bool rt $e');
        });
  }

  // Uint8List? croppedImg;
  // List<Uint8List> croppedImgList = [];
  // List<String> croppedImgDateTimeList = [];
  // List<int> croppedImgAreaList = [];

  Stream? _broadCast;
  StreamSubscription? _sub;
  final _realtimeDataProvider = RealtimeDataProvider();

  // late Timer _serverConnectTimer;

  @override
  void dispose() {
    if (_sub != null) {
      _sub!.cancel();
    }
    if (_subConnectionReady != null) {
      _subConnectionReady!.cancel();
    }
    // if (_sub != null) {
    //   _sub!.cancel();
    // }
    super.dispose();
  }

  bool _isReady = false;

  double _congestionAdded = 0.0;

  Uint8List? realtimeImgCheck;

  @override
  Widget build(BuildContext context) {
    double machineWidth = MediaQuery.of(context).size.width;
    debugPrint('machine width = ${machineWidth}');
    int gridCrossAxisCount = machineWidth ~/ 350;
    return Scaffold(
      body: SafeArea(
          child: _isReady
              ? !isDataProviderReady
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text('서버에 연결 중...')
                      ],
                    ))
                  : GridView.count(
                      padding: const EdgeInsets.all(8.0),
                      crossAxisCount: gridCrossAxisCount,
                      children: <Widget>[
                        InkWell(
                            onTap: () {},
                            child: buildCustomCard(
                                congestionCardContent(
                                    congestion + _congestionAdded),
                                '혼잡도')),
                        InkWell(
                            onTap: () {},
                            child: buildCustomCard(
                                // numberOfWaitingCarsCardContent(),
                                numberOfWaitingCarsCardContent(
                                    numberOfWaitingCars),
                                '대기차량')),
                        // InkWell(
                        //     onTap: () {},
                        //     child: buildCustomCard(
                        //         waitingTimeCardContent(
                        //             realtimeWaitingTime, savedDateTime),
                        //         // waitingTimeCardContent(260),
                        //         '대기시간')),
                        InkWell(
                          onTap: () {},
                          child: buildCustomCard(
                              realtimeCctvContent(), '실시간 CCTV 보기'),
                        ),
                        // InkWell(
                        //     onTap: () {},
                        //     child: buildCustomCard(
                        //         realtimeRecordViewContent2(), '실시간 차량기록')),
                      ],
                    )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitDualRing(
                      color: Colors.black54,
                      duration: Duration(milliseconds: 900),
                    ),
                    // CircularProgressIndicator(),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Loading Data...')
                  ],
                ))),
    );
  }

  Widget numberOfWaitingCar(int numberOfCars) {
    List<int> widgetNumbers = <int>[1, 2, 3, 4, 5];
    Color colorOfIcon = Colors.grey.withOpacity(0.5);
    int numberOfCarsValue = numberOfCars > 5 ? 6 : numberOfCars;
    bool isItOverFive = false;

    switch (numberOfCarsValue) {
      case 0:
      // colorOfIcon = Colors.green.withOpacity(0.5);
      case 1:
        colorOfIcon = Colors.green;
        isItOverFive = false;
        break;
      case 2:
        colorOfIcon = Colors.lightGreen;
        isItOverFive = false;
        break;
      case 3:
        colorOfIcon = Colors.amber;
        isItOverFive = false;
        break;
      case 4:
        colorOfIcon = Colors.orange;
        isItOverFive = false;
        break;
      case 5:
        colorOfIcon = Colors.red;
        isItOverFive = false;
        break;
      case 6:
        colorOfIcon = Colors.red;
        isItOverFive = true;
    }
    return Container(
      // width: 500,
      // height: double.infinity,
      // color: Colors.grey.withOpacity(0.5),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              for (int i in widgetNumbers)
                carIcon(
                    numberOfCarsValue >= i
                        ? colorOfIcon
                        : Colors.grey.withOpacity(0.5),
                    38

                    // MediaQuery.of(context).orientation == Orientation.portrait
                    //     ? (1 / 12) * MediaQuery.of(context).size.width
                    //     : (1 / 25) * MediaQuery.of(context).size.width
                    ),
              SizedBox(
                width: 5,
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: Icon(
                  Icons.arrow_circle_up_outlined,
                  color:
                      isItOverFive ? Colors.red : Colors.grey.withOpacity(0.2),
                ),
              ),
            ],
          ),
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20, child: Text('예상 대기차량 수')),
                    SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(
                        isItOverFive ? '5' : '${numberOfCarsValue}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    SizedBox(
                        height: 15,
                        width: 20,
                        child: isItOverFive
                            ? Text('이상',
                                style:
                                    TextStyle(fontSize: 10, color: Colors.grey))
                            : Text('   '))
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Icon carIcon(Color iconColor, double size) {
    return Icon(
      Icons.directions_car_filled_outlined,
      size: size,
      color: iconColor,
    );
  }

  // Widget realtimeRecordViewContent() {
  //   return Expanded(
  //       child: AnimationLimiter(
  //     child: ListView.builder(
  //         padding: const EdgeInsets.all(16.0),
  //         itemCount: realtimeRecordViewDataList.length,
  //         itemBuilder: (BuildContext context, int index) {
  //           // debugPrint('list view idx: ${realtimeRecordViewDataList.length}');
  //           return AnimationConfiguration.staggeredList(
  //             position: index,
  //             child: SlideAnimation(
  //               duration: Duration(milliseconds: 1000),
  //               verticalOffset: 10.0,
  //               child: Padding(
  //                 padding: const EdgeInsets.all(3.0),
  //                 child: listViewItem(index),
  //               ),
  //             ),
  //           );
  //         }),
  //   ));
  // }

  // Widget listViewItem2(int index) {
  //   Uint8List img = croppedImgList[index];
  //   String timeString = croppedImgDateTimeList[index];
  //   String areaString = '${croppedImgAreaList[index]}';
  //   return SizedBox(
  //     height: 100,
  //     child: Card(
  //       elevation: 12.0,
  //       // height: 80,
  //       // color:,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           // Text('index: ${index}'),
  //           Expanded(flex: 1, child: SizedBox()),
  //           Expanded(
  //             flex: 10,
  //             child: Padding(
  //                 padding: EdgeInsets.all(4.0), child: Image.memory(img)),
  //           ),
  //           // Text('IN:${imgNum}'),
  //           Expanded(flex: 1, child: SizedBox()),
  //           Expanded(
  //             flex: 20,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(1.0),
  //                   child: Text(timeString),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(1.0),
  //                   child: Text('Area: ${areaString}'),
  //                 ),
  //                 // Padding(
  //                 //   padding: const EdgeInsets.all(1.0),
  //                 //   child: Text('Direction: ( - , - )'),
  //                 // )
  //               ],
  //             ),
  //           ),
  //           Expanded(flex: 1, child: SizedBox()),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget realtimeRecordViewContent2() {
  //   return Expanded(
  //       child: croppedImgList.length > 0
  //           ? ListView.builder(
  //               padding: const EdgeInsets.all(16.0),
  //               itemCount: croppedImgList.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 // debugPrint('list view idx: ${realtimeRecordViewDataList.length}');
  //                 return Padding(
  //                   padding: const EdgeInsets.all(3.0),
  //                   child: listViewItem2(index),
  //                 );
  //               })
  //           : Center(
  //               child: SizedBox(
  //                   width: 200,
  //                   height: 200,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       // CircularProgressIndicator(),
  //
  //                       SpinKitPouringHourGlass(
  //                         color: Colors.black38,
  //                         size: 50,
  //                         duration: Duration(milliseconds: 1000),
  //                       ),
  //                       SizedBox(
  //                         height: 10,
  //                       ),
  //                       Text('No objects detected yet')
  //                     ],
  //                   ))));
  // }

  void openRtspDialog() {
    double width = MediaQuery.of(context).size.width;
    debugPrint('dialog width = ${width}');
    // Orientation orientation = MediaQuery.of(context).orientation;
    Get.dialog(
      AlertDialog(
        title: const Text(
          '실시간 세차장 CCTV',
          style: TextStyle(color: Colors.grey),
        ),
        content: SizedBox(
          // width: width * 0.8,
          // height: width * 0.8 * (9 / 16),
          child: AspectRatio(
            aspectRatio: 1.777,
            child: RtspPlayer(
              rtspAddress:
                  // "rtsp://admin:self1004@@118.37.223.147:8522/live/main7",
                  // "rtsp://admin:self1004@118.37.223.147:8522/live/main7",
                  "rtsp://admin:self1004%40@118.37.223.147:8522/live/main7",
              // "rtsp://admin%3Aself1004%40@118.37.223.147:8522/live/main7",
              // "rtsp://admin:self1004%40%40118.37.223.147:8522/live/main7",
              // "rtsp://admin%3Aself1004%40%40118.37.223.147%3A8522%2Flive%2Fmain7",
              // "rtsp%3A%2F%2Fadmin%3Aself1004%40%40118.37.223.147%3A8522%2Flive%2Fmain7",
              // "rtsp://118.37.223.147:8522/live/main7",
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("닫기"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget realtimeCctvContent() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Expanded(
            flex: 4,
            child: SizedBox(
              // height: 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Center(
                      child: Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                              'assets/images/cctv_live_card_img.png')),
                    ),
                    Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: IconButton(
                            onPressed: () {
                              openRtspDialog();
                            },
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              // color: Color(0xff1E1250).withOpacity(0.8),
                              color: Colors.black,
                              size: 80,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(),
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget waitingTimeCardContent(int timeValueInSeconds, DateTime savedTime) {
    // var now = DateTime.now().add(Duration(hours: 9));
    // var timeZoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
    // var nowTime = (DateTime.now().millisecondsSinceEpoch + timeZoneOffset);

    String formattedSavedTime =
        DateFormat('yyyy/MM/dd   HH:mm:ss').format(savedTime);
    return Expanded(
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(),
          ),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  // width: 100,
                  child: AnimatedDigitWidget(
                    value: secondsToWaintingTime(timeValueInSeconds) <= 6000
                        ? secondsToWaintingTime(timeValueInSeconds)
                        : 6000, // or use controller
                    textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                    // fractionDigits: 2,
                    enableSeparator: true,
                    separateSymbol: ":",
                    separateLength: 2,
                    // decimalSeparator: ",",
                    // prefix: "\$",
                    // suffix: "€",
                  ),
                ),
                // SizedBox(
                //   width: 10,
                // ),
                SizedBox(
                  width: 30,
                  child: secondsToWaintingTime(timeValueInSeconds) <= 6000
                      ? Text(' ')
                      : Text(
                          '이상',
                          style: TextStyle(fontSize: 10, color: Colors.black45),
                        ),
                ),
                // SizedBox(
                //   width: 30,
                // ),
                // IconButton(onPressed: () {}, icon: Icon(Icons.refresh))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '예상대기시간',
              style: TextStyle(color: Colors.black26),
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Last Updated at :'),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '${formattedSavedTime}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                // SizedBox(
                //   width: 10,
                // ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  int secondsToWaintingTime(int seconds) {
    int result;
    if (seconds >= 0) {
      int minute = seconds ~/ 60;
      int remainder = seconds - minute * 60;
      result = 100 * minute + remainder;
    } else {
      result = 0;
    }
    return result;
  }

  Widget numberOfWaitingCarsCardContent(int numberOfWaitingCarsInt) {
    return Expanded(
      child: Center(
        child: SizedBox(child: numberOfWaitingCar(numberOfWaitingCarsInt)),
      ),
    );
  }

  Widget congestionCardContent(double congestion) {
    double congestionValue = congestion < 10 ? congestion : 9.99999999999;
    String bottomeTextString = '여유';
    Color bottomeTextColor = Colors.green;

    if (congestionValue <= 2.5) {
      bottomeTextColor = Colors.green;
      bottomeTextString = '여유';
    } else if (congestionValue > 2.5 && congestionValue <= 5.0) {
      bottomeTextColor = Colors.yellow;
      bottomeTextString = '보통';
    } else if (congestionValue > 5.0 && congestionValue <= 7.5) {
      bottomeTextColor = Colors.orangeAccent;
      bottomeTextString = '혼잡';
    } else if (congestionValue > 7.5) {
      bottomeTextColor = Colors.red;
      bottomeTextString = '매우 혼잡';
    }

    return Expanded(
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //         colors: [
        //       Colors.white,
        //       // Colors.white,
        //       Color(0xff1E1250).withOpacity(0.5),
        //       Color(0xff1E1250).withOpacity(0.5),
        //       Colors.white,
        //     ])),
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          // Row(
          //   children: [
          //     SizedBox(
          //       width: 20,
          //     ),
          //     Text(
          //       '혼잡도',
          //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //     ),
          //   ],
          // ),
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Expanded(
            flex: 10,
            child: Center(
              child: SpeedometerChart(
                dimension: 220,
                minValue: 0,
                maxValue: 10,
                value: congestion,
                minTextValue: 'Min. 0',
                maxTextValue: 'Max. 100',
                graphColor: [Colors.green, Colors.yellow, Colors.red],
                pointerColor: Colors.lightBlueAccent,
                valueVisible: false,
                rangeVisible: false,
                pointerWidth: 30,
                animationDuration: 1000,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Expanded(
            flex: 3,
            child: Stack(children: [
              Text(bottomeTextString,
                  style: TextStyle(
                      // color: bottomeTextColor,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 0.6
                        ..color = Colors.black12,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              Text(bottomeTextString,
                  style: TextStyle(
                      color: bottomeTextColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold))
            ]),
          ),

          Expanded(
            flex: 1,
            child: SizedBox(),
          )
        ],
      ),
    )

        // CircleChart(
        //     backgroundColor: Colors.grey,
        //     progressColor: progressionColor,
        //     showRate: false,
        //     progressNumber: congestionValue,
        //     maxNumber: 10,
        //     children: [])
        );
  }

  Widget buildCustomCard(Widget inCardWidget, String titleText) {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: Card(
        // color: Colors.),
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        // Define how the card's content should be clipped
        clipBehavior: Clip.antiAliasWithSaveLayer,
        // Define the child widget of the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Container(
                      height: 50,
                      padding: EdgeInsets.all(8.0),
                      // color: Color(0xff1E1250).withOpacity(0.9),
                      color: Colors.black54,
                      // decoration: BoxDecoration(
                      //     gradient: LinearGradient(
                      //         begin: Alignment.centerLeft,
                      //         end: Alignment.centerRight,
                      //         colors: [
                      //       // Colors.white,
                      //       Colors.white,
                      //       Color(0xff1E1250),
                      //       Color(0xff1E1250),
                      //       Colors.white,
                      //     ])),
                      child: Center(
                          child: Text(titleText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)))),
                ),
              ],
            ),
            inCardWidget,
          ],
        ),
      ),
    );
  }
}
