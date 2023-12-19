import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'dart:typed_data';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gs_mvp/components/gas_price_chart.dart';
import 'package:gs_mvp/providers/data_provider.dart';
import 'package:weather_animation/weather_animation.dart';

import '../../providers/rt_data_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double congestion = 0.0;
  int realtimeWaitingTime = 0;
  int numberOfWaitingCars = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      listenConnectionReady();
      await listenStream();
    });

    // _broadCast = _realtimeDataProvider.streamController.stream;
    // _sub = _broadCast!.listen((event) {
    //   // debugPrint('event in homepage from provider ${event}');
    //   if (mounted) {
    //     totalCnt = event['totalCnt'];
    //     congestion = event['congestion'] as double;
    //     // debugPrint('check2');
    //     // realtimeWaitingTime = dataMap['waiting_time'];
    //     // debugPrint('check3');
    //     numberOfWaitingCars = event['numberOfWaitingCars'];
    //     // debugPrint('check4');
    //     // debugPrint(
    //     //     'electric_charging_waiting_cnt : ${dataMap['electric_charging_waiting_cnt']}');
    //     electricChargingWaitingCnt =
    //         event['electricChargingWaitingCnt']; // <--problem
    //     // debugPrint('check5');
    //     carInteriorWashCnt = event['carInteriorWashCnt'];
    //     flSpotsList = event['flSpotsList'];
    //     maxXValue = event['maxXValue'];
    //     setState(() {
    //       _isReady = true;
    //     });
    //   }
    // }, onDone: () {
    //   debugPrint('homepage sub done');
    //   if (_sub != null) {
    //     _sub!.cancel();
    //   }
    //   setState(() {
    //     _isReady = false;
    //   });
    // }, onError: (e) {
    //   debugPrint('homepage sub error, e = ${e}');
    //   if (_sub != null) {
    //     _sub!.cancel();
    //   }
    //   setState(() {
    //     _isReady = false;
    //   });
    // });

    super.initState();
    // listenConnectionReady();
    // listenStream();
    // dataProvider.getGasPice();
  }

  // late Timer _serverConnectTimer;

  Stream? _broadCast;
  StreamSubscription? _sub;

  DataProvider dataProvider = DataProvider();

  @override
  void dispose() {
    // _channel!.sink.close();
    // if (isServerConnectTimerActive) {
    //   _serverConnectTimer!.cancel();
    // }
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

  bool isServerConnectTimerActive = false;
  // WebSocketChannel? _channel;
  bool _isReady = false;

  // int cnt = 1;

  int electricChargingWaitingCnt = 0;
  int carInteriorWashCnt = 0;
  int totalCnt = 0;

  List<FlSpot> flSpotsList = [];
  int maxXValue = 5;

  Map weatherInfo = {};

  final _realtimeDataProvider = RealtimeDataProvider();

  final spinkit = SpinKitRotatingCircle(
    color: Colors.blueGrey,
    size: 50.0,
  );

  Timer? _reConnectTimer;

  // Future<void> reConnect() async {
  //   await _realtimeDataProvider.connect();
  //   listenStream();
  // }

  bool isDataProviderReady = false;

  Stream<bool>? _connectionReadyStream;
  StreamSubscription<bool>? _subConnectionReady;
  void listenConnectionReady() {
    debugPrint('listen connection ready init');
    _connectionReadyStream = _realtimeDataProvider.connectionReady.stream;
    debugPrint('_connectionReadyStream $_connectionReadyStream');
    _subConnectionReady = _connectionReadyStream!.listen(
        (event) {
          // debugPrint('sub bool event $event');
          setState(() {
            if (event) {
              isDataProviderReady = true;
              // debugPrint(
              //     'isDataProviderReady in homepage $isDataProviderReady');
              // _isReady = true;
            } else {
              isDataProviderReady = false;
              // debugPrint(
              //     'isDataProviderReady in homepage $isDataProviderReady');
              // _isReady = false;
            }
          });
        },
        onDone: () {},
        onError: (e) {
          debugPrint('error $e');
        });
  }

  Future<void> listenStream() async {
    await Future.delayed(Duration(milliseconds: 500));
    _broadCast = _realtimeDataProvider.streamController.stream;
    _sub = _broadCast!.listen((event) {
      // debugPrint('event in homepage from provider ${event}');
      if (mounted) {
        totalCnt = event['totalCnt'];
        congestion = event['congestion'] as double;
        // debugPrint('check2');
        // realtimeWaitingTime = dataMap['waiting_time'];
        // debugPrint('check3');
        numberOfWaitingCars = event['numberOfWaitingCars'];
        // debugPrint('check4');
        // debugPrint(
        //     'electric_charging_waiting_cnt : ${dataMap['electric_charging_waiting_cnt']}');
        electricChargingWaitingCnt =
            event['electricChargingWaitingCnt']; // <--problem
        // debugPrint('check5');
        carInteriorWashCnt = event['carInteriorWashCnt'];
        flSpotsList = event['flSpotsList'];
        maxXValue = event['maxXValue'];
        croppedImgList = event['croppedImgList'];
        croppedImgDateTimeList = event['croppedImgDateTimeList'];
        croppedImgAreaList = event['croppedImgAreaList'];

        // debugPrint('c1');
        weatherInfo = event['weatherInfo'];
        // debugPrint('c2');
        weatherCode = weatherInfo['weather'][0]['id'];
        // debugPrint('c3');
        temp = weatherInfo['main']['temp'];
        // debugPrint('c4');
        // debugPrint('c4 : ${(weatherInfo['main']['feels_like'])}');
        // debugPrint(
        //     'c4 type : ${(weatherInfo['main']['feels_like'].runtimeType)}');
        feelsLike =
            double.parse((weatherInfo['main']['feels_like']).toString());
        // debugPrint('c5');
        minTemp = weatherInfo['main']['temp_min'];
        // debugPrint('c6');
        maxTemp = weatherInfo['main']['temp_max'];
        // debugPrint('c7');
        pressure = weatherInfo['main']['pressure'].toDouble();
        // debugPrint('c8');
        humidity = weatherInfo['main']['humidity'].toDouble();
        // debugPrint('c9');
        windSpeed = weatherInfo['wind']['speed'];
        // debugPrint('c10');
        weatherMain = weatherInfo['weather'][0]['main'];
        weatherDescripstion = weatherInfo['weather'][0]['description'];

        setState(() {
          _isReady = true;
        });
      }
    }, onDone: () {
      debugPrint('homepage sub done');
      if (_sub != null) {
        _sub!.cancel();
      }
      setState(() {
        _isReady = false;
      });
    }, onError: (e) {
      debugPrint('homepage sub error, e = ${e}');
      if (_sub != null) {
        _sub!.cancel();
      }
      setState(() {
        _isReady = false;
      });
    });
  }

  WrapperScene weatherScene = SunnyScene();
  int? weatherCode;
  double? temp;
  double? feelsLike;
  double? maxTemp;
  double? minTemp;
  double? humidity;
  double? pressure;
  double? windSpeed;
  String? weatherMain;
  String? weatherDescripstion;

  Widget getWeatherCard(
      int weatherCode,
      double temp,
      double feelsLike,
      double maxTemp,
      double minTemp,
      double humidity,
      double pressure,
      double windSpeed,
      String main,
      String descripstion) {
    if (weatherCode == 800) {
      weatherScene = SunnyScene();
    } else if (weatherCode >= 800 && weatherCode < 805) {
      weatherScene = CloudyScene();
    } else if (weatherCode >= 500 && weatherCode < 600) {
      weatherScene = RainyScene();
    } else if (weatherCode >= 300 && weatherCode < 400) {
      weatherScene = RainyScene();
    } else if (weatherCode >= 200 && weatherCode < 300) {
      weatherScene = ThunderStormScene();
    } else if (weatherCode >= 600 && weatherCode < 700) {
      weatherScene = SnowyScene();
    } else if (weatherCode >= 700 && weatherCode < 800) {
      weatherScene = FoggyScene();
    }
    return Stack(
      children: [
        SizedBox(
            width: 400,
            height: 400,
            child: Opacity(opacity: 0.7, child: weatherScene)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Bucheon-si',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey)),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${temp.toStringAsFixed(1)} °C',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${weatherMain}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey)),
                        SizedBox(
                          height: 10,
                        ),
                        Text('${weatherDescripstion}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.black54))
                      ],
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              width: 40,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_up_outlined,
                        color: Colors.red,
                        size: 20,
                      ),
                      Text('${maxTemp.toStringAsFixed(1)} °C'),
                      // Text('/'),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.blue,
                        size: 20,
                      ),
                      Text('${minTemp.toStringAsFixed(1)}° C'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      // SizedBox(
                      //   width: 10,
                      // ),
                      Icon(
                        Icons.water_drop,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('${humidity.toStringAsFixed(1)} %'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      // SizedBox(
                      //   width: 10,
                      // ),
                      Icon(
                        Icons.feedback_outlined,
                        size: 14,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('${feelsLike.toStringAsFixed(1)} °C'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      // SizedBox(
                      //   width: 10,
                      // ),
                      Icon(
                        Icons.wind_power_outlined,
                        size: 14,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('${windSpeed.toStringAsFixed(1)} m/s'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      // SizedBox(
                      //   width: 10,
                      // ),
                      Icon(
                        Icons.air_outlined,
                        size: 14,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('${pressure} hPa'),
                    ],
                  )
                ])
          ],
        )
        // Center(
        //   child: Column(
        //     children: [
        //       SizedBox(
        //         height: 20,
        //       ),
        //       Text('temp $temp'),
        //       Text('feelsLiks $feelsLike'),
        //       Text('min temp $minTemp'),
        //       Text('max temp $maxTemp'),
        //       Text('pressure $pressure'),
        //       Text('humidity $humidity'),
        //       Text('wind speed $windSpeed'),
        //       Text('weather main $weatherMain'),
        //       Text('weather des $weatherDescripstion'),
        //       // Text(''),
        //       // Text(''),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  List<Uint8List> croppedImgList = [];
  List<String> croppedImgDateTimeList = [];
  List<int> croppedImgAreaList = [];

  Widget realtimeRecordViewContent() {
    return Expanded(
        child: croppedImgList.length > 0
            ? ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: croppedImgList.length,
                itemBuilder: (BuildContext context, int index) {
                  // debugPrint('list view idx: ${realtimeRecordViewDataList.length}');
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: listViewItem(index),
                  );
                })
            : Center(
                child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // CircularProgressIndicator(),

                        SpinKitPouringHourGlass(
                          color: Colors.black38,
                          size: 50,
                          duration: Duration(milliseconds: 1000),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('No objects detected yet')
                      ],
                    ))));
  }

  Widget listViewItem(int index) {
    Uint8List img = croppedImgList[index];
    String timeString = croppedImgDateTimeList[index];
    int areaNumInt = croppedImgAreaList[index];
    String areaString = '${croppedImgAreaList[index]}';
    return SizedBox(
      height: 100,
      child: Card(
        elevation: 12.0,
        // height: 80,
        // color:,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text('index: ${index}'),
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 10,
              child: Padding(
                  padding: EdgeInsets.all(4.0), child: Image.memory(img)),
            ),
            // Text('IN:${imgNum}'),
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(timeString),
                  ),
                  Divider(
                    height: 8,
                    color: Colors.grey,
                    indent: 18,
                    endIndent: 18,
                    thickness: 1.2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Area'),
                        SizedBox(
                          width: 4,
                        ),
                        Text(areaNumInt == 1
                            ? '⓵'
                            : areaNumInt == 3
                                ? '⓷'
                                : '⓸')
                        // Icon(Icons.number)
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(1.0),
                  //   child: Text('Direction: ( - , - )'),
                  // )
                ],
              ),
            ),
            Expanded(flex: 1, child: SizedBox()),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double machineWidth = MediaQuery.of(context).size.width;
    int gridCrossAxisCount = machineWidth ~/ 350;
    return _isReady
        ? !isDataProviderReady
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Connecting to Server...')
                ],
              ))
            : GridView.count(
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: gridCrossAxisCount,
                children: [
                    buildCustomCard(
                        Expanded(
                            child: AnimateGradient(
                          duration: Duration(milliseconds: 5000),
                          primaryBegin: Alignment.topLeft,
                          primaryEnd: Alignment.bottomLeft,
                          secondaryBegin: Alignment.bottomLeft,
                          secondaryEnd: Alignment.topRight,
                          primaryColors: [
                            // Color(0xff1E1250).withOpacity(0.1),
                            // Color(0xff1E1250).withOpacity(0.2),
                            // Colors.white.withOpacity(0.1)
                            Colors.pink.withOpacity(0.05),
                            Colors.pinkAccent.withOpacity(0.05),
                            Colors.white.withOpacity(0.1),
                          ],
                          secondaryColors: [
                            Colors.white.withOpacity(0.1),
                            Colors.blueAccent.withOpacity(0.1),
                            Colors.blue.withOpacity(0.1),
                          ],
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text('주유소 이용 차량 대수 : '),
                                  SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: Image.asset(
                                          'assets/images/home.png')),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    // '${electricChargingWaitingCnt + carInteriorWashCnt + numberOfWaitingCars}',
                                    '${totalCnt}',
                                    style: TextStyle(
                                        color: Colors.black45, fontSize: 28),
                                  ),
                                  // IconButton(
                                  //     onPressed: () {},
                                  //     icon: Icon(Icons.question_mark_outlined)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    showDuration: Duration(milliseconds: 3000),
                                    message: '주유소 이용 전체 차량 대수',
                                    child: Icon(
                                      Icons.info_outlined,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: Image.asset(
                                          'assets/images/electric_charging.png')),
                                  // Text('전기차 충전소 이용 차량 대수 : '),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${electricChargingWaitingCnt}',
                                    style: TextStyle(
                                        color: Colors.black45, fontSize: 28),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    showDuration: Duration(milliseconds: 3000),
                                    message: '전기차 충전소 이용 차량 대수',
                                    child: Icon(
                                      Icons.info_outlined,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text('차량 내부세차장 이용 차량 대수 : '),
                                  SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset(
                                          'assets/images/car_interior_cleaning.png')),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('${carInteriorWashCnt}',
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 28)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    showDuration: Duration(milliseconds: 3000),
                                    message: '차량 내부세차장 이용 차량 대수',
                                    child: Icon(
                                      Icons.info_outlined,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.analytics_outlined,
                                    size: 10,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    ' Working... ',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.grey),
                                  ),
                                  SizedBox(width: 8, height: 8, child: spinkit),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              )
                            ],
                          )),
                        )),
                        // '실시간 이용현황'
                        'Real-time usage status'),
                    buildCustomCard(
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 6,
                              ),
                              // SizedBox(
                              //   height: 6,
                              // ),
                              SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: 300,
                                        height: 180,
                                        child: MyLineChart(
                                          flSpotsList: flSpotsList,
                                          maxXValue: maxXValue,
                                        )),
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 12,
                                    width: 12,
                                    child: SpinKitPulse(
                                        duration: Duration(milliseconds: 1000),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          // debugPrint('index : ${index}');
                                          return DecoratedBox(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.redAccent,
                                            ),
                                          );
                                        }),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '${congestion}',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'up to 100s',
                                    style: TextStyle(
                                        fontSize: 8, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // '실시간 주유소 혼잡도 추이'
                        'Real-time congestion trend'),
                    buildCustomCard(realtimeRecordViewContent(), '실시간 차량기록'),
                    buildCustomCard(
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: SizedBox(
                              height: 240,
                              width: 240,
                              child: SingleChildScrollView(
                                child: HeatMapCalendar(
                                  // size: ,
                                  defaultColor: Colors.white,
                                  flexible: true,
                                  colorMode: ColorMode.opacity,
                                  datasets: {
                                    DateTime(2023, 11, 8): 3,
                                    DateTime(2023, 11, 9): 7,
                                    DateTime(2023, 11, 10): 10,
                                    DateTime(2023, 11, 11): 13,
                                    DateTime(2023, 11, 12): 6,
                                    DateTime(2023, 11, 13): 13,
                                    DateTime(2023, 11, 14): 8,
                                    DateTime(2023, 12, 1): 3,
                                    DateTime(2023, 12, 2): 7,
                                    DateTime(2023, 12, 3): 13,
                                    DateTime(2023, 12, 4): 4,
                                    DateTime(2023, 12, 5): 11,
                                    DateTime(2023, 12, 6): 1,
                                  },
                                  colorsets: const {
                                    1: Colors.red,
                                    3: Colors.red,
                                    5: Colors.red,
                                    7: Colors.red,
                                    9: Colors.red,
                                    11: Colors.red,
                                    13: Colors.red,
                                  },
                                  onClick: (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(value.toString())));
                                  },
                                ),
                              ),
                            ),
                          ),
                        )),
                        // '월간 누적 혼잡도 추이'
                        'Monthly congestion trend'),
                    // buildCustomCard(
                    //     Expanded(
                    //         child: Center(
                    //             child: WrapperScene(
                    //       colors: [Colors.white54, Colors.lightBlueAccent],
                    //       children: [
                    //         SunWidget(
                    //           sunConfig: SunConfig(
                    //             width: 262.0,
                    //             blurSigma: 5.0,
                    //             blurStyle: BlurStyle.inner,
                    //             isLeftLocation: true,
                    //             coreColor: Color(0xffffa726),
                    //             midColor: Color(0xd6ffee58),
                    //             outColor: Color(0xffff9800),
                    //             animMidMill: 2000,
                    //             animOutMill: 1800,
                    //           ),
                    //         ),
                    //         // CloudWidget(),
                    //         // WindWidget(),
                    //         // RainDropWidget(),
                    //         // SnowWidget(),
                    //         // RainWidget(),
                    //       ],
                    //     ))),
                    //     "Sunny Weather"),
                    // buildCustomCard(
                    //     Expanded(
                    //         child: Center(
                    //             child: WrapperScene(
                    //       colors: [Colors.white54, Colors.grey],
                    //       children: [
                    //         // SunWidget(),
                    //         CloudWidget(),
                    //         WindWidget(
                    //           windConfig: WindConfig(
                    //               windGap: 30,
                    //               color: Colors.blueGrey.withOpacity(0.5)),
                    //         ),
                    //         // RainDropWidget(),
                    //         // SnowWidget(),
                    //
                    //         // RainWidget(),
                    //       ],
                    //     ))),
                    //     "cloudy Weather"),
                    // buildCustomCard(
                    //     Expanded(
                    //         child: Center(
                    //             child: WrapperScene(
                    //       colors: [Colors.grey, Colors.grey, Colors.white],
                    //       children: [
                    //         // SunWidget(),
                    //         CloudWidget(),
                    //         // WindWidget(),
                    //         // RainDropWidget(),
                    //         SnowWidget(),
                    //
                    //         // RainWidget(),
                    //       ],
                    //     ))),
                    //     "Snowy Weather"),
                    // buildCustomCard(
                    //     Expanded(
                    //         child: Center(
                    //             child: WrapperScene(
                    //       colors: [Colors.white54, Colors.grey],
                    //       children: [
                    //         // SunWidget(),
                    //         CloudWidget(),
                    //         // WindWidget(),
                    //         // RainDropWidget(),
                    //         // SnowWidget(),
                    //         RainWidget(),
                    //       ],
                    //     ))),
                    //     "Rainy Weather"),
                    // buildCustomCard(
                    //     Expanded(
                    //         child: Center(
                    //             child: WrapperScene(
                    //       colors: [
                    //         Colors.black54,
                    //         Colors.grey,
                    //         Colors.grey,
                    //         Colors.white54
                    //       ],
                    //       children: [
                    //         // SunWidget(),
                    //         CloudWidget(),
                    //         // WindWidget(),
                    //         // RainDropWidget(),
                    //         // SnowWidget(),
                    //         ThunderWidget(),
                    //         RainWidget(),
                    //       ],
                    //     ))),
                    //     "ThunderStorm Weather"),
                    buildCustomCard(
                        Expanded(
                            child: Center(
                          child: weatherCode != null
                              ? getWeatherCard(
                                  weatherCode!,
                                  temp!,
                                  feelsLike!,
                                  maxTemp!,
                                  minTemp!,
                                  humidity!,
                                  pressure!,
                                  windSpeed!,
                                  weatherMain!,
                                  weatherDescripstion!)
                              : SpinKitDualRing(
                                  color: Colors.black54,
                                  duration: Duration(milliseconds: 900),
                                ),
                        )),
                        'Weather'),
                    buildCustomCard(
                        Expanded(
                            child: dataProvider.todayPriceList != null
                                ? GasPriceChart(
                                    yesterdayPriceList:
                                        dataProvider.yesterdayPriceList!,
                                    todayPriceList:
                                        dataProvider.todayPriceList!,
                                  )
                                : Center(
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.refresh,
                                          size: 28,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () async {
                                          await dataProvider.getGasPice();
                                        },
                                      ),
                                      Text(
                                        'Refresh',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      )
                                    ],
                                  ))),
                        'Gas Prices'),
                    // buildCustomCard(
                    //     Expanded(child: ThunderStormScene()), 'ThunderStrom'),
                    // buildCustomCard(Expanded(child: SunnyScene()), 'Sunny'),
                    // buildCustomCard(Expanded(child: CloudyScene()), 'Cloudy'),
                    // buildCustomCard(Expanded(child: RainyScene()), 'Rainy'),
                    // buildCustomCard(Expanded(child: SnowyScene()), 'Snowy'),
                    // buildCustomCard(Expanded(child: FoggyScene()), 'Foggy'),
                  ])
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
          ));
  }
}

