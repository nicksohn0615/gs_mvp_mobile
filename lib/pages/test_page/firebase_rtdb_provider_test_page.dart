// import 'package:flutter/material.dart';
// import 'package:gs_mvp/providers/realtime_database_provider.dart';
//
// class RTDBTest extends StatefulWidget {
//   const RTDBTest({super.key});
//
//   @override
//   State<RTDBTest> createState() => _RTDBTestState();
// }
//
// class _RTDBTestState extends State<RTDBTest> {
//   // final FirebaseDatabase rtdb = FirebaseDatabase.instance;
//   final _rtdbProvider = RealtimeDataBaseProviders();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Widget textWidgetWithData(
//       double congetstion, int realtimeWaitingTime, int numberOfWaitingCars) {
//     return Text(
//         '${congetstion}, ${realtimeWaitingTime}, ${numberOfWaitingCars}');
//   }
//
//   StreamBuilder myStreamBuilder() {
//     return StreamBuilder(
//         stream: _rtdbProvider.rtdb.ref("bcokgil").onValue,
//         builder: (BuildContext context, snshot) {
//           debugPrint('snapshot: ${snshot}');
//           if (!snshot.hasData) {
//             debugPrint("Waiting");
//             return const CircularProgressIndicator(color: Colors.white);
//           } else if (snshot.hasError) {
//             debugPrint("Error occured...");
//             return const CircularProgressIndicator(color: Colors.white);
//           } else {
//             Map data = snshot.data!.snapshot.value;
//             debugPrint('${data['realtimeWaitingTime'].runtimeType}');
//             return textWidgetWithData(data['congestion'],
//                 data['realtimeWaitingTime'], data['numberOfWaitingCars']);
//           }
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(
//               onPressed: () async {
//                 Map result = await _rtdbProvider.getBcokgil();
//                 debugPrint('result ${result}');
//                 // // debugPrint('check');
//                 // var getdb = await rtdb.ref("bcokgil").get();
//                 // // Map<dynamic, dynamic> _value =
//                 // //     getdb.value as Map<dynamic, dynamic>;
//                 // debugPrint('getdb = ${getdb.value}');
//               },
//               icon: Icon(Icons.add_alert_outlined)),
//           StreamBuilder(
//               stream: _rtdbProvider.rtdb.ref("bcokgil").onValue,
//               builder: (BuildContext context, snshot) {
//                 debugPrint('snapshot: ${snshot}');
//                 if (!snshot.hasData) {
//                   debugPrint("Waiting");
//                   return const CircularProgressIndicator(color: Colors.white);
//                 } else if (snshot.hasError) {
//                   debugPrint("Error occured...");
//                   return const CircularProgressIndicator(color: Colors.white);
//                 } else {
//                   return Text('${snshot.data!.snapshot.value}');
//                 }
//               }),
//           myStreamBuilder()
//         ],
//       )),
//     );
//   }
// }
