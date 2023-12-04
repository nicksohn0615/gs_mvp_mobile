// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gs_mvp/components/rtsp_player.dart';
// // import 'package:gs_mvp/components/rtsp_player.dart';
// import '../login_page.dart';
//
// // to do : side_navigation, indexed stack widget 도입.
//
// class CamViewer extends StatefulWidget {
//   CamViewer({Key? key}) : super(key: key);
//
//   @override
//   State<CamViewer> createState() => _CamViewerState();
// }
//
// class _CamViewerState extends State<CamViewer> {
//   String? selectedValue;
//
//   final List<String> items = List<String>.generate(10, (index) => '$index');
//
//   Widget _buildDropDownButton() {
//     return DropdownButtonHideUnderline(
//       child: DropdownButton2<String>(
//         isExpanded: true,
//         hint: Row(
//           children: [
//             Icon(
//               Icons.list,
//               size: 20,
//               color: Colors.white60,
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Expanded(
//               child: Text(
//                 'CCTV 번호를 선택하세요',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white54,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//         items: items
//             .map((String item) => DropdownMenuItem<String>(
//                   value: item,
//                   child: Text(
//                     item,
//                     style: const TextStyle(fontSize: 18, color: Colors.white70),
//                   ),
//                 ))
//             .toList(),
//         value: selectedValue,
//         onChanged: (String? value) {
//           setState(() {
//             selectedValue = value;
//           });
//         },
//         buttonStyleData: ButtonStyleData(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           height: 50,
//           width: 140,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: Colors.white12,
//             ),
//             color: Colors.transparent,
//           ),
//           elevation: 2,
//         ),
//         dropdownStyleData: DropdownStyleData(
//           maxHeight: 200,
//           width: 200,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             color: Colors.black54,
//           ),
//           offset: const Offset(0, 0),
//           scrollbarTheme: ScrollbarThemeData(
//             radius: const Radius.circular(8),
//             thickness: MaterialStateProperty.all(6),
//             thumbVisibility: MaterialStateProperty.all(true),
//           ),
//         ),
//         menuItemStyleData: const MenuItemStyleData(
//             height: 30, padding: EdgeInsets.only(left: 14, right: 14)),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//       child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text('Welcome to CamViewer Page'),
//             _buildDropDownButton(),
//             // Center(
//             //   child: Container(
//             //     color: Colors.grey,
//             //     width: 200 * (16 / 9),
//             //     height: 200 + 73,
//             //   ),
//             // ),
//             Center(
//               child: SizedBox(
//                   width: 200 * (16 / 9),
//                   height: 200,
//                   child: RtspPlayer(
//                     rtspAddress:
//                         "rtsp://admin:User1357@175.198.165.148:8523/live/main0",
//                   )),
//             ),
//
//             // Center(
//             //   child: SizedBox(
//             //       width: 200 * (16 / 9),
//             //       height: 200,
//             //       child: RtspPlayer(
//             //         rtspAddress:
//             //             "rtsp://admin:User1357@175.198.165.148:8523/live/main1",
//             //       )),
//             // ),
//
//             // SizedBox(
//             //     width: 400,
//             //     height: 200,
//             //     child: RtspPlayer(
//             //       rtspAddress:
//             //           "rtsp://admin:User1357@175.198.165.148:8523/live/main1",
//             //     )),
//             TextButton(
//                 onPressed: () {
//                   Get.to(() => LoginPage());
//                 },
//                 child: Text('Go to LoginPage')),
//             SizedBox(
//               height: 80,
//             )
//           ]),
//     ));
//   }
// }
