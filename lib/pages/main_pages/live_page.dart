import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  bool cctvShowing = true;

  List<String> _dropdownValues = ['CCTV', 'BluePrint'];
  String _selectedValue = 'CCTV';

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
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8.0)),
                width: 200,
                height: 40,
                // color: Colors.blue,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 14.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      // focusColor: Colors.red,
                      style: TextStyle(color: Colors.white70),
                      dropdownColor: Colors.black54,
                      value: _selectedValue,
                      items: _dropdownValues.map((value) {
                        return DropdownMenuItem(
                            value: value, child: Text('${value}'));
                      }).toList(),
                      onChanged: (value) {
                        if (value == 'CCTV') {
                          {
                            setState(() {
                              cctvShowing = true;
                            });
                          }
                        } else {
                          setState(() {
                            cctvShowing = false;
                          });
                        }
                        setState(() {
                          _selectedValue = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
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
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
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
                              Text('Loading...')
                            ],
                          )),
                        );
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

                      return cctvShowing
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                getLivePlayFrame(images.$1, 'Area 1')
                                // Padding(
                                //   padding: const EdgeInsets.all(16.0),
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //         border: Border.all(
                                //             color: Colors.black38, width: 4.0),
                                //         borderRadius:
                                //             BorderRadius.all(Radius.circular(18.0))),
                                //     child: ClipRRect(
                                //       borderRadius:
                                //           BorderRadius.all(Radius.circular(14.0)),
                                //       child: Image.memory(
                                //         images.$1,
                                //         gaplessPlayback: true,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                ,
                                SizedBox(
                                  height: 10,
                                ),
                                getLivePlayFrame(images.$2, 'Area 3'),
                                // Padding(
                                //   padding: const EdgeInsets.all(16.0),
                                //   child: Image.memory(
                                //     images.$2,
                                //     gaplessPlayback: true,
                                //   ),
                                // ),
                                SizedBox(
                                  height: 10,
                                ),
                                getLivePlayFrame(images.$3, 'Area 4'),
                                // Padding(
                                //   padding: const EdgeInsets.all(16.0),
                                //   child: Image.memory(
                                //     images.$3,
                                //     gaplessPlayback: true,
                                //   ),
                                // ),
                                SizedBox(
                                  height: 10,
                                ),
                                // getLivePlayFrame(images.$4, 'BluePrint'),
                                // Padding(
                                //   padding: const EdgeInsets.all(16.0),
                                //   child: Image.memory(
                                //     images.$4,
                                //     gaplessPlayback: true,
                                //   ),
                                // ),
                              ],
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                getLivePlayFrame(images.$4, 'BluePrint'),
                              ],
                            );
                      // _isImgReady ? Image.memory(_imgPlaceHolder) : Text('data'),
                      // else {
                      //  return const Center(
                      //    child: Text("ping!"),
                      //  );
                    })
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
                      Text('Loading...')
                    ],
                  ))
          ]),
    ));
  }
}

Padding getLivePlayFrame(Uint8List img, String title) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        Row(children: [
          SizedBox(
            width: 20,
          ),
          Container(
              decoration: BoxDecoration(
                  color: Colors.black54,
                  border: Border.all(width: 1.0, color: Colors.transparent),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              // color: Colors.black54,
              child: Text(
                '  $title  ',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ))
        ]),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 8.0),
              borderRadius: BorderRadius.all(Radius.circular(18.0))),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Image.memory(
              img,
              gaplessPlayback: true,
            ),
          ),
        ),
      ],
    ),
  );
}

class LivePlayFrame extends Padding {
  LivePlayFrame({super.key, required super.padding, required this.img}) {}

  Uint8List img;

  // Padding(
  // padding: const EdgeInsets.all(16.0),
  // child: Container(
  // decoration: BoxDecoration(
  // border: Border.all(
  // color: Colors.black38, width: 4.0),
  // borderRadius:
  // BorderRadius.all(Radius.circular(18.0))),
  // child: ClipRRect(
  // borderRadius:
  // BorderRadius.all(Radius.circular(14.0)),
  // child: Image.memory(
  // images.$1,
  // gaplessPlayback: true,
  // ),
  // ),
  // ),
  // ),
}