class ThunderStormScene extends WrapperScene {
  ThunderStormScene(
      {super.key, super.children = childrenList, super.colors = colorsList});
  @override
  static const List<Widget> childrenList = [
    CloudWidget(),
    ThunderWidget(
      thunderConfig: ThunderConfig(thunderWidth: 20.0),
    ),
    RainWidget(),
  ];
  static const List<Color> colorsList = [
    Colors.black54,
    Colors.grey,
    Colors.grey,
    Colors.white54
  ];
}

class SunnyScene extends WrapperScene {
  SunnyScene(
      {super.key, super.children = childrenList, super.colors = colorsList});
  @override
  static const List<Widget> childrenList = [
    SunWidget(
      sunConfig: SunConfig(
        width: 262.0,
        blurSigma: 5.0,
        blurStyle: BlurStyle.inner,
        isLeftLocation: true,
        coreColor: Color(0xffffa726),
        midColor: Color(0xd6ffee58),
        outColor: Color(0xffff9800),
        animMidMill: 2000,
        animOutMill: 1800,
      ),
    ),
  ];
  static const List<Color> colorsList = [
    Colors.white54,
    Colors.lightBlueAccent
  ];
}

class RainyScene extends WrapperScene {
  RainyScene(
      {super.key, super.children = childrenList, super.colors = colorsList});
  @override
  static const List<Widget> childrenList = [
    CloudWidget(),
    RainWidget(
      rainConfig: RainConfig(color: Colors.lightBlueAccent, widthDrop: 5.0),
    ),
  ];
  static const List<Color> colorsList = [
    Colors.white54,
    Colors.grey,
    Colors.grey
  ];
}

