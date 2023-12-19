import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:media_kit/media_kit.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RealtimeDataProvider {
  static final RealtimeDataProvider instance = RealtimeDataProvider._internal();
  // factory RealtimeDataProvider() => instance;
  factory RealtimeDataProvider() {
    return instance;
  }
  RealtimeDataProvider._internal();
  // RealtimeDataProvider(){};

  Timer? _serverConnectTimer;
  WebSocketChannel? _channel;
  double congestion = 0.0;
  int realtimeWaitingTime = 0;
  int numberOfWaitingCars = 0;
  int totalCnt = 0;
  int electricChargingWaitingCnt = 0;
  int carInteriorWashCnt = 0;
  bool isConnected = false;
  Map weatherInfo = {};

  int cnt = 1;

  List<FlSpot> flSpotsList = [FlSpot(0, 0)];
  int maxXValue = 5;

  StreamController streamController = StreamController.broadcast();
  // StreamController? streamController;

  // Future<void> broadCast()async{
  //   Stream broadCastStream = streamController.stream.asBroadcastStream();
  // }
  StreamSubscription? _sub;

  void dispose() {
    if (_sub != null) {
      _sub!.cancel();
    }
    streamController.close();
    connectionReady.close();
  }

  Uint8List? croppedImg;
  String? croppedImgString;
  String? croppedData;
  int? areaNum;
  Map<String, dynamic>? jsonData;
  //
  // Uint8List? croppedImg;
  List<Uint8List> croppedImgList = [];
  List<String> croppedImgDateTimeList = [];
  List<int> croppedImgAreaList = [];

  Future<void> establishConnection() async {
    await connect();
    await listenChannel();
    // connectionReady.add(true);
  }

  StreamController<bool> connectionReady = StreamController<bool>.broadcast();
  // Stream<bool> get onChange => connectionReady.stream;
  // Stream connectionReady = Stream.

  Future<void> listenChannel() async {
    // Stream broadCastStream = streamController.stream.asBroadcastStream();
    // _channel!.stream.
    // connectionReady.add(true);
    _sub = _channel!.stream.listen(
      (dynamic message) {
        connectionReady.add(true);
        // debugPrint('message in homepage : $message');
        Map<String, dynamic> dataMap = jsonDecode(jsonDecode(message));
        // debugPrint('datamap in rt provider : $dataMap');
        // debugPrint('check1');
        totalCnt = dataMap['total_cnt'];
        congestion = dataMap['congestion'] as double;
        // debugPrint('check2');
        realtimeWaitingTime = dataMap['waiting_time'];
        // debugPrint('check3');
        numberOfWaitingCars = dataMap['num_of_waiting_cars'];
        // debugPrint('check4');
        // debugPrint(
        //     'electric_charging_waiting_cnt : ${dataMap['electric_charging_waiting_cnt']}');
        electricChargingWaitingCnt =
            dataMap['electric_charging_waiting_cnt']; // <--problem
        // debugPrint('check5');
        carInteriorWashCnt = dataMap['car_interior_wash_cnt'];
        // debugPrint('check6');
        croppedData = dataMap['cropped_data'];

        // debugPrint('croppedImgString : ${croppedImgString}');
        // debugPrint('croppedImgString Type : ${croppedImgString.runtimeType}');
        // debugPrint('cropped data : ${croppedData}');
        // debugPrint('check666');
        weatherInfo = dataMap['weather_info'];
        if (croppedData != null) {
          debugPrint('cropped data not null');
          debugPrint('cropped data : ${croppedData}');
          // var areaNum = dataMap['cropped_img']['area_num'];
          // jsonData = jsonDecode(jsonDecode(croppedData!));
          jsonData = jsonDecode(croppedData!);
          debugPrint('jsonData received : ${jsonData}');
          croppedImgString = jsonData!['crop_img'];
          debugPrint('cropped img string ${croppedImgString}');
          areaNum = (jsonData!['area_num']);
          // debugPrint(
          //     'areaNum : ${areaNum} , areaNum type ${areaNum.runtimeType}');
          croppedImg = base64Decode(croppedImgString!);
          // debugPrint('cropped img : ${croppedImg}');
          croppedImgList.insert(0, croppedImg!);
          DateTime now = DateTime.now();
          String nowString = DateFormat('yy/MM/dd HH:mm:ss').format(now);
          croppedImgDateTimeList.insert(0, nowString);
          croppedImgAreaList.insert(0, areaNum!);
        } else {
          croppedImg = null;
        }

        if (croppedImgList.length > 15) {
          croppedImgList.removeLast();
          croppedImgDateTimeList.removeLast();
          croppedImgAreaList.removeLast();
        }

        flSpotsList.add(FlSpot(cnt.toDouble(), congestion));
        if (flSpotsList.length > 100) {
          flSpotsList.removeAt(0);
        }
        maxXValue = max(cnt, 5) + 1;
        // debugPrint('flspotlist ${flSpotsList}');
        cnt++;
        // debugPrint('check8');
        Map<String, dynamic> dataEvent = {
          'totalCnt': totalCnt,
          'congestion': congestion,
          'numberOfWaitingCars': numberOfWaitingCars,
          'electricChargingWaitingCnt': electricChargingWaitingCnt,
          'carInteriorWashCnt': carInteriorWashCnt,
          'flSpotsList': flSpotsList,
          'maxXValue': maxXValue,
          // 'croppedImg': croppedImg,
          'croppedImgList': croppedImgList,
          'croppedImgDateTimeList': croppedImgDateTimeList,
          'croppedImgAreaList': croppedImgAreaList,
          'weatherInfo': weatherInfo
        };
        // debugPrint('check9');
        streamController.add(dataEvent);
        // debugPrint('check10');
      },
      onDone: () async {
        debugPrint('ws channel closed');
        // streamController.close();
        if (_sub != null) {
          _sub!.cancel();
        }
        isConnected = false;
        connectionReady.add(false);
        if (!isConnected) {
          await Future.delayed(Duration(milliseconds: 500));
          await establishConnection();
        }
      },
      onError: (error) async {
        debugPrint('ws home error $error');
        // streamController.close();
        if (_sub != null) {
          _sub!.cancel();
        }
        if (!isConnected) {
          await Future.delayed(Duration(milliseconds: 500));
          await establishConnection();
        }

        connectionReady.add(false);
      },
    );
  }

  Future<void> connect() async {
    try {
      final wsUrl = Uri.parse('ws://121.169.212.87:8001/mobile/realtime');
      debugPrint('check1');
      _channel = WebSocketChannel.connect(wsUrl);
      debugPrint('check2');
      await _channel!.ready.timeout(Duration(milliseconds: 5000));
      debugPrint('check3');
      debugPrint('home stream init');
      // setState(() {
      //   _isReady = true;
      // });
      isConnected = true;
    } catch (e) {
      // try {
      //   _serverConnectTimer?.cancel();
      // } catch (e) {
      //   debugPrint('timer cancel error on try home: ${e}');
      // }
      debugPrint('error home page when connect ${e}');
      if (!isConnected) {
        await Future.delayed(Duration(milliseconds: 500));
        await establishConnection();
      }
      connectionReady.add(false);
    }

    //
    // // _channel!.sink.add('ping');
    // _channel!.stream.listen(
    //   (dynamic message) {
    //     // debugPrint('message in homepage : $message');
    //     Map<String, dynamic> dataMap = jsonDecode(jsonDecode(message));
    //     debugPrint('datamap : $dataMap');
    //     // debugPrint('check1');
    //     totalCnt = dataMap['total_cnt'];
    //     congestion = dataMap['congestion'] as double;
    //     // debugPrint('check2');
    //     realtimeWaitingTime = dataMap['waiting_time'];
    //     // debugPrint('check3');
    //     numberOfWaitingCars = dataMap['num_of_waiting_cars'];
    //     // debugPrint('check4');
    //     // debugPrint(
    //     //     'electric_charging_waiting_cnt : ${dataMap['electric_charging_waiting_cnt']}');
    //     electricChargingWaitingCnt =
    //         dataMap['electric_charging_waiting_cnt']; // <--problem
    //     // debugPrint('check5');
    //     carInteriorWashCnt = dataMap['car_interior_wash_cnt'];
    //     // debugPrint('check6');
    //
    //     // setState(() {
    //     //   flSpotsList.add(FlSpot(cnt.toDouble(), congestion));
    //     //   if (flSpotsList.length > 100) {
    //     //     flSpotsList.removeAt(0);
    //     //   }
    //     //   maxXValue = max(cnt, 5);
    //     // });
    //     // debugPrint('flspotlist ${flSpotsList}');
    //     // cnt++;
    //   },
    //   onDone: () {
    //     debugPrint('ws channel closed');
    //     // if (mounted) {
    //     //   debugPrint('mounted home page');
    //     //   setState(() {
    //     //     _isReady = false;
    //     //   });
    //     //   _serverConnectTimer = Timer.periodic(Duration(seconds: 5), (_) async {
    //     //     debugPrint('retry home connect');
    //     //     isServerConnectTimerActive = true;
    //     //     await connect();
    //     //     _serverConnectTimer.cancel();
    //     //     isServerConnectTimerActive = false;
    //     //   });
    //     // } else {
    //     //   debugPrint('unmounted home page');
    //     //   // setState(() {
    //     //   //   _isReady = false;
    //     //   // });
    //     //   // debugPrint(
    //     //   //     '_serverConnectTimer.isActive ${_serverConnectTimer.isDefinedAndNotNull}');
    //     //   try {
    //     //     _serverConnectTimer.cancel();
    //     //   } catch (e) {
    //     //     debugPrint('timer cancel error home: ${e}');
    //     //   }
    //     // }
    //   },
    //   onError: (error) {
    //     debugPrint('ws home error $error');
    //     // setState(() {
    //     //   _isReady = false;
    //     // });
    //     // try {
    //     //   _serverConnectTimer.cancel();
    //     // } catch (e) {
    //     //   debugPrint('home timer cancel error: ${e}');
    //     // }
    //   },
    // );

    // setState(() {
    //   _isReady = true;
    // });
  }
}
