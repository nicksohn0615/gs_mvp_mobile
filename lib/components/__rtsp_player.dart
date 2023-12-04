// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
//
// class RtspPlayer extends StatefulWidget {
//   final String rtspAddress;
//   const RtspPlayer({Key? key, required this.rtspAddress}) : super(key: key);
//
//   @override
//   _RtspPlayerState createState() => _RtspPlayerState();
// }
//
// class _RtspPlayerState extends State<RtspPlayer> {
//   late VlcPlayerController _videoPlayerController;
//
//   Future<void> initializePlayer() async {}
//
//   @override
//   void initState() {
//     String rtspAddress = widget.rtspAddress;
//     super.initState();
//     // "rtsp://admin:User1357@175.198.165.148:8523/live/main1",
//     _videoPlayerController = VlcPlayerController.network(
//       rtspAddress,
//       hwAcc: HwAcc.auto,
//       autoInitialize: true,
//       autoPlay: true,
//       options: VlcPlayerOptions(
//         advanced: VlcAdvancedOptions([
//           VlcAdvancedOptions.clockJitter(500),
//           VlcAdvancedOptions.clockSynchronization(1),
//           VlcAdvancedOptions.fileCaching(500),
//           VlcAdvancedOptions.liveCaching(500),
//           VlcAdvancedOptions.networkCaching(500),
//         ]),
//         rtp: VlcRtpOptions([
//           VlcRtpOptions.rtpOverRtsp(true),
//         ]),
//         sout: VlcStreamOutputOptions([
//           VlcStreamOutputOptions.soutMuxCaching(300),
//         ]),
//         video: VlcVideoOptions([
//           VlcVideoOptions.dropLateFrames(true),
//           VlcVideoOptions.skipFrames(true),
//         ]),
//       ),
//     )..initialize();
//     // _videoPlayerController.addOnInitListener(() {});
//     // _videoPlayerController.initialize();
//   }
//
//   Future<bool?> getPosFunction() async {
//     if (mounted) {
//       // debugPrint('check checkin!');
//       Duration? getPos = null;
//       // Duration getPos = await _videoPlayerController.getPosition();
//       // await Future.delayed(const Duration(milliseconds: 50), () async {});
//       // debugPrint('video controller = ${_videoPlayerController.}');
//       try {
//         getPos = await _videoPlayerController.getPosition();
//       } catch (e) {
//         debugPrint('try catch 1 error : $e');
//         await Future.delayed(const Duration(milliseconds: 500), () async {});
//         return getPosFunction();
//       }
//       // debugPrint('get Pos = ${getPos}');
//       // debugPrint('get Pos type = ${getPos.runtimeType}');
//       // debugPrint('is zero duration? = ${getPos == Duration.zero}');
//       // while (getPos == null) {
//       //   debugPrint('getposdur check!!');
//       //   await Future.delayed(const Duration(milliseconds: 50), () async {
//       //     getPos = await _videoPlayerController.getPosition();
//       //   });
//       // }
//       await Future.delayed(const Duration(milliseconds: 100), () async {});
//       // debugPrint(
//       //     'Video Scale :   ${await _videoPlayerController.getVideoScale()}');
//       try {
//         if (getPos != null && getPos != Duration.zero) {
//           debugPrint('try ok, not null ok');
//           await _videoPlayerController.setVideoScale(0.0);
//           // _videoPlayerController
//           // debugPrint(
//           //     'Video Scale :   ${await _videoPlayerController.getVideoScale()}');
//           return true;
//         } else {
//           debugPrint('try ok, but null');
//           return getPosFunction();
//         }
//       } catch (e) {
//         debugPrint('error ; $e');
//         return getPosFunction();
//       }
//     } else {
//       debugPrint('video contruller not mounted!!');
//       return null;
//     }
//   }
//
//   // Future<bool> checkFullyLoaded() async {
//   //   bool result = false;
//   //   // if _videoPlayerController.is
//   //   try {
//   //     Duration checkPos = await _videoPlayerController.getPosition();
//   //     // result = true;
//   //
//   //     if (checkPos != null) {
//   //       debugPrint('try ok, not null');
//   //       // debugPrint('get position ${checkPos}');
//   //       result = true;
//   //     } else {
//   //       debugPrint('try ok, null');
//   //     }
//   //   } catch (e) {
//   //     debugPrint('try fail, catch');
//   //     // debugPrint('check pos null');
//   //     // debugPrint('exception ${e}');
//   //   }
//   //   return result;
//   // }
//
//   @override
//   void dispose() async {
//     super.dispose();
//     await _videoPlayerController.stopRendererScanning();
//     await _videoPlayerController.dispose();
//   }
//
//   // StreamController<bool> _checkLoadedStreamContoller = checkFullyLoaded();
//   final _spinIndicator = SpinKitFadingCube(
//     duration: Duration(milliseconds: 800),
//     itemBuilder: (BuildContext context, int index) {
//       return DecoratedBox(
//         decoration: BoxDecoration(
//           color: index.isEven ? Colors.white60 : Colors.lightBlueAccent,
//         ),
//       );
//     },
//     // color: Colors.white,
//     size: 25,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     // bool isLoaded = checkFullyLoaded();
//     // debugPrint('${isLoaded}');
//     // debugPrint('hello');
//     return Center(
//       child: Container(
//         decoration: BoxDecoration(
//             color: Colors.transparent,
//             border: Border.all(
//               color: Colors.black26,
//               width: 2,
//             )),
//         padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5 * (9 / 16)),
//         child: Stack(
//           children: [
//             Container(color: Colors.black12),
//             MyVlcPlayer(videoPlayerController: _videoPlayerController),
//             Opacity(
//               opacity: 0.7,
//               child: FutureBuilder(
//                   // future: checkFullyLoaded(),
//                   future: getPosFunction(),
//                   builder: (BuildContext context, AsyncSnapshot snapshot) {
//                     // debugPrint('snapshot data:  ${snapshot.data}');
//                     // debugPrint(
//                     //     'snapshot connection state:  ${snapshot.connectionState}');
//                     if (snapshot.data == null) {
//                       debugPrint('snapshot.data1 : ${snapshot.data}');
//                       return Center(
//                           child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _spinIndicator,
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Center(
//                               child: Text(
//                             'Loading...',
//                             style: TextStyle(
//                                 color: Colors.black54,
//                                 fontWeight: FontWeight.bold),
//                           )),
//                         ],
//                       )
//                           // CircularProgressIndicator(
//                           //   color: Colors.blue,
//                           // ),
//                           );
//                     }
//                     // else if (snapshot.data == false) {
//                     //   debugPrint('snapshot.data2 : ${snapshot.data}');
//                     //   return Stack(
//                     //     children: [
//                     //       Center(
//                     //         child: Container(color: Colors.grey),
//                     //       ),
//                     //       Center(
//                     //         child: CircularProgressIndicator(
//                     //           color: Colors.blue,
//                     //         ),
//                     //       ),
//                     //       myVlcPlayer(videoPlayerController: _videoPlayerController)
//                     //     ],
//                     //   );
//                     // } else if (snapshot.data == true) {
//                     //   debugPrint('snapshot.data3 : ${snapshot.data}');
//                     //   return myVlcPlayer(videoPlayerController: _videoPlayerController);
//                     // }
//                     else {
//                       debugPrint('video fully loaded!!');
//                       debugPrint('snapshot.data4 : ${snapshot.data}');
//                       return SizedBox();
//                     }
//                   }),
//             )
//           ],
//         ),
//       ),
//
//       // Stack(
//       //   children: [
//       //     Visibility(
//       //       child: myVlcPlayer(videoPlayerController: _videoPlayerController),
//       //       // visible: checkFullyLoaded() ? true : false,
//       //     ),
//       //     Visibility(
//       //       child: CircularProgressIndicator(),
//       //       visible: checkFullyLoaded() ? false : true,
//       //     )
//       // TextButton(
//       //     onPressed: () async {
//       //       // debugPrint(
//       //       //     'is ready to init ${await _videoPlayerController.isReadyToInitialize}');
//       //       // debugPrint(
//       //       //     'is playing? ${await _videoPlayerController.isPlaying()}');
//       //       // debugPrint(
//       //       //     'is seekable? ${await _videoPlayerController.isSeekable()}');
//       //       // debugPrint(
//       //       //     'get time? ${await _videoPlayerController.}');
//       //       // debugPrint(
//       //       //     'get time? ${await _videoPlayerController.getTime()}');
//       //       // try {
//       //       //   Duration checkPos =
//       //       //       await _videoPlayerController.getPosition();
//       //       //   if (checkPos != null) {
//       //       //     debugPrint('get position ${checkPos}');
//       //       //   }
//       //       // } catch (e) {
//       //       //   debugPrint('check pos null');
//       //       //   debugPrint('exception ${e}');
//       //       // }
//       //
//       //       // debugPrint(
//       //       //     'get duration ${await _videoPlayerController.getDuration()}');
//       //     },
//       //     child: Text('check playing'))
//       // ],
//       // ),
//     );
//   }
// }
//
// class MyVlcPlayer extends StatefulWidget {
//   const MyVlcPlayer({
//     super.key,
//     required VlcPlayerController videoPlayerController,
//   }) : _videoPlayerController = videoPlayerController;
//
//   final VlcPlayerController _videoPlayerController;
//
//   @override
//   State<MyVlcPlayer> createState() => _MyVlcPlayerState();
// }
//
// class _MyVlcPlayerState extends State<MyVlcPlayer> {
//   @override
//   Widget build(BuildContext context) {
//     return VlcPlayer(
//       controller: widget._videoPlayerController,
//       aspectRatio: 16 / 9,
//       placeholder: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
//
// // import 'package:flutter/material.dart';
// // import 'package:media_kit/media_kit.dart';
// // import 'package:media_kit_video/media_kit_video.dart';
// //
// // class MyScreen extends StatefulWidget {
// //   const MyScreen({Key? key}) : super(key: key);
// //   @override
// //   State<MyScreen> createState() => MyScreenState();
// // }
// //
// // class MyScreenState extends State<MyScreen> {
// //   // Create a [Player] to control playback.
// //   late final player = Player();
// //   // Create a [VideoController] to handle video output from [Player].
// //   late final controller = VideoController(player);
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Play a [Media] or [Playlist].
// //     player.open(Media('rtsp://admin:User1357@175.198.165.148:8521/live/main1'));
// //   }
// //
// //   @override
// //   void dispose() {
// //     player.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: SizedBox(
// //         width: MediaQuery.of(context).size.width,
// //         height: MediaQuery.of(context).size.width * 9.0 / 16.0,
// //         // Use [Video] widget to display video output.
// //         child: Video(controller: controller),
// //       ),
// //     );
// //   }
// // }
