// import 'dart:convert';
//
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
//
// class RealtimeDataBaseProviders {
//   final FirebaseDatabase rtdb = FirebaseDatabase.instance;
//
//   Future<Map> getBcokgil() async {
//     DataSnapshot snapshot = await rtdb.ref("bcokgil").get();
//     debugPrint('${snapshot.value}');
//     debugPrint('${(snapshot.value).runtimeType}');
//
//     // Map<dynamic, dynamic> _value = snapshot.value as Map<dynamic, dynamic>;
//     Map<String, dynamic> _value = jsonDecode(jsonEncode(snapshot.value));
//     debugPrint('${_value.runtimeType}');
//     return _value;
//   }
//   // Stream streamBcokgil = rtdb.ref()
//
//   // Stream streamBcokgil() async* {
//   //   Stream<DatabaseEvent> _stream = rtdb.ref("bcokgil").onValue;
//   //   _stream.listen((event) {
//   //     var streamResult = event.snapshot.value;
//   //     debugPrint('stream result in stream fn = ${streamResult}');
//   //   });
//   //
//   //   // debugPrint('Stream : ${stream}');
//   //   // Map<String, dynamic> _value = jsonDecode(jsonEncode(stream));
//   //   yield _stream;
//   // }
// }