class CloudyScene extends WrapperScene {
  CloudyScene(
      {super.key, super.children = childrenList, super.colors = colorsList});
  @override
  static const List<Widget> childrenList = [
    CloudWidget(),
    WindWidget(
      windConfig: WindConfig(windGap: 30, color: Colors.black54),
    ),
  ];
  static const List<Color> colorsList = [
    Colors.white54,
    Colors.grey,
  ];
}

class SnowyScene extends WrapperScene {
  SnowyScene(
      {super.key, super.children = childrenList, super.colors = colorsList});
  @override
  static const List<Widget> childrenList = [
    CloudWidget(),
    SnowWidget(),
  ];
  static const List<Color> colorsList = [
    Colors.white54,
    Colors.grey,
    Colors.grey,
    Colors.white
  ];
}

class FoggyScene extends WrapperScene {
  FoggyScene(
      {super.key, super.children = childrenList, super.colors = colorsList});
  @override
  static const List<Widget> childrenList = [
    CloudWidget(
      cloudConfig: CloudConfig(x: 20, y: 35, color: Colors.black38, size: 250),
    ),
    CloudWidget(
        cloudConfig: CloudConfig(
            x: 190,
            y: 170,
            color: Colors.black12,
            size: 180,
            slideDurMill: 2000))
  ];
  static const List<Color> colorsList = [
    Colors.white24,
    Colors.grey,
    Colors.grey,
    Colors.grey
  ];
}

