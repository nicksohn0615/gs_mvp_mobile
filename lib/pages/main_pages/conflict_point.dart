import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConflictPointPage extends StatefulWidget {
  ConflictPointPage({Key? key}) : super(key: key);

  @override
  State<ConflictPointPage> createState() => _ConflictPointPageState();
}

enum CollisionPageState { none, collision, rtCollision, stayTime }

class _ConflictPointPageState extends State<ConflictPointPage> {
  WebSocketChannel? channelCol;

  WebSocketChannel? channelSt;

  bool _isReady = false;
  bool _colImgLoadedOnce = false;
  bool _stImgLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      debugPrint('ts : ${timeStamp}');
      await connect();
    });
    debugPrint('initState complete');
  }

  @override
  void dispose() {
    channelCol!.sink.close();
    channelSt!.sink.close();
    debugPrint('disposed!');
    super.dispose();
  }

  late Uint8List prevColImg;
  late Uint8List thisColImg;
  late Uint8List prevStImg;
  late Uint8List thisStImg;

  Uint8List getImage(String message) {
    Map<String, dynamic> dataMap = jsonDecode(jsonDecode(message));
    debugPrint('frame cnt : ${dataMap['frameCnt']}');
    Uint8List imgArr = base64Decode(dataMap['image']);
    return imgArr;
  }

  // late StreamSubscription _subSt;
  // late StreamSubscription _subCol;

  Future<void> connect() async {
    // final wsUrl = Uri.parse('ws://10.0.2.2:8000/ws');
    // final wsUrlSt = Uri.parse('ws://14.36.1.6:8000/ws/bp-st');
    final wsUrlSt = Uri.parse('ws://121.169.212.87:8001/ws/bp-st');
    // final wsUrlCol = Uri.parse('ws://14.36.1.6:8000/ws/bp-col');
    final wsUrlCol = Uri.parse('ws://121.169.212.87:8001/ws/bp-col');

    channelSt = WebSocketChannel.connect(wsUrlSt);

    debugPrint('check1');
    channelCol = WebSocketChannel.connect(wsUrlCol);
    debugPrint('check2');
    await channelCol!.ready;
    debugPrint('check3');
    await channelSt!.ready;
    debugPrint('check4');
    // channel!.
    // channel!.sink.add('ping');
    debugPrint('stream init');
    setState(() {
      _isReady = true;
    });
    channelCol!.sink.add('ping');
    channelSt!.sink.add('ping');

    // _subSt = channelSt!.stream.listen((event) {
    //   debugPrint('st event : ${event}');
    //
    // });
    // _subCol = channelCol!.stream.listen((event) {
    //   debugPrint('col event : ${event}');
    // });
  }

  double stOpacity = 0.0;
  double colOpacity = 0.0;
  void setPageStateNone() {
    setState(() {
      stOpacity = 0.0;
      colOpacity = 0.0;
      tileColorReset();
      noneTileBorderColor = Colors.grey;
    });
  }

  void setPageStateCol() {
    setState(() {
      stOpacity = 0.0;
      colOpacity = 0.5;
      tileColorReset();
      colTileBorderColor = Colors.grey;
    });
  }

  void setPageStateSt() {
    setState(() {
      stOpacity = 0.5;
      colOpacity = 0.0;
      tileColorReset();
      stTileBorderColor = Colors.grey;
    });
  }

  CollisionPageState? _pageState = CollisionPageState.none;

  Color noneTileBorderColor = Colors.grey;
  Color colTileBorderColor = Colors.transparent;
  Color rtColTileBorderColor = Colors.transparent;
  Color stTileBorderColor = Colors.transparent;

  void tileColorReset() {
    setState(() {
      noneTileBorderColor = Colors.transparent;
      colTileBorderColor = Colors.transparent;
      rtColTileBorderColor = Colors.transparent;
      stTileBorderColor = Colors.transparent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ElevatedButton(
          //   onPressed: () {
          //     setPageStateNone();
          //   },
          //   child: const Text("None"),
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     setPageStateCol();
          //   },
          //   child: const Text("Collision"),
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     setPageStateSt();
          //   },
          //   child: const Text("StayTime"),
          // ),
          Stack(
            children: [
              // Image.asset('assets/images/okgil_domyun.png'), // 1258 x 979 no
              Image.asset('assets/images/blueprint.png'), // 1258 x 979

              SizedBox(
                // width: 300,
                // height: 300,
                child: _isReady
                    ? Stack(
                        children: [
                          Opacity(
                            opacity: stOpacity,
                            child: StreamBuilder(
                                stream: channelSt!.stream,
                                builder: (context, snapshot) {
                                  // debugPrint('snapshot : ${snapshot}');
                                  // debugPrint('snapshot data: ${snapshot.data}');
                                  // debugPrint(
                                  //     'snapshot data type: ${snapshot.data.runtimeType}');
                                  // debugPrint('snapshot type: ${snapshot.runtimeType}');
                                  // if (snapshot.data == 'pong') {
                                  //   channel!.sink.add('ping');
                                  //   // debugPrint('snapshot data: ${snapshot.data}');
                                  // }
                                  // channel!.sink.add('ping');

                                  if (!snapshot.hasData) {
                                    debugPrint('stream has no data');
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    channelSt!.sink.close();
                                    debugPrint('connection closed');
                                    return const Center(
                                      child: Text("Connection Closed !"),
                                    );
                                  }
                                  //? Working for single frames
                                  // else if (snapshot.data != 'pong') {
                                  //   debugPrint('something coming in streambuilder- ');
                                  //   channel!.sink.add('ping');
                                  // if (!isLoadedImgOnce) {
                                  //   debugPrint('$isLoadedImgOnce');
                                  //   return const CircularProgressIndicator();
                                  // }
                                  // if (snapshot.data == 'pong' && isLoadedImgOnce) {
                                  //   return Image.memory(prevImage);
                                  // }
                                  //

                                  // channelSt!.sink.add('ping');

                                  // channelCol!.sink.add('ping');
                                  if (snapshot.data == 'pong' &&
                                      _stImgLoadedOnce) {
                                    debugPrint('pong received, st');
                                    thisStImg = prevStImg;
                                  } else if (snapshot.data == 'pong' &&
                                      !_stImgLoadedOnce) {
                                    return Text('waiting');
                                  } else {
                                    thisStImg = getImage(snapshot.data);
                                  }
                                  prevStImg = thisStImg;

                                  if (snapshot.data != 'pong') {
                                    _stImgLoadedOnce = true;
                                  }

                                  return Image.memory(
                                    thisStImg,
                                    // getImage(snapshot.data),
                                    // Uint8List.fromList(
                                    //   base64Decode(
                                    //     (snapshot.data.toString()),
                                    //   ),
                                    // ),
                                    gaplessPlayback: true,
                                  );
                                  // _isImgReady ? Image.memory(_imgPlaceHolder) : Text('data'),
                                  // else {
                                  //  return const Center(
                                  //    child: Text("ping!"),
                                  //  );
                                }),
                          ),
                          Opacity(
                            opacity: colOpacity,
                            child: StreamBuilder(
                                stream: channelCol!.stream,
                                builder: (context, snapshot) {
                                  // debugPrint('snapshot : ${snapshot}');
                                  // debugPrint('snapshot data: ${snapshot.data}');
                                  // debugPrint(
                                  //     'snapshot data type: ${snapshot.data.runtimeType}');
                                  // debugPrint(
                                  //     'snapshot type: ${snapshot.runtimeType}');
                                  // if (snapshot.data == 'pong') {
                                  //   channel!.sink.add('ping');
                                  //   // debugPrint('snapshot data: ${snapshot.data}');
                                  // }
                                  // channel!.sink.add('ping');

                                  if (!snapshot.hasData) {
                                    debugPrint('stream has no data');
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    channelCol!.sink.close();
                                    debugPrint('connection closed');
                                    return const Center(
                                      child: Text("Connection Closed !"),
                                    );
                                  }
                                  //? Working for single frames
                                  // else if (snapshot.data != 'pong') {
                                  //   debugPrint('something coming in streambuilder- ');
                                  //   channel!.sink.add('ping');
                                  // if (!isLoadedImgOnce) {
                                  //   debugPrint('$isLoadedImgOnce');
                                  //   return const CircularProgressIndicator();
                                  // }
                                  // if (snapshot.data == 'pong' && isLoadedImgOnce) {
                                  //   return Image.memory(prevImage);
                                  // }

                                  // channelCol!.sink.add('ping');
                                  if (snapshot.data == 'pong' &&
                                      _colImgLoadedOnce) {
                                    debugPrint('pong received, col');
                                    thisColImg = prevColImg;
                                  } else if (snapshot.data == 'pong' &&
                                      !_colImgLoadedOnce) {
                                    return Text('waiting');
                                  } else {
                                    _colImgLoadedOnce = true;
                                    thisColImg = getImage(snapshot.data);
                                  }
                                  prevColImg = thisColImg;
                                  return Image.memory(
                                    thisColImg,
                                    // getImage(snapshot.data),
                                    // Uint8List.fromList(
                                    //   base64Decode(
                                    //     (snapshot.data.toString()),
                                    //   ),
                                    // ),
                                    gaplessPlayback: true,
                                  );
                                  // _isImgReady ? Image.memory(_imgPlaceHolder) : Text('data'),
                                  // else {
                                  //  return const Center(
                                  //    child: Text("ping!"),
                                  //  );
                                }),
                          ),
                        ],
                      )
                    : Center(child: Text('waiting')),
              ),
            ],
          ),
          Column(
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: noneTileBorderColor, width: 3),
                    borderRadius: BorderRadius.circular(12)),
                title: const Text('None'),
                leading: Radio<CollisionPageState>(
                  value: CollisionPageState.none,
                  groupValue: _pageState,
                  onChanged: (CollisionPageState? value) {
                    setState(() {
                      _pageState = value;
                      setPageStateNone();
                    });
                  },
                ),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: colTileBorderColor, width: 3),
                    borderRadius: BorderRadius.circular(12)),
                title: const Text('Daily Collision Analysis'),
                leading: Radio<CollisionPageState>(
                  value: CollisionPageState.collision,
                  groupValue: _pageState,
                  onChanged: (CollisionPageState? value) {
                    setState(() {
                      _pageState = value;
                      setPageStateCol();
                    });
                  },
                ),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: rtColTileBorderColor, width: 3),
                    borderRadius: BorderRadius.circular(12)),
                title: const Text(
                  'Realtime Collision Analysis (To Be)',
                  style: TextStyle(color: Colors.grey),
                ),
                leading: Radio<CollisionPageState>(
                  value: CollisionPageState.rtCollision,
                  groupValue: _pageState,
                  onChanged: null,
                ),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: stTileBorderColor, width: 3),
                    borderRadius: BorderRadius.circular(12)),
                title: const Text('Daily StayTime Analysis'),
                leading: Radio<CollisionPageState>(
                  value: CollisionPageState.stayTime,
                  groupValue: _pageState,
                  onChanged: (CollisionPageState? value) {
                    setState(() {
                      _pageState = value;
                      setPageStateSt();
                    });
                  },
                ),
              ),
            ],
          )

          // Stack(
          //   children: [
          //     Image.asset('assets/images/blueprint.png'),
          //     SizedBox(
          //       // width: 300,
          //       // height: 300,
          //       child: _isReady
          //           ? Opacity(
          //               opacity: 0.5,
          //               child: StreamBuilder(
          //                   stream: channelSt!.stream,
          //                   builder: (context, snapshot) {
          //                     // debugPrint('snapshot : ${snapshot}');
          //                     // debugPrint('snapshot data: ${snapshot.data}');
          //                     // debugPrint(
          //                     //     'snapshot data type: ${snapshot.data.runtimeType}');
          //                     // debugPrint('snapshot type: ${snapshot.runtimeType}');
          //                     // if (snapshot.data == 'pong') {
          //                     //   channel!.sink.add('ping');
          //                     //   // debugPrint('snapshot data: ${snapshot.data}');
          //                     // }
          //                     // channel!.sink.add('ping');
          //
          //                     if (!snapshot.hasData) {
          //                       debugPrint('stream has no data');
          //                       return const CircularProgressIndicator();
          //                     } else if (snapshot.connectionState ==
          //                         ConnectionState.done) {
          //                       channelSt!.sink.close();
          //                       debugPrint('connection closed');
          //                       return const Center(
          //                         child: Text("Connection Closed !"),
          //                       );
          //                     }
          //                     //? Working for single frames
          //                     // else if (snapshot.data != 'pong') {
          //                     //   debugPrint('something coming in streambuilder- ');
          //                     //   channel!.sink.add('ping');
          //                     // if (!isLoadedImgOnce) {
          //                     //   debugPrint('$isLoadedImgOnce');
          //                     //   return const CircularProgressIndicator();
          //                     // }
          //                     // if (snapshot.data == 'pong' && isLoadedImgOnce) {
          //                     //   return Image.memory(prevImage);
          //                     // }
          //                     //
          //
          //                     // channelSt!.sink.add('ping');
          //
          //                     // channelCol!.sink.add('ping');
          //                     if (snapshot.data == 'pong' && _stImgLoadedOnce) {
          //                       debugPrint('pong received, st');
          //                       thisStImg = prevStImg;
          //                     } else if (snapshot.data == 'pong' &&
          //                         !_stImgLoadedOnce) {
          //                       return Text('waiting');
          //                     } else {
          //                       thisStImg = getImage(snapshot.data);
          //                     }
          //                     prevStImg = thisStImg;
          //
          //                     if (snapshot.data != 'pong') {
          //                       _stImgLoadedOnce = true;
          //                     }
          //
          //                     return Image.memory(
          //                       thisStImg,
          //                       // getImage(snapshot.data),
          //                       // Uint8List.fromList(
          //                       //   base64Decode(
          //                       //     (snapshot.data.toString()),
          //                       //   ),
          //                       // ),
          //                       gaplessPlayback: true,
          //                     );
          //                     // _isImgReady ? Image.memory(_imgPlaceHolder) : Text('data'),
          //                     // else {
          //                     //  return const Center(
          //                     //    child: Text("ping!"),
          //                     //  );
          //                   }),
          //             )
          //           : Text('waiting'),
          //     ),
          //   ],
          // ),

          // Center(
          //     child: Stack(children: [
          //   Center(
          //     child: Opacity(
          //       opacity: 0.7,
          //       child: Image.asset('assets/images/okgil_domyun.png'),
          //     ),
          //   ),
          //   Center(
          //     child: RippleAnimation(
          //       child: SizedBox(),
          //       color: Colors.deepOrange,
          //       delay: const Duration(milliseconds: 10),
          //       repeat: true,
          //       minRadius: 50,
          //       ripplesCount: 3,
          //       duration: const Duration(milliseconds: 4 * 300),
          //     ),
          //   ),
          //   Center(
          //     child: Text(
          //       '준비중입니다.',
          //       style: TextStyle(
          //           color: Colors.black87,
          //           fontSize: 30,
          //           fontWeight: FontWeight.bold),
          //     ),
          //   )
          // ]))
        ],
      ),
    );
  }
}
