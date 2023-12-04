// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class stationNameProvider {
//   final _firestore = FirebaseFirestore.instance;
//
//   Future<Map> provideStationNames() async {
//     var result = await _firestore
//         .collection('userInfo')
//         .doc('vdNKobvbLC7X1cdL1Rlv')
//         .get();
//     // debugPrint('result = ${result.data()}');
//     Map<String, dynamic> resultMapTmp = result.data()!;
//     Map resultMap = resultMapTmp['stationNameToEmail'];
//     debugPrint('result = ${resultMap}');
//     // List keyList = resultMap.keys.toList();
//     // debugPrint('keys = ${keyList}');
//     // List valueList = resultMap.values.toList();
//     // debugPrint('values = ${valueList}');
//     return resultMap;
//   }
// }