class MyLineChart extends StatefulWidget {
  const MyLineChart(
      {super.key, required this.flSpotsList, required this.maxXValue});

  final List<FlSpot> flSpotsList;
  final int maxXValue;
  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  List<Color> gradientColors = [
    // AppColors.contentColorCyan,
    // AppColors.contentColorBlue,
    Colors.lightBlueAccent,
    Colors.blueAccent,
    Colors.blueGrey,
    // Colors.cyanAccent
    // Colors.deepOrangeAccent
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      mainData(widget.flSpotsList),
      duration: Duration(milliseconds: 500),
    );

    //   Stack(
    //   children: <Widget>[
    //     AspectRatio(
    //       aspectRatio: 1.8,
    //       child: Padding(
    //         padding: const EdgeInsets.only(
    //           right: 18,
    //           left: 12,
    //           top: 24,
    //           bottom: 12,
    //         ),
    //         child: LineChart(
    //           showAvg ? avgData() : mainData(),
    //         ),
    //       ),
    //     ),
    //     SizedBox(
    //       width: 44,
    //       height: 30,
    //       child: TextButton(
    //         style: TextButton.styleFrom(backgroundColor: Colors.blue),
    //         onPressed: () {
    //           setState(() {
    //             showAvg = !showAvg;
    //           });
    //         },
    //         child: Text(
    //           'avg',
    //           style: TextStyle(
    //             fontSize: 12,
    //             color: showAvg ? Colors.black87 : Colors.black38,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 6,
    );
    Widget text;
    if (value.toInt() % 10 == 0) {
      text = Text('${2 * value.toInt()}', style: style);
    } else {
      text = const Text('', style: style);
    }

    // switch (value.toInt()) {
    //   case 0:
    //     // text = const Text('11:00', style: style);
    //     text = const Text('0', style: style);
    //     break;
    //   case 20:
    //     // text = const Text('14:00', style: style);
    //     text = const Text('20', style: style);
    //     break;
    //   case 40:
    //     // text = const Text('18:00', style: style);
    //     text = const Text('40', style: style);
    //     break;
    //   case 60:
    //     text = const Text('60', style: style);
    //     break;
    //   case 80:
    //     text = const Text('80', style: style);
    //     break;
    //   default:
    //     text = const Text('', style: style);
    //     break;
    // }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 9,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 5:
        text = '5';
        break;
      case 10:
        text = '10';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData(List<FlSpot> flSpotsList) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 2,
        verticalInterval: 2,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.black26,
            strokeWidth: 0.15,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.black26,
            strokeWidth: 0.15,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 32,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        // border: Border.all(color: const Color(0xff37434d)),
        border: Border.all(color: Colors.grey),
      ),
      minX: max(0, widget.maxXValue.toDouble() - 99),
      maxX: widget.maxXValue.toDouble(),
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: flSpotsList,
          // [
          //   FlSpot(0, 5),
          //   FlSpot(2.6, 2),
          //   FlSpot(4.9, 5),
          //   FlSpot(6.8, 3.1),
          //   FlSpot(8, 4),
          //   FlSpot(9.5, 3),
          //   FlSpot(11, 4),
          // ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2.0,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors:
                  // [
                  //   ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  //       .lerp(0.2)!
                  //       .withOpacity(0.1),
                  //   ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  //       .lerp(0.2)!
                  //       .withOpacity(0.1),
                  // ],

                  gradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }
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
                    // color: Colors.indigo,
                    // color: Colors.blueAccent,
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
