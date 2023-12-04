import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// to do : side_navigation, indexed stack widget 도입.

class CamViewer extends StatefulWidget {
  CamViewer({Key? key}) : super(key: key);

  @override
  State<CamViewer> createState() => _CamViewerState();
}

class _CamViewerState extends State<CamViewer> {
  WebSocketChannel? _channel1;
  bool _isReady = false;

  Future<void> connect() async {
    final wsUrl1 = Uri.parse('ws://121.169.212.87:8001/ws/frames_provider');

    _channel1 = WebSocketChannel.connect(wsUrl1);

    debugPrint('check1');
    await _channel1!.ready;

    debugPrint('stream init');
    setState(() {
      _isReady = true;
    });
    // channelCol!.sink.add('ping');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await connect();
    });
  }

  @override
  void dispose() {
    _channel1!.sink.close();
    super.dispose();
  }

  (Uint8List, Uint8List, Uint8List, Uint8List) getImage(String message) {
    Map<String, dynamic> dataMap = jsonDecode(jsonDecode(message));
    // Map<String, dynamic> dataMap = jsonDecode(message);
    // debugPrint('data Map : ${dataMap}');
    Uint8List imgArr1 = base64Decode(dataMap['frame1']);
    Uint8List imgArr2 = base64Decode(dataMap['frame2']);
    Uint8List imgArr3 = base64Decode(dataMap['frame3']);
    Uint8List imgArr4 = base64Decode(dataMap['frame_bp']);
    // debugPrint('img arr : ${imgArr}');
    return (imgArr1, imgArr2, imgArr3, imgArr4);
  }

  // late Uint8List thisImg;
  late (Uint8List, Uint8List, Uint8List, Uint8List) images;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text('Live Page'),
            _isReady
                ? StreamBuilder(
                    stream: _channel1!.stream,
                    builder: (context, snapshot) {
                      // debugPrint('snapshot : ${snapshot}');
                      // debugPrint('snapshot data: ${snapshot.data}');
                      // debugPrint(
                      //     'snapshot data type: ${snapshot.data.runtimeType}');
                      // debugPrint('snapshot type: ${snapshot.runtimeType}');

                      if (!snapshot.hasData) {
                        debugPrint('stream has no data');
                        return Center(child: const CircularProgressIndicator());
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        _channel1!.sink.close();
                        debugPrint('connection closed');
                        return const Center(
                          child: Text("Connection Closed !"),
                        );
                      }
                      // thisImg =
                      images = getImage(snapshot.data);

                      return Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.memory(
                              images.$1,
                              gaplessPlayback: true,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.memory(
                              images.$2,
                              gaplessPlayback: true,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.memory(
                              images.$3,
                              gaplessPlayback: true,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.memory(
                              images.$4,
                              gaplessPlayback: true,
                            ),
                          ),
                        ],
                      );
                      // _isImgReady ? Image.memory(_imgPlaceHolder) : Text('data'),
                      // else {
                      //  return const Center(
                      //    child: Text("ping!"),
                      //  );
                    })
                : Center(child: CircularProgressIndicator())
          ]),
    ));
  }
}
