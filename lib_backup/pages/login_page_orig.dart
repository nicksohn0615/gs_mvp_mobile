// import 'package:flutter/material.dart';
//
// const thisVersion = '0.6.1';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   // GlobalKey<FormState> _formKey = GlobalKey<FormSate>();
//
//   bool isLoading = false;
//
//   // final _authentication = FirebaseAuth.instance;
//
//   String? userInfo;
//   // final storage = const FlutterSecureStorage();
//
//   String signUpErrorMsg = '';
//   String loginErrorMsg = '';
//
//   @override
//   void initState() {
//     super.initState();
//     // final infoControllerInsideLoginScreenInit = Get.put(InfoController());
//     // final TextEditingController idController = TextEditingController();
//     // final TextEditingController passController = TextEditingController();
//     WidgetsBinding.instance?.addPostFrameCallback((_) async {
//       List<dynamic> check = await _versionCheckMethod();
//       print('check = ' + check.toString());
//       if (check[0] == true) {
//         Get.offAll(() => const UnableToCheck());
//       }
//       if (check[0] == false && check[1] == false) {
//         Get.offAll(() =>
//             VersionCheckPage(nowVersion: thisVersion, latestVersion: check[2]));
//       }
//       if (check[0] == false && check[1] == true) {
//         await _autoLoginMethod();
//       }
//     });
//     debugPrint('LoginScreen opened!');
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _emailController2.dispose();
//     _passwordController.dispose();
//     _passwordController2.dispose();
//     _rePasswordController.dispose();
//     _rePasswordController2.dispose();
//     debugPrint('login screen disposed!');
//     super.dispose();
//   }
//
//   bool _isAutologing = false;
//   bool _islogining = false;
//
//   final VersionChecker _versionChecker = VersionChecker();
//
//   bool isGoodToGo = false;
//   String latestVersion = '';
//   bool unableToCheck = true;
//
//   Future<List<dynamic>> _versionCheckMethod() async {
//     dynamic versionDoc = {};
//     // debugPrint('ver check 0 ');
//     versionDoc = await _versionChecker.getVersionDoc();
//     debugPrint('version doc = ' + versionDoc.toString());
//     // debugPrint('version doc type= ' + versionDoc.runtimeType.toString());
//     // if (versionDoc != null && versionDoc.runtimeType == Map) {
//     if (versionDoc != null && versionDoc is Map) {
//       latestVersion = versionDoc['latest'];
//       unableToCheck = false;
//       // setState(() {
//       //   unableToCheck = false;
//       // });
//       // debugPrint('ver check 1');
//       final bool versionCheck =
//           _versionChecker.isAvailable(thisVersion, versionDoc);
//       if (versionCheck == true) {
//         isGoodToGo = true;
//         // setState(() {
//         //   isGoodToGo = true;
//         // });
//       } else {
//         isGoodToGo = false;
//         // setState(() {
//         //   isGoodToGo = false;
//         // });
//         debugPrint('latest = ' + latestVersion.toString());
//       }
//     } else {
//       unableToCheck = true;
//       // setState(() {
//       //   unableToCheck = true;
//       // });
//     }
//     return [unableToCheck, isGoodToGo, latestVersion];
//     // unableToCheck
//     //     ? const UnableToCheck()
//     //     : isGoodToGo
//     //         ? const LoginScreen()
//     //         : VersionCheckPage(
//     //             nowVersion: thisVersion, latestVersion: latestVersion);
//   }
//
//   Future<void> _autoLoginMethod() async {
//     final infoControllerInsideLoginScreenAutoLogin = Get.put(InfoController());
//     userInfo = (await storage.read(key: "login"))!;
//     debugPrint('userInfo: $userInfo');
//
//     // if (userInfo != null) {
//     if (userInfo != null) {
//       try {
//         Future.delayed(const Duration(milliseconds: 500), () {
//           // debugPrint('await!');
//           setState(() {
//             _islogining = true;
//             _isAutologing = true;
//           });
//         });
//         final newUser = await _authentication.signInWithEmailAndPassword(
//             email: userInfo!.split(" ")[1], password: userInfo!.split(" ")[3]);
//         if (newUser.user != null) {
//           try {
//             await infoControllerInsideLoginScreenAutoLogin.getUserInfosMap();
//             // await infoControllerInsideLoginScreen
//             //     .loadInfosInController
//             //     .getAllUserInfos();
//             // infoControllerInsideLoginScreen
//             //     .allGetter();
//           } catch (e) {
//             await _authentication.signOut();
//             getSnackbars.simpleSnackbarBottom(
//                 '알림', '로그인 중 유저정보 초기화에 실패했습니다.\n네트워크 상태를 확인해 주세요.');
//             Get.offAll(() => const LoginScreen());
//           }
//           if (newUser.user!.emailVerified == false) {
//             getSnackbars.simpleSnackbarBottom('알림', '이메일 인증을 진행해 주세요!');
//             _authentication.signOut();
//             setState(() {
//               _islogining = false;
//               _isAutologing = false;
//             });
//
//             Get.off(() => const LoginScreen());
//           } else {
//             try {
//               // await infoControllerInsideLoginScreenAutoLogin
//               //     .loadInfosInController
//               //     .getAllUserInfos();
//               // infoControllerInsideLoginScreenAutoLogin
//               //     .refreshLastKrpChartData();
//               // infoControllerInsideLoginScreenAutoLogin.allGetter();
//               await infoControllerInsideLoginScreenAutoLogin.getUserInfosMap();
//             } catch (e) {
//               await _authentication.signOut();
//               try {
//                 await storage.delete(key: "login");
//               } catch (e) {
//                 debugPrint(e.toString());
//               }
//               infoControllerInsideLoginScreenAutoLogin.dispose();
//               getSnackbars.simpleSnackbarBottom(
//                   '알림', '로그인 중 유저정보 초기화에 실패했습니다.\n네트워크 상태를 확인해 주세요.');
//               Get.offAll(() => const LoginScreen());
//             }
//             if (infoControllerInsideLoginScreenAutoLogin.isActive.value == false
//
//                 // infoControllerInsideLoginScreenAutoLogin
//                 //         .loadInfosInController.getterIsActive ==
//                 //     false
//
//                 ) {
//               // await _authentication.signOut();
//               try {
//                 await storage.delete(key: "login");
//               } catch (e) {
//                 debugPrint(e.toString());
//               }
//               await _authentication.signOut();
//               infoControllerInsideLoginScreenAutoLogin.dispose();
//               getSnackbars.simpleSnackbarBottom('알림', '비활성화 되거나 탈퇴된 유저입니다.');
//               Get.offAll(() => const LoginScreen());
//             } else {
//               Future.delayed(const Duration(milliseconds: 100), () {
//                 debugPrint('user info waiting');
//               });
//               if (infoControllerInsideLoginScreenAutoLogin.userUid.value ==
//                       'loading...'
//                   // infoControllerInsideLoginScreenAutoLogin
//                   //         .loadInfosInController.getterUserUid ==
//                   //     'loading..'
//                   ) {
//                 await _authentication.signOut();
//
//                 getSnackbars.simpleSnackbarBottom(
//                     '알림', '로그인 중 유저정보 초기화에 실패했습니다.\n네트워크 상태를 확인해 주세요.');
//                 // Get.offAll(() => const LoginScreen());
//                 // setState(() {
//                 //   _islogining = false;
//                 //   _isAutologing = false;
//                 // });
//               } else {
//                 getSnackbars.simpleSnackbarBottom('알림', '자동로그인 완료. 환영합니다!');
//                 infoControllerInsideLoginScreenAutoLogin.dispose();
//                 Get.offAll(() => const MainScreen());
//                 // setState(() {
//                 //   _islogining = false;
//                 //   _isAutologing = false;
//                 // });
//               }
//               infoControllerInsideLoginScreenAutoLogin.dispose();
//               setState(() {
//                 _islogining = false;
//                 _isAutologing = false;
//               });
//               // setState(() {
//               //   _islogining = false;
//               //   _isAutologing = false;
//               // });
//             }
//
//             // if (newUser.user != null) {
//             //   debugPrint('user info in auto login ${newUser.user}');
//             //   getSnackbars.simpleSnackbarBottom('알림', '자동로그인 완료. 환영합니다!');
//             //
//             //   // Get.snackbar('알림', '자동로그인 완료. 환영합니다!',
//             //   //     // borderColor: Colors.red,
//             //   //     backgroundColor: Colors.white54,
//             //   //     icon: const Icon(Icons.warning_amber_rounded),
//             //   //     shouldIconPulse: true,
//             //   //     snackPosition: SnackPosition.BOTTOM,
//             //   //     margin: const EdgeInsets.only(bottom: 20),
//             //   //     forwardAnimationCurve: Curves.easeIn,
//             //   //     reverseAnimationCurve: Curves.easeOut);
//             //   infoControllerInsideLoginScreenAutoLogin.dispose();
//             //   Get.offAll(() => const MainScreen());
//             //   setState(() {
//             //     _islogining = false;
//             //     _isAutologing = false;
//             //   });
//             // }
//           }
//         }
//       } catch (e) {
//         // print(e);
//         infoControllerInsideLoginScreenAutoLogin.dispose();
//         getSnackbars.simpleSnackbarBottom('알림', '저장된 계정정보를 불러오는데 실패하였습니다.');
//
//         // Get.snackbar('알림', '저장된 계정정보를 불러오는데 실패하였습니다!',
//         //     // borderColor: Colors.white38,
//         //     snackPosition: SnackPosition.BOTTOM,
//         //     forwardAnimationCurve: Curves.easeIn,
//         //     reverseAnimationCurve: Curves.easeOut);
//
//         setState(() {
//           _islogining = false;
//           _isAutologing = false;
//         });
//       }
//     }
//   }
//
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _emailController2 = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _passwordController2 = TextEditingController();
//   final TextEditingController _rePasswordController = TextEditingController();
//   final TextEditingController _rePasswordController2 = TextEditingController();
//
//   final OutlineInputBorder _formFieldBorder = const OutlineInputBorder(
//       borderSide: BorderSide(
//           color: Colors.white24, width: 0.8, style: BorderStyle.solid),
//       borderRadius: BorderRadius.all(Radius.circular(10.0)));
//
//   final OutlineInputBorder _transFormFieldBorder = const OutlineInputBorder(
//       borderSide: BorderSide(
//           color: Colors.transparent, width: 0.0, style: BorderStyle.none),
//       borderRadius: BorderRadius.all(Radius.circular(10.0)));
//
//   final _loginShadow = [
//     const Shadow(
//         // bottomLeft
//         offset: Offset(-1.5, -1.5),
//         color: Colors.black87,
//         blurRadius: 3.0),
//     const Shadow(
//         // bottomRight
//         offset: Offset(1.5, -1.5),
//         color: Colors.black87,
//         blurRadius: 3.0),
//     const Shadow(
//         // topRight
//         offset: Offset(1.5, 1.5),
//         color: Colors.black87,
//         blurRadius: 3.0),
//     const Shadow(
//         // topLeft
//         offset: Offset(-1.5, 1.5),
//         color: Colors.black87,
//         blurRadius: 3.0),
//   ];
//
//   bool _isLogin = true;
//   bool _autoLogin = false;
//   String _userEmail = '';
//   String _userPW = '';
//   String _userEmail2 = '';
//   String _userPW2 = '';
//
//   bool _showLoginGif = false;
//
//   // String _cPW = '';
//
//   TextFormField _buildTextFormField(
//       String labelText,
//       TextEditingController controller,
//       bool isTransparent,
//       int keyValue,
//       bool isPW) {
//     return TextFormField(
//         keyboardType: (keyValue == 1 || keyValue == 4)
//             ? TextInputType.emailAddress
//             : TextInputType.text,
//         onSaved: (text) {
//           if (keyValue == 1) {
//             _userEmail = text!;
//           }
//           if (keyValue == 2) {
//             _userPW = text!;
//           }
//           if (keyValue == 4) {
//             _userEmail2 = text!;
//           }
//           if (keyValue == 5) {
//             _userPW2 = text!;
//           }
//           // if (keyValue == 3) {
//           //   _cPW = text!;
//           // }
//         },
//         onChanged: (text) {
//           if (keyValue == 1) {
//             _userEmail = text;
//           }
//           if (keyValue == 2) {
//             _userPW = text;
//           }
//           if (keyValue == 4) {
//             _userEmail2 = text;
//           }
//           if (keyValue == 5) {
//             _userPW2 = text;
//           }
//           // if (keyValue == 3) {
//           //   _cPW = text;
//           // }
//         },
//         maxLines: 1,
//         style: const TextStyle(fontSize: 18, color: Colors.white),
//         controller: controller,
//         key: ValueKey(keyValue),
//         obscureText: isPW ? true : false,
//         validator: (text) {
//           if (keyValue != 6 &&
//               (text == null || text.isEmpty || text.length < 6)) {
//             return '6자 이상을 입력해주세요';
//           }
//
//           // if(keyValue == 3 && (text == null || text.isEmpty)){
//           //   return '';
//           // }
//           // else if (text.length < 6) {
//           //   return '6자 이상을 입력해주세요';
//           // }
//
//           // else if ((keyValue == 1 || keyValue == 4) && text.length < 6) {
//           //   return '6자 이상을 입력해주세요';
//           // } else if ((keyValue == 2 || keyValue == 5) && text.length < 6) {
//           //   return '6자 이상을 입력해주세요';}
//           else if ((keyValue == 1 || keyValue == 4) &&
//               !Validators().isValidEmail(text!)) {
//             return '유효한 Email을 입력해주세요';
//           } else if (keyValue == 3 && text != _passwordController2.text) {
//             return '비밀번호가 일치하지 않아요';
//           } else {
//             return null;
//           }
//         },
//         decoration: InputDecoration(
//             suffixIcon: IconButton(
//                 color: Colors.white38,
//                 onPressed: () => controller.clear(),
//                 icon: Icon(Icons.clear, size: isTransparent ? 0 : 20)),
//             prefixIcon: Icon(isPW ? Icons.lock : Icons.account_circle_outlined,
//                 color: Colors.white38, size: isTransparent ? 0 : 20),
//             // labelText: "이메일 주소",
//             // constraints: BoxConstraints(maxWidth: 10),
//             hintText: labelText,
//             contentPadding:
//                 const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//             filled: true,
//             fillColor: Colors.black87.withOpacity(0.75),
//             hintStyle: const TextStyle(fontSize: 16.0, color: Colors.white60),
//             enabledBorder:
//                 isTransparent ? _transFormFieldBorder : _formFieldBorder,
//             border: isTransparent ? _transFormFieldBorder : _formFieldBorder,
//             errorBorder:
//                 isTransparent ? _transFormFieldBorder : _formFieldBorder,
//             disabledBorder:
//                 isTransparent ? _transFormFieldBorder : _formFieldBorder,
//             focusedBorder:
//                 isTransparent ? _transFormFieldBorder : _formFieldBorder
//             // OutlineInputBorder(
//             //     borderSide: BorderSide(
//             //         color: Colors.transparent, width: 0),
//             //     borderRadius:
//             //         BorderRadius.all(Radius.circular(12.0)))
//             ));
//   }
//
//   bool _loginGifDelayedOnce = false;
//
//   DateTime? currentBackPressTime;
//
//   bool get _isAndroid => Theme.of(context).platform == TargetPlatform.android;
//
//   void showPasswordResetter() {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         backgroundColor: Colors.black26.withOpacity(0.65),
//         isDismissible: true,
//         elevation: 4.0,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//             side: const BorderSide(color: Colors.white24, width: 1.8)),
//         context: context,
//         builder: (_) => const ResetPasswordLS());
//   }
//
//   Future<bool> controlOnWillPop() {
//     DateTime now = DateTime.now();
//     if (_isAndroid) {
//       if (currentBackPressTime == null ||
//           now.difference(currentBackPressTime!) >
//               const Duration(milliseconds: 1500)) {
//         currentBackPressTime = now;
//         // Scaffold.of(context).showSnackBar(snackBar);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             duration: Duration(milliseconds: 1500),
//             content: Text(
//               '한번 더 누르면 종료됩니다.',
//               style: TextStyle(color: Colors.white70),
//             ),
//             backgroundColor: Colors.black54,
//           ),
//         );
//         return Future.value(false);
//       }
//     }
//     return Future.value(true);
//   }
//
//   void openConfirmDialog(String submittedEmail) {
//     Get.dialog(
//       AlertDialog(
//         backgroundColor: Colors.black.withOpacity(0.7),
//         title: const Text('알림', style: TextStyle(color: Colors.white70)),
//         content: RichText(
//             textAlign: TextAlign.center,
//             text: TextSpan(
//                 text: '입력하신 이메일 주소는 \n \n',
//                 style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w300),
//                 children: <TextSpan>[
//                   TextSpan(
//                       text: '$submittedEmail\n\n',
//                       style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.green,
//                           fontWeight: FontWeight.bold)),
//                   const TextSpan(
//                       text: '입니다.\n\n',
//                       style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.white70,
//                           fontWeight: FontWeight.w300)),
//                   const TextSpan(
//                       text: '* 비밀번호 변경 등에 사용되는 이메일 주소이므로\n다시 한번 확인해 주세요.\n\n',
//                       style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.white70,
//                           fontWeight: FontWeight.w300)),
//                   const TextSpan(
//                       text: '* 회원가입 확인을 위해 입력하신 메일로\n인증메일이 발송됩니다.',
//                       style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.white70,
//                           fontWeight: FontWeight.w300))
//                 ])),
//         actions: [
//           TextButton(
//             child: const SizedBox(child: Text("확인")),
//             onPressed: () async {
//               Get.back();
//               setState(() {
//                 _islogining = true;
//                 _isCreating = true;
//               });
//               await Future.delayed(const Duration(milliseconds: 1000), () {
//                 debugPrint(' ');
//               });
//               await createAccount();
//
//               setState(() {
//                 _islogining = false;
//                 _isCreating = false;
//               });
//             },
//           ),
//           TextButton(
//             child: const Text("취소"),
//             onPressed: () => Get.back(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   bool _isCreating = false;
//
//   Snackbars getSnackbars = const Snackbars();
//
//   Future<void> createAccount() async {
//     try {
//       final newUser = await _authentication.createUserWithEmailAndPassword(
//           email: _userEmail2, password: _userPW2);
//
//       if (newUser.user != null) {
//         await FirebaseFirestore.instance
//             .collection('user')
//             .doc(newUser.user!.uid)
//             .set({
//           // 'hado_name': 'null', 'krp': '1000',
//
//           'accuracy_avg': "0.0",
//           "attack_avg": "0.0",
//           "capabilities_cnt": "0",
//           "coordination_avg": "0.0",
//           "createdAt": FieldValue.serverTimestamp(),
//           "deactivatedAt": "?",
//           "defense_avg": "0.0",
//           "email": newUser.user!.email,
//           "group1": "null",
//           "hado_connect_id": "null",
//           "hado_name": "null",
//           "isActive": true,
//           "krp": "1000",
//           "lose": "0",
//           "modifiedAt": FieldValue.serverTimestamp(),
//           "stamina_avg": "0.0",
//           "uid": newUser.user!.uid,
//           "win": "0"
//         });
//
//         await FirebaseFirestore.instance
//             .collection('user')
//             .doc(newUser.user!.uid)
//             .collection('krp_history')
//             .add({'krp': '1000', 'createdAt': FieldValue.serverTimestamp()});
//         await newUser.user!.sendEmailVerification();
//
//         getSnackbars.simpleSnackbarBottom(
//             '알림', '계정생성 성공! 이메일 인증을 위해 메일을 확인해 주세요!');
//         await _authentication.signOut();
//         await Get.offAll(() => const LoginScreen());
//       }
//
//       // if (newUser.user != null) {
//       //   if (_autoLogin) {
//       //     try {
//       //       await storage.write(
//       //           key: "login",
//       //           value: "id " +
//       //               _emailController2.text.toString() +
//       //               " " +
//       //               "password " +
//       //               _passwordController2.text.toString());
//       //       // print('store complete');
//       //     } catch (e) {
//       //       // print(e);
//       //
//       //       getSnackbars.simpleSnackbarBottom('알림', '자동로그인 정보저장 실패');
//       //
//       //       setState(() {
//       //         isLoading = false;
//       //       });
//       //     }
//       //   }
//       //   setState(() {
//       //     isLoading = false;
//       //   });
//       //   Get.offAll(() => const MainScreen());
//       // }
//     } on FirebaseAuthException catch (signupError) {
//       // print(signupError.code);
//       // final String errorMsgSignUp = if (signupError.code == 'weak-password') { return '입력한 계정정보를 확인해주세요!';
//       if (signupError.code == 'weak-password') {
//         signUpErrorMsg = '비밀번호 보안이 약합니다';
//       } else if (signupError.code == 'email-already-in-use') {
//         signUpErrorMsg = '사용중인 계정입니다!';
//       } else {
//         signUpErrorMsg = '사용자정보를 확인해주세요!';
//       }
//       getSnackbars.simpleSnackbarBottom('알림', signUpErrorMsg);
//
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final getMachineSize = MediaQuery.of(context).size;
//     final machineWidth = getMachineSize.width;
//     final machineHeight = getMachineSize.height;
//     final infoControllerInsideLoginScreen = Get.put(InfoController());
//     Future.delayed(const Duration(milliseconds: 1500), () {
//       if (!_loginGifDelayedOnce) {
//         setState(() {
//           _showLoginGif = true;
//           _loginGifDelayedOnce = true;
//         });
//       }
//     });
//     return WillPopScope(
//       onWillPop: controlOnWillPop,
//       child: BlurryModalProgressHUD(
//         inAsyncCall: _islogining,
//         blurEffectIntensity: 3,
//         progressIndicator: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SpinKitFadingCircle(
//               color: Colors.white70,
//               size: 50.0,
//               duration: Duration(milliseconds: 700),
//             ),
//             const SizedBox(height: 15),
//             _isAutologing
//                 ? const DefaultTextStyle(
//                     child: Text('자동 로그인 중...'),
//                     style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold))
//                 : !_isCreating
//                     ? const DefaultTextStyle(
//                         child: Text('로그인 중...'),
//                         style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold))
//                     : const DefaultTextStyle(
//                         child: Text('계정 생성 중...'),
//                         style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold))
//           ],
//         ),
//         dismissible: false,
//         opacity: 0.4,
//         color: Colors.grey.withOpacity(0.7),
//         child: Container(
//             height: machineHeight,
//             width: machineWidth,
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Colors.blue,
//                       // Colors.blue,
//                       // Colors.black.withOpacity(0.5),
//                       Colors.black,
//                       Colors.black,
//                       Colors.black,
//                       Colors.black,
//                       // Colors.red.withOpacity(0.5),
//                       Colors.purpleAccent.withOpacity(0.8)
//                     ]),
//                 // color: Colors.black,
//                 image: DecorationImage(
//                     image: _showLoginGif
//                         ? const AssetImage(
//                             'assets/hado_login_background_revision2.gif')
//                         : const AssetImage('assets/just_black.png'))),
//             child: Scaffold(
//               body: GestureDetector(
//                 onTap: () {
//                   FocusScope.of(context).unfocus();
//                 },
//                 child: SafeArea(
//                   child: Form(
//                     key: _formKey,
//                     child: ListView(
//                       padding: const EdgeInsets.all(12),
//                       children: [
//                         const SizedBox(height: 16),
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 child: Image.asset(
//                                     'assets/hado_icon_transparent.png'),
//                                 width: 24,
//                               ),
//                               Text('HADO',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20,
//                                       color: Colors.white,
//                                       shadows: _loginShadow
//                                       // [
//                                       //   Shadow(
//                                       //       // bottomLeft
//                                       //       offset: Offset(-1.5, -1.5),
//                                       //       color: Colors.black26,
//                                       //       blurRadius: 5.0),
//                                       //   Shadow(
//                                       //       // bottomRight
//                                       //       offset: Offset(1.5, -0.5),
//                                       //       color: Colors.black87,
//                                       //       blurRadius: 5.0),
//                                       //   Shadow(
//                                       //       // topRight
//                                       //       offset: Offset(0.5, 1.5),
//                                       //       color: Colors.black87,
//                                       //       blurRadius: 5.0),
//                                       //   Shadow(
//                                       //       // topLeft
//                                       //       offset: Offset(-1.5, 1.5),
//                                       //       color: Colors.black26,
//                                       //       blurRadius: 5.0),
//                                       // ]
//                                       )),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               Text('KRP',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w900,
//                                       fontSize: 22,
//                                       color: Colors.white,
//                                       shadows: _loginShadow)),
//                               const SizedBox(width: 12),
//                               const Text('by',
//                                   style: TextStyle(color: Colors.white38)),
//                               SizedBox(
//                                   height: 50,
//                                   child: Image.asset(
//                                       'assets/cico_logo_transparent.png'))
//                             ]),
//                         const Divider(
//                           height: 40.0,
//                           thickness: 1.4,
//                           color: Colors.white38,
//                           indent: 20,
//                           endIndent: 20,
//                         ),
//                         const SizedBox(height: 120),
//                         ButtonBar(alignment: MainAxisAlignment.end, children: [
//                           Container(
//                             height: 40,
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: _isLogin
//                                         ? Colors.white70
//                                         : Colors.white12),
//                                 color:
//                                     _isLogin ? Colors.black54 : Colors.black38,
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(16.0))),
//                             child: TextButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     _isLogin = true;
//                                   });
//                                   _rePasswordController2.clear();
//                                   _rePasswordController.clear();
//                                   // _rePasswordController.clearComposing();
//                                   _passwordController2.clear();
//                                   _emailController2.clear();
//
//                                   FocusScope.of(context).unfocus();
//                                 },
//                                 child: Text("LOGIN",
//                                     style: TextStyle(
//                                         fontSize: _isLogin ? 15 : 13,
//                                         color: _isLogin
//                                             ? Colors.white
//                                             : Colors.white.withOpacity(0.4),
//                                         fontWeight: _isLogin
//                                             ? FontWeight.w600
//                                             : FontWeight.w400,
//                                         shadows: _loginShadow))),
//                           ),
//                           Container(
//                             height: 40,
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: _isLogin
//                                         ? Colors.white12
//                                         : Colors.white70),
//                                 color:
//                                     _isLogin ? Colors.black38 : Colors.black54,
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(16.0))),
//                             child: TextButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     _isLogin = false;
//                                   });
//                                   _rePasswordController2.clear();
//                                   _rePasswordController.clear();
//                                   _passwordController.clear();
//                                   _emailController.clear();
//                                 },
//                                 child: Text("SIGN UP",
//                                     style: TextStyle(
//                                         fontSize: _isLogin ? 12 : 14,
//                                         color: _isLogin
//                                             ? Colors.white.withOpacity(0.4)
//                                             : Colors.white,
//                                         fontWeight: _isLogin
//                                             ? FontWeight.w400
//                                             : FontWeight.w600,
//                                         shadows: _loginShadow))),
//                           ),
//                         ]),
//                         _isLogin
//                             ? _buildTextFormField("Email Address",
//                                 _emailController, false, 1, false)
//                             : _buildTextFormField("Email Address",
//                                 _emailController2, false, 4, false),
//                         const SizedBox(height: 20),
//                         _isLogin
//                             ? _buildTextFormField(
//                                 "Password", _passwordController, false, 2, true)
//                             : _buildTextFormField("Password",
//                                 _passwordController2, false, 5, true),
//                         const SizedBox(height: 20),
//                         AnimatedContainer(
//                           duration: const Duration(milliseconds: 500),
//                           height: _isLogin ? 0.0 : 73.0,
//                           child: _isLogin
//                               ? _buildTextFormField("Confirm Password",
//                                   _rePasswordController2, true, 6, true)
//                               : _buildTextFormField("Confirm Password",
//                                   _rePasswordController, false, 3, true),
//                         ),
//                         // const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             TextButton(
//                                 onPressed: () {
//                                   showPasswordResetter();
//                                 },
//                                 child: Text(
//                                   '비밀번호를 잊었어요',
//                                   style: TextStyle(
//                                       color: Colors.lightBlue.withOpacity(0.8),
//                                       shadows: _loginShadow,
//                                       fontSize: 11),
//                                 )),
//                             const SizedBox(width: 80),
//                             Text(
//                               '자동로그인',
//                               style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 14,
//                                   shadows: _loginShadow),
//                             ),
//                             Switch(
//                                 inactiveTrackColor: Colors.white38,
//                                 inactiveThumbColor: Colors.white70,
//                                 activeColor: Colors.blueAccent.withOpacity(0.9),
//                                 activeTrackColor:
//                                     Colors.lightBlueAccent.withOpacity(0.4),
//                                 value: _autoLogin,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _autoLogin = value;
//                                   });
//                                 })
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 0.0, horizontal: 130.0),
//                           child: !isLoading
//                               ? SizedBox(
//                                   width: machineWidth,
//                                   child: TextButton(
//                                       style: TextButton.styleFrom(
//                                           primary: Colors.black38,
//                                           backgroundColor: Colors.blueAccent
//                                               .withOpacity(0.75),
//                                           shape: const RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(30.0)),
//                                               side: BorderSide(
//                                                   color: Colors.white24,
//                                                   width: 0.8))),
//                                       onPressed: () async {
//                                         // debugPrint('login process starts!');
//                                         if (_formKey.currentState!.validate()) {
//                                           debugPrint('All Inputs are Correct!');
//                                           _formKey.currentState!.save();
//                                           // debugPrint(_userEmail);
//                                           // debugPrint(_userPW);
//
//                                           //********* please check above, maybe we can build as a separate function *********
//                                           if (_isLogin) {
//                                             debugPrint(
//                                                 'first login process starts!');
//                                             setState(() {
//                                               isLoading = true;
//                                             });
//                                             try {
//                                               // debugPrint('login process starts!');
//                                               final newUser =
//                                                   await _authentication
//                                                       .signInWithEmailAndPassword(
//                                                           email: _userEmail,
//                                                           password: _userPW);
//                                               if (newUser.user != null) {
//                                                 try {
//                                                   await infoControllerInsideLoginScreen
//                                                       .getUserInfosMap();
//                                                   // await infoControllerInsideLoginScreen
//                                                   //     .loadInfosInController
//                                                   //     .getAllUserInfos();
//                                                   // infoControllerInsideLoginScreen
//                                                   //     .allGetter();
//                                                 } catch (e) {
//                                                   await _authentication
//                                                       .signOut();
//                                                   getSnackbars.simpleSnackbarBottom(
//                                                       '알림',
//                                                       '로그인 중 유저정보 초기화에 실패했습니다.\n네트워크 상태를 확인해 주세요.');
//                                                   Get.offAll(() =>
//                                                       const LoginScreen());
//                                                 }
//                                                 if (newUser
//                                                         .user!.emailVerified ==
//                                                     false) {
//                                                   getSnackbars
//                                                       .simpleSnackbarBottom(
//                                                           '알림',
//                                                           '이메일 인증을 진행해 주세요!');
//                                                   _authentication.signOut();
//                                                   setState(() {
//                                                     isLoading = false;
//                                                   });
//                                                   Get.off(() =>
//                                                       const LoginScreen());
//                                                 } else {
//                                                   if (_autoLogin) {
//                                                     try {
//                                                       await storage.write(
//                                                           key: "login",
//                                                           value: "id " +
//                                                               _emailController
//                                                                   .text
//                                                                   .toString() +
//                                                               " " +
//                                                               "password " +
//                                                               _passwordController
//                                                                   .text
//                                                                   .toString());
//                                                       // print('store complete');
//                                                     } catch (e) {
//                                                       getSnackbars
//                                                           .simpleSnackbarBottom(
//                                                               '알림',
//                                                               '자동로그인 정보 저장 실패!');
//                                                     }
//                                                   }
//                                                   setState(() {
//                                                     isLoading = false;
//                                                     _islogining = true;
//                                                   });
//                                                   ///////////
//                                                   // try {
//                                                   //   await infoControllerInsideLoginScreen
//                                                   //       .getUserInfosMap();
//                                                   //   // await infoControllerInsideLoginScreen
//                                                   //   //     .loadInfosInController
//                                                   //   //     .getAllUserInfos();
//                                                   //   // infoControllerInsideLoginScreen
//                                                   //   //     .allGetter();
//                                                   // } catch (e) {
//                                                   //   await _authentication
//                                                   //       .signOut();
//                                                   //   getSnackbars
//                                                   //       .simpleSnackbarBottom(
//                                                   //           '알림',
//                                                   //           '로그인 중 유저정보 초기화에 실패했습니다.\n네트워크 상태를 확인해 주세요.');
//                                                   //   Get.offAll(() =>
//                                                   //       const LoginScreen());
//                                                   // }
//                                                   /////////////////
//                                                   if (infoControllerInsideLoginScreen
//                                                               .isActive.value ==
//                                                           false
//
//                                                       // infoControllerInsideLoginScreen
//                                                       //         .loadInfosInController
//                                                       //         .getterIsActive ==
//                                                       //     false
//
//                                                       ) {
//                                                     await _authentication
//                                                         .signOut();
//                                                     getSnackbars
//                                                         .simpleSnackbarBottom(
//                                                             '알림',
//                                                             '비활성화 되거나 탈퇴된 유저입니다.');
//                                                     Get.offAll(() =>
//                                                         const LoginScreen());
//                                                   }
//
//                                                   if (infoControllerInsideLoginScreen
//                                                               .userUid.value ==
//                                                           'loading...'
//                                                       // infoControllerInsideLoginScreen
//                                                       //         .loadInfosInController
//                                                       //         .getterUserUid ==
//                                                       //     'loading..'
//                                                       ) {
//                                                     await _authentication
//                                                         .signOut();
//                                                     getSnackbars
//                                                         .simpleSnackbarBottom(
//                                                             '알림',
//                                                             '로그인 중 유저정보 초기화에 실패했습니다.\n네트워크 상태를 확인해 주세요.');
//                                                     Get.offAll(() =>
//                                                         const LoginScreen());
//                                                   }
//
//                                                   // await infoControllerInsideLoginScreen.initialize();
//                                                   await Future.delayed(
//                                                       const Duration(
//                                                           milliseconds: 400),
//                                                       () {
//                                                     // debugPrint('await!');
//
//                                                     setState(() {
//                                                       _islogining = false;
//                                                       // _isAutologing = false;
//                                                     });
//                                                   });
//                                                   getSnackbars
//                                                       .simpleSnackbarBottom(
//                                                           '알림',
//                                                           '로그인 성공. 환영합니다!');
//
//                                                   Get.offAll(
//                                                       () => const MainScreen());
//                                                 }
//                                               }
//                                             } on FirebaseAuthException catch (e) {
//                                               // print(e.code);
//                                               if (e.code == 'user-not-found') {
//                                                 loginErrorMsg = '사용자 정보가 없습니다!';
//                                               } else if (e.code ==
//                                                   'wrong-password') {
//                                                 loginErrorMsg =
//                                                     '비밀번호가 올바르지 않습니다!';
//                                               } else {
//                                                 loginErrorMsg =
//                                                     '입력한 계정정보를 확인해주세요!';
//                                               }
//                                               getSnackbars.simpleSnackbarBottom(
//                                                   '알림',
//                                                   loginErrorMsg.toString());
//
//                                               setState(() {
//                                                 isLoading = false;
//                                               });
//                                             }
//                                           }
//                                           if (!_isLogin) {
//                                             // debugPrint('sign up process starts!');
//                                             setState(() {
//                                               // isLoading = true;
//                                             });
//
//                                             openConfirmDialog(_userEmail2);
//                                           }
//                                         }
//                                       },
//                                       child: Text(
//                                         _isLogin ? " 로그인 " : "계정만들기",
//                                         style: const TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.white70,
//                                             fontWeight: FontWeight.bold),
//                                       )),
//                                 )
//                               : const Center(
//                                   child: CircularProgressIndicator()),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               backgroundColor: Colors.transparent,
//             )),
//       ),
//     );
//   }
// }
