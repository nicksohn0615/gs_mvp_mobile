import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
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
  }

  Uint8List? croppedImg;
  String? croppedImgString;

  Future<void> listenChannel() async {
    // Stream broadCastStream = streamController.stream.asBroadcastStream();
    _sub = _channel!.stream.listen(
      (dynamic message) {
        // debugPrint('message in homepage : $message');
        Map<String, dynamic> dataMap = jsonDecode(jsonDecode(message));
        debugPrint('datamap in provider : $dataMap');
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
        croppedImgString = dataMap['cropped_img'];
        if (croppedImgString != null && croppedImgString != 'null') {
          croppedImg = base64Decode(croppedImgString!);
          // debugPrint('cropped img : ${croppedImg}');
        } else {
          croppedImg = null;
        }

        flSpotsList.add(FlSpot(cnt.toDouble(), congestion));
        if (flSpotsList.length > 100) {
          flSpotsList.removeAt(0);
        }
        maxXValue = max(cnt, 5);

        // debugPrint('flspotlist ${flSpotsList}');
        cnt++;
        Map<String, dynamic> dataEvent = {
          'totalCnt': totalCnt,
          'congestion': congestion,
          'numberOfWaitingCars': numberOfWaitingCars,
          'electricChargingWaitingCnt': electricChargingWaitingCnt,
          'carInteriorWashCnt': carInteriorWashCnt,
          'flSpotsList': flSpotsList,
          'maxXValue': maxXValue,
          'croppedImg': croppedImg,
        };
        streamController.add(dataEvent);
      },
      onDone: () {
        debugPrint('ws channel closed');
        streamController.close();
        if (_sub != null) {
          _sub!.cancel();
        }
      },
      onError: (error) {
        debugPrint('ws home error $error');
        streamController.close();
        if (_sub != null) {
          _sub!.cancel();
        }
      },
    );
  }

  Future<void> connect() async {
    try {
      final wsUrl = Uri.parse('ws://121.169.212.87:8001/mobile/realtime');
      debugPrint('check1');
      _channel = WebSocketChannel.connect(wsUrl);
      debugPrint('check2');
      await _channel!.ready;
      debugPrint('check3');
      debugPrint('home stream init');
      // setState(() {
      //   _isReady = true;
      // });
      isConnected = true;
    } catch (e) {
      try {
        _serverConnectTimer?.cancel();
      } catch (e) {
        debugPrint('timer cancel error on try home: ${e}');
      }
      debugPrint('error home page when connect ${e}');
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
