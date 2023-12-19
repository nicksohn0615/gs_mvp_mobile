import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gs_mvp/modal/bottom_sheet.dart';
import 'package:gs_mvp/modal/snackbars.dart';
import 'package:gs_mvp/pages/main_page.dart';
import 'package:http/http.dart' as http;

import '../modal/dialogs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final url = Uri.parse('https://reqbin.com/sample/post/json');
  final baseUrl = Uri.parse('http://121.169.212.87:8001/mobile');
  // final baseUrl = Uri.http('121.169.212.87:8001/', 'mobile/');
  bool isConnected = false;
  var stationNamesMap;
  // Authentication authInstance = Authentication();
  BottomSheets bottomSheetsInstance = BottomSheets();
  CustomSnackBars snackbarInstance = CustomSnackBars();

  late Timer _timer;

  Future<void> initialLoad() async {
    try {
      debugPrint('connection retry');
      var response =
          await http.get(baseUrl).timeout(Duration(milliseconds: 5000));
      // debugPrint('response code : ${response.statusCode}');
      // debugPrint('response body : ${response.body}');
      // debugPrint(
      //     'response body utf8 decoded: ${utf8.decode(response.bodyBytes)}');
      // // debugPrint('response body type: ${response.body.runtimeType}');
      // debugPrint(
      //     'response body json decoded: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      // // stationNamesMap = await stationNameProvider().provideStationNames();
      // // await authInstance.signOut();
      setState(() {
        // items.addAll(stationNamesMap.keys.toList());
        items.remove('(서버 상태 확인 필요)');
        items.addAll(jsonDecode(utf8.decode(response.bodyBytes)).keys.toList());
      });
      // debugPrint('items : ${items}');
      isConnected = true;
      debugPrint('before cancel');
      _timer.cancel();
      debugPrint('after cancel');
      snackbarInstance.showSnackBar('알림', '서버 재접속 성공.');
    } on TimeoutException {
      debugPrint('network timeout');
      // setState(() {
      //   items.addAll(['(서버 상태 확인 필요)']);
      // });
      snackbarInstance.showSnackBar('알림', '서버 접속을 다시 시도중입니다.');
      // _timer = Timer.periodic(Duration(seconds: 3), (_) {
      //   setState(() {});
      // });
    } catch (e) {
      debugPrint('network e : ${e}');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('check1');
      try {
        var response =
            await http.get(baseUrl).timeout(Duration(milliseconds: 5000));
        debugPrint('response code : ${response.statusCode}');
        debugPrint('response header : ${response.headers}');
        debugPrint('response body : ${response.body}');
        debugPrint(
            'response body utf8 decoded: ${utf8.decode(response.bodyBytes)}');
        // debugPrint('response body type: ${response.body.runtimeType}');
        debugPrint(
            'response body json decoded: ${jsonDecode(utf8.decode(response.bodyBytes))}');
        // stationNamesMap = await stationNameProvider().provideStationNames();
        // await authInstance.signOut();
        setState(() {
          // items.addAll(stationNamesMap.keys.toList());
          items.addAll(
              jsonDecode(utf8.decode(response.bodyBytes)).keys.toList());
        });
        debugPrint('items : ${items}');
        isConnected = true;
      } on TimeoutException {
        debugPrint('network timeout');
        setState(() {
          items.addAll(['(서버 상태 확인 필요)']);
        });
        snackbarInstance.showSnackBar('알림', '서버 구동상태 혹은 네트워크 연결 상태를 확인해 주세요.');
        _timer = Timer.periodic(Duration(seconds: 8), (_) async {
          await initialLoad();
        });
      } catch (e) {
        debugPrint('network e : ${e}');
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  // final _loginShadow = [
  //   const Shadow(
  //       // bottomLeft
  //       offset: Offset(-1.5, -1.5),
  //       color: Colors.black87,
  //       blurRadius: 3.0),
  //   const Shadow(
  //       // bottomRight
  //       offset: Offset(1.5, -1.5),
  //       color: Colors.black87,
  //       blurRadius: 3.0),
  //   const Shadow(
  //       // topRight
  //       offset: Offset(1.5, 1.5),
  //       color: Colors.black87,
  //       blurRadius: 3.0),
  //   const Shadow(
  //       // topLeft
  //       offset: Offset(-1.5, 1.5),
  //       color: Colors.black87,
  //       blurRadius: 3.0),
  // ];

  final TextEditingController _passwordController = TextEditingController();

  final OutlineInputBorder _formFieldBorder = OutlineInputBorder(
      borderSide: BorderSide(
          color: Colors.white38, width: 1.0, style: BorderStyle.solid),
      borderRadius: BorderRadius.all(Radius.circular(10.0)));

  String _userPW = '';

  TextFormField _buildPwFormField(
    String labelText,
    TextEditingController controller,
  ) {
    return TextFormField(
        keyboardType: TextInputType.text,
        onSaved: (text) {
          _userPW = text!;
        },
        onChanged: (text) {
          _userPW = text;
        },
        maxLines: 1,
        style: const TextStyle(fontSize: 18, color: Colors.white),
        controller: controller,
        // key: ValueKey(0),
        obscureText: true,
        validator: (text) {
          if ((text == null || text.isEmpty || text.length < 6)) {
            return '6자 이상을 입력해주세요';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            suffixIcon: IconButton(
                color: Colors.white38,
                onPressed: () => controller.clear(),
                icon: Icon(Icons.clear, size: 20)),
            prefixIcon: Icon(Icons.lock, color: Colors.white38, size: 20),
            // labelText: "이메일 주소",
            // constraints: BoxConstraints(maxWidth: 10),
            hintText: labelText,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            filled: true,
            // fillColor: Colors.black38,
            fillColor: Colors.black54,
            hintStyle: const TextStyle(fontSize: 16.0, color: Colors.white60),
            enabledBorder: _formFieldBorder,
            border: _formFieldBorder,
            errorBorder: _formFieldBorder,
            disabledBorder: _formFieldBorder,
            focusedBorder: _formFieldBorder));
  }

  // final List<String> items = ['<지점명을 선택하세요>'];
  final List<String> items = ['<Please select a branch name>'];

  String? selectedValue;

  Widget _buildDropDownButton() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        iconStyleData: IconStyleData(iconEnabledColor: Colors.white70),
        isExpanded: true,
        hint: Row(
          children: [
            Icon(
              Icons.list,
              size: 20,
              color: Colors.white60,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                // '지점명을 선택하세요',
                'Please select a branch name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          if (value == '<지점명을 선택하세요>') {
            setState(() {
              selectedValue = null;
            });
          } else {
            setState(() {
              selectedValue = value;
            });
          }
        },
        buttonStyleData: ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 12),
          height: 50,
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.white38, width: 1.0),
            color: Colors.black54,
          ),
          elevation: 0,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          width: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black45,
          ),
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(8),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
            height: 30, padding: EdgeInsets.only(left: 14, right: 14)),
      ),
    );
  }

  bool isLoginWaiting = false;

  Color loginPageThemeColor = Color(0xff1E1250);

  @override
  Widget build(BuildContext context) {
    final getMachineSize = MediaQuery.of(context).size;
    final machineWidth = getMachineSize.width;
    final machineHeight = getMachineSize.height;

    return Container(
      height: machineHeight,
      width: machineWidth,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // Colors.white,
                // Colors.white,

                // Colors.black.withOpacity(0.8),
                Colors.white,
                Colors.white,
                // Color(0xff1E1250),
                // Color(0xff1E1250),
                // Color(0xff1E1250),
              ]),
          // color: Colors.black,
          image: DecorationImage(
            // image: AssetImage('assets/images/citygif_50fps.gif'),
            image: AssetImage('assets/images/smart_city1.gif'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          )),
      // image: AssetImage('assets/images/smt_ct3.gif'))),
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  const SizedBox(height: 16),
                  // Image.asset('assets/logo/gs_caltex_init.png'),
                  // Image.asset(
                  //   'assets/images/smt_ct.gif',
                  //   height: 30,
                  //   width: 80,
                  // ),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(
                      child: SvgPicture.asset(
                        'assets/logo/main_logo.svg',
                        color: Colors.lightBlue,
                        // width: machineWidth * 0.75,
                        // height: machineWidth * 0.75 * 0.2,
                      ),
                      width: machineWidth * 0.65,
                    )
                  ]),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 300,
                        height: 40,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                              fontSize: 20.0,
                              // color: Colors.white70,
                              color: Colors.black54,
                              fontFamily: 'kyobo',
                              fontWeight: FontWeight.bold),
                          child: AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: [
                              TyperAnimatedText(
                                  'Digital Transformation with AI',
                                  speed: const Duration(milliseconds: 80)),
                            ],
                            onTap: () {
                              print("Tap Event");
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(
                    height: 40.0,
                    thickness: 4.0,
                    color: Colors.black12,
                    indent: machineWidth * 0.1,
                    endIndent: machineWidth * 0.1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.white70),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                CustomDialogs().scaleDialog(context, '알림',
                                    '계정생성, 비밀번호 변경등 계정관련 문의사항은\nadmin@cityeyelab.com\n으로 문의바랍니다.');

                                // BottomSheets().openBottomSheet(
                                //     '계정생성 및 기타 로그인 관련된 문의는\nadmin@cityeyelab.com\n으로 해주시기 바랍니다.');
                              },
                              icon: Icon(
                                Icons.info_outlined,
                                color: Colors.white54,
                              )),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: min(500, machineWidth * 0.9),
                          height: 40,
                          child: _buildDropDownButton()),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          width: min(500, machineWidth * 0.9),
                          height: 40,
                          child: _buildPwFormField(
                              "Password", _passwordController)),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: min(500, machineWidth * 0.9),
                        height: 50,
                        child: isLoginWaiting
                            ? Center(
                                child: CircularProgressIndicator(
                                  // color: Colors.white.withOpacity(0.9),
                                  color: Colors.black38,
                                  strokeWidth: 6.0,
                                ),
                              )
                            : Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 100.0),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        primary: Colors.black54,
                                        backgroundColor:
                                            // Colors.white.withOpacity(0.9),
                                            // Colors.black54,
                                            Colors.black87,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                            side: BorderSide(
                                                color: Colors.white24,
                                                width: 0.8))),
                                    onPressed: () async {
                                      _formKey.currentState!.save();
                                      // debugPrint('id = ${stationNamesMap[selectedValue]}');
                                      // debugPrint('pw = $_userPW');
                                      await _signInProccess();
                                    },
                                    child: Text(
                                      "  Login  ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          // color: Color(0xff1E1250),
                                          // color: Colors.black54,
                                          color: Colors.white54,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     SizedBox(
                  //       height: 50,
                  //       width: 150,
                  //       child: TextButton(
                  //           onPressed: () {
                  //             BottomSheets().openBottomSheet(
                  //                 '계정생성 및 기타 로그인 관련된 문의는\nadmin@cityeyelab.com\n으로 해주시기 바랍니다.');
                  //           },
                  //           child: Text(
                  //             '로그인 문의',
                  //             maxLines: 1,
                  //             style: TextStyle(
                  //                 color: Colors.blue,
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.bold),
                  //           )),
                  //     )
                  //   ],
                  // ),

                  // Center(
                  //   child: SizedBox(
                  //     height: 33,
                  //     width: 140,
                  //     child: TextButton(
                  //         onPressed: () {
                  //           Get.offAll(() => MainPage());
                  //         },
                  //         child: Text(
                  //           'Go to MainPage',
                  //           maxLines: 1,
                  //         )),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Future<void> _signInProccess() async {
    setState(() {
      isLoginWaiting = true;
    });
    await Future.delayed(Duration(milliseconds: 1000), () {});

    // bool loginSuccess = false;
    //
    // if (stationNamesMap[selectedValue] != null) {
    //   loginSuccess =
    //       await authInstance.signIn(stationNamesMap[selectedValue], _userPW);
    // } else {
    //   loginSuccess = false;
    // }
    //
    // debugPrint('login result user = ${authInstance.getUser().toString()}');
    //
    // if (loginSuccess && authInstance.getUser() != null) {
    //   debugPrint('user = ${authInstance.getUser()}');
    //   Get.offAll(() => MainPage());
    // } else {
    //   snackbarInstance.showSnackBar('알림', '네트워크상태나 계정정보를 확인해주세요');
    // }

    debugPrint('Sel val ${selectedValue}');

    if (isConnected && selectedValue == '부천옥길' && _userPW == 'gstest123') {
      Get.offAll(() => MainPage());
    } else {
      snackbarInstance.showSnackBar('알림', '네트워크상태나 계정정보를 확인해주세요');
    }

    setState(() {
      isLoginWaiting = false;
    });
  }
}
