import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginShadow = [
    const Shadow(
        // bottomLeft
        offset: Offset(-1.5, -1.5),
        color: Colors.black87,
        blurRadius: 3.0),
    const Shadow(
        // bottomRight
        offset: Offset(1.5, -1.5),
        color: Colors.black87,
        blurRadius: 3.0),
    const Shadow(
        // topRight
        offset: Offset(1.5, 1.5),
        color: Colors.black87,
        blurRadius: 3.0),
    const Shadow(
        // topLeft
        offset: Offset(-1.5, 1.5),
        color: Colors.black87,
        blurRadius: 3.0),
  ];

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailController2 = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _rePasswordController2 = TextEditingController();

  final OutlineInputBorder _formFieldBorder = const OutlineInputBorder(
      borderSide: BorderSide(
          color: Colors.white24, width: 0.8, style: BorderStyle.solid),
      borderRadius: BorderRadius.all(Radius.circular(10.0)));

  final OutlineInputBorder _transFormFieldBorder = const OutlineInputBorder(
      borderSide: BorderSide(
          color: Colors.transparent, width: 0.0, style: BorderStyle.none),
      borderRadius: BorderRadius.all(Radius.circular(10.0)));

  bool _isLogin = true;
  bool _autoLogin = false;
  String _userEmail = '';
  String _userPW = '';
  String _userEmail2 = '';
  String _userPW2 = '';

  TextFormField _buildTextFormField(
      String labelText,
      TextEditingController controller,
      bool isTransparent,
      int keyValue,
      bool isPW) {
    return TextFormField(
        keyboardType: (keyValue == 1 || keyValue == 4)
            ? TextInputType.emailAddress
            : TextInputType.text,
        onSaved: (text) {
          if (keyValue == 1) {
            _userEmail = text!;
          }
          if (keyValue == 2) {
            _userPW = text!;
          }
          if (keyValue == 4) {
            _userEmail2 = text!;
          }
          if (keyValue == 5) {
            _userPW2 = text!;
          }
          // if (keyValue == 3) {
          //   _cPW = text!;
          // }
        },
        onChanged: (text) {
          if (keyValue == 1) {
            _userEmail = text;
          }
          if (keyValue == 2) {
            _userPW = text;
          }
          if (keyValue == 4) {
            _userEmail2 = text;
          }
          if (keyValue == 5) {
            _userPW2 = text;
          }
          // if (keyValue == 3) {
          //   _cPW = text;
          // }
        },
        maxLines: 1,
        style: const TextStyle(fontSize: 18, color: Colors.white),
        controller: controller,
        key: ValueKey(keyValue),
        obscureText: isPW ? true : false,
        validator: (text) {
          if (keyValue != 6 &&
              (text == null || text.isEmpty || text.length < 6)) {
            return '6자 이상을 입력해주세요';
          }

          // if(keyValue == 3 && (text == null || text.isEmpty)){
          //   return '';
          // }
          // else if (text.length < 6) {
          //   return '6자 이상을 입력해주세요';
          // }

          // else if ((keyValue == 1 || keyValue == 4) && text.length < 6) {
          //   return '6자 이상을 입력해주세요';
          // } else if ((keyValue == 2 || keyValue == 5) && text.length < 6) {
          //   return '6자 이상을 입력해주세요';}
          // else if ((keyValue == 1 || keyValue == 4) &&
          //     !Validators().isValidEmail(text!))
          else if ((keyValue == 1 || keyValue == 4)) {
            return '유효한 Email을 입력해주세요';
          } else if (keyValue == 3 && text != _passwordController2.text) {
            return '비밀번호가 일치하지 않아요';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            suffixIcon: IconButton(
                color: Colors.white38,
                onPressed: () => controller.clear(),
                icon: Icon(Icons.clear, size: isTransparent ? 0 : 20)),
            prefixIcon: Icon(isPW ? Icons.lock : Icons.account_circle_outlined,
                color: Colors.white38, size: isTransparent ? 0 : 20),
            // labelText: "이메일 주소",
            // constraints: BoxConstraints(maxWidth: 10),
            hintText: labelText,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            filled: true,
            fillColor: Colors.black87.withOpacity(0.75),
            hintStyle: const TextStyle(fontSize: 16.0, color: Colors.white60),
            enabledBorder:
                isTransparent ? _transFormFieldBorder : _formFieldBorder,
            border: isTransparent ? _transFormFieldBorder : _formFieldBorder,
            errorBorder:
                isTransparent ? _transFormFieldBorder : _formFieldBorder,
            disabledBorder:
                isTransparent ? _transFormFieldBorder : _formFieldBorder,
            focusedBorder:
                isTransparent ? _transFormFieldBorder : _formFieldBorder));
  }

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
                // Colors.white,
                Color(0xff1E1250),
                Color(0xff1E1250),
                // Color(0xff1E1250),
                // Color(0xff1E1250),
                // Color(0xff1E1250),
                // Color(0xff1E1250),
                //
                // Colors.white,
                // Colors.white,
                // Colors.white,
                // Colors.white,
                //
                // Colors.black,
                // Colors.black,
                // Colors.black,
                // Colors.black,
                // Colors.red.withOpacity(0.5),
                // Colors.white,
                // Colors.white,

                // Colors.black.withOpacity(0.8)
                // Colors.purpleAccent.withOpacity(0.8)
              ]),
          // color: Colors.black,
          image: DecorationImage(
              image: AssetImage('assets/images/citygif_50fps.gif'))),
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
                      ),
                      width: machineWidth * 0.75,
                    )
                  ]),
                  const Divider(
                    height: 40.0,
                    thickness: 1.4,
                    color: Colors.white38,
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(height: 120),
                  ButtonBar(alignment: MainAxisAlignment.end, children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  _isLogin ? Colors.white70 : Colors.white12),
                          color: _isLogin ? Colors.black54 : Colors.black38,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16.0))),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = true;
                            });
                            _rePasswordController2.clear();
                            _rePasswordController.clear();
                            // _rePasswordController.clearComposing();
                            _passwordController2.clear();
                            _emailController2.clear();

                            FocusScope.of(context).unfocus();
                          },
                          child: Text("LOGIN",
                              style: TextStyle(
                                  fontSize: _isLogin ? 15 : 13,
                                  color: _isLogin
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.4),
                                  fontWeight: _isLogin
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  shadows: _loginShadow))),
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  _isLogin ? Colors.white12 : Colors.white70),
                          color: _isLogin ? Colors.black38 : Colors.black54,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16.0))),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = false;
                            });
                            _rePasswordController2.clear();
                            _rePasswordController.clear();
                            _passwordController.clear();
                            _emailController.clear();
                          },
                          child: Text("SIGN UP",
                              style: TextStyle(
                                  fontSize: _isLogin ? 12 : 14,
                                  color: _isLogin
                                      ? Colors.white.withOpacity(0.4)
                                      : Colors.white,
                                  fontWeight: _isLogin
                                      ? FontWeight.w400
                                      : FontWeight.w600,
                                  shadows: _loginShadow))),
                    ),
                  ]),
                  _isLogin
                      ? _buildTextFormField(
                          "Email Address", _emailController, false, 1, false)
                      : _buildTextFormField(
                          "Email Address", _emailController2, false, 4, false),
                  const SizedBox(height: 20),
                  _isLogin
                      ? _buildTextFormField(
                          "Password", _passwordController, false, 2, true)
                      : _buildTextFormField(
                          "Password", _passwordController2, false, 5, true),
                  const SizedBox(height: 20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: _isLogin ? 0.0 : 73.0,
                    child: _isLogin
                        ? _buildTextFormField("Confirm Password",
                            _rePasswordController2, true, 6, true)
                        : _buildTextFormField("Confirm Password",
                            _rePasswordController, false, 3, true),
                  ),
                  // const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            // showPasswordResetter();
                          },
                          child: Text(
                            '비밀번호를 잊었어요',
                            style: TextStyle(
                                color: Colors.lightBlue.withOpacity(0.8),
                                shadows: _loginShadow,
                                fontSize: 11),
                          )),
                      const SizedBox(width: 80),
                      Text(
                        '자동로그인',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            shadows: _loginShadow),
                      ),
                      Switch(
                          inactiveTrackColor: Colors.white38,
                          inactiveThumbColor: Colors.white70,
                          activeColor: Colors.blueAccent.withOpacity(0.9),
                          activeTrackColor:
                              Colors.lightBlueAccent.withOpacity(0.4),
                          value: _autoLogin,
                          onChanged: (value) {
                            setState(() {
                              _autoLogin = value;
                            });
                          })
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 130.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.black38,
                            backgroundColor:
                                Colors.blueAccent.withOpacity(0.75),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                side: BorderSide(
                                    color: Colors.white24, width: 0.8))),
                        onPressed: () async {},
                        child: Text(
                          _isLogin ? " 로그인 " : "계정만들기",
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                      //
                      // !isLoading
                      //     ? SizedBox(
                      //   width: machineWidth,
                      //   child: TextButton(
                      //       style: TextButton.styleFrom(
                      //           primary: Colors.black38,
                      //           backgroundColor: Colors.blueAccent
                      //               .withOpacity(0.75),
                      //           shape: const RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.all(
                      //                   Radius.circular(30.0)),
                      //               side: BorderSide(
                      //                   color: Colors.white24,
                      //                   width: 0.8))),
                      //       onPressed: () async {
                      //         // debugPrint('login process starts!');
                      //         if (_formKey.currentState!.validate()) {
                      //           debugPrint('All Inputs are Correct!');
                      //           _formKey.currentState!.save();
                      //           // debugPrint(_userEmail);
                      //           // debugPrint(_userPW);
                      //
                      //           //********* please check above, maybe we can build as a separate function *********
                      //           if (_isLogin) {
                      //             debugPrint(
                      //                 'first login process starts!');
                      //             setState(() {
                      //               isLoading = true;
                      //             });
                      //             try {
                      //               // debugPrint('login process starts!');
                      //               final newUser =
                      //               await _authentication
                      //                   .signInWithEmailAndPassword(
                      //                   email: _userEmail,
                      //                   password: _userPW);
                      //               if (newUser.user != null) {
                      //                 try {
                      //                   await infoControllerInsideLoginScreen
                      //                       .getUserInfosMap();
                      //                   // await infoControllerInsideLoginScreen
                      //                   //     .loadInfosInController
                      //                   //     .getAllUserInfos();
                      //                   // infoControllerInsideLoginScreen
                      //                   //     .allGetter();
                      //                 } catch (e) {
                      //                   await _authentication
                      //                       .signOut();
                      //                   getSnackbars.simpleSnackbarBottom(
                      //                       '알림',
                      //                       '로그인 중 유저정보 초기화에 실패했습니다.\n네트워크 상태를 확인해 주세요.');
                      //                   Get.offAll(() =>
                      //                   const LoginScreen());
                      //                 }
                      //                 if (newUser
                      //                     .user!.emailVerified ==
                      //                     false) {
                      //                   getSnackbars
                      //                       .simpleSnackbarBottom(
                      //                       '알림',
                      //                       '이메일 인증을 진행해 주세요!');
                      //                   _authentication.signOut();
                      //                   setState(() {
                      //                     isLoading = false;
                      //                   });
                      //                   Get.off(() =>
                      //                   const LoginScreen());
                      //                 } else {
                      //                   if (_autoLogin) {
                      //                     try {
                      //                       await storage.write(
                      //                           key: "login",
                      //                           value: "id " +
                      //                               _emailController
                      //                                   .text
                      //                                   .toString() +
                      //                               " " +
                      //                               "password " +
                      //                               _passwordController
                      //                                   .text
                      //                                   .toString());
                      //                       // print('store complete');
                      //                     } catch (e) {
                      //                       getSnackbars
                      //                           .simpleSnackbarBottom(
                      //                           '알림',
                      //                           '자동로그인 정보 저장 실패!');
                      //                     }
                      //                   }
                      //                   setState(() {
                      //                     isLoading = false;
                      //                     _islogining = true;
                      //                   });
                      //                   ///////////
                      //                   // try {
                      //                   //   await infoControllerInsideLoginScreen
                      //                   //       .getUserInfosMap();
                      //                   //   // await infoControllerInsideLoginScreen
                      //                   //   //     .loadInfosInController
                      //                   //   //     .getAllUserInfos();
                      //                   //   // infoControllerInsideLoginScreen
                      //                   //   //     .allGetter();
                      //                   // } catch (e) {
                      //                   //   await _authentication
                      //                   //       .signOut();
                      //                   //   getSnackbars
                      //                   //       .simpleSnackbarBottom(
                      //                   //           '알림',
                      //                   //           '로그인 중 유저정보 초기화에 실패했습니다.\n네트워크 상태를 확인해 주세요.');
                      //                   //   Get.offAll(() =>
                      //                   //       const LoginScreen());
                      //                   // }
                      //                   /////////////////
                      //                   if (infoControllerInsideLoginScreen
                      //                       .isActive.value ==
                      //                       false
                      //
                      //                   // infoControllerInsideLoginScreen
                      //                   //         .loadInfosInController
                      //                   //         .getterIsActive ==
                      //                   //     false
                      //
                      //                   ) {
                      //                     await _authentication
                      //                         .signOut();
                      //                     getSnackbars
                      //                         .simpleSnackbarBottom(
                      //                         '알림',
                      //                         '비활성화 되거나 탈퇴된 유저입니다.');
                      //                     Get.offAll(() =>
                      //                     const LoginScreen());
                      //                   }
                      //
                      //                   if (infoControllerInsideLoginScreen
                      //                       .userUid.value ==
                      //                       'loading...'
                      //                   // infoControllerInsideLoginScreen
                      //                   //         .loadInfosInController
                      //                   //         .getterUserUid ==
                      //                   //     'loading..'
                      //                   ) {
                      //                     await _authentication
                      //                         .signOut();
                      //                     getSnackbars
                      //                         .simpleSnackbarBottom(
                      //                         '알림',
                      //                         '로그인 중 유저정보 초기화에 실패했습니다.\n네트워크 상태를 확인해 주세요.');
                      //                     Get.offAll(() =>
                      //                     const LoginScreen());
                      //                   }
                      //
                      //                   // await infoControllerInsideLoginScreen.initialize();
                      //                   await Future.delayed(
                      //                       const Duration(
                      //                           milliseconds: 400),
                      //                           () {
                      //                         // debugPrint('await!');
                      //
                      //                         setState(() {
                      //                           _islogining = false;
                      //                           // _isAutologing = false;
                      //                         });
                      //                       });
                      //                   getSnackbars
                      //                       .simpleSnackbarBottom(
                      //                       '알림',
                      //                       '로그인 성공. 환영합니다!');
                      //
                      //                   Get.offAll(
                      //                           () => const MainScreen());
                      //                 }
                      //               }
                      //             } on FirebaseAuthException catch (e) {
                      //               // print(e.code);
                      //               if (e.code == 'user-not-found') {
                      //                 loginErrorMsg = '사용자 정보가 없습니다!';
                      //               } else if (e.code ==
                      //                   'wrong-password') {
                      //                 loginErrorMsg =
                      //                 '비밀번호가 올바르지 않습니다!';
                      //               } else {
                      //                 loginErrorMsg =
                      //                 '입력한 계정정보를 확인해주세요!';
                      //               }
                      //               getSnackbars.simpleSnackbarBottom(
                      //                   '알림',
                      //                   loginErrorMsg.toString());
                      //
                      //               setState(() {
                      //                 isLoading = false;
                      //               });
                      //             }
                      //           }
                      //           if (!_isLogin) {
                      //             // debugPrint('sign up process starts!');
                      //             setState(() {
                      //               // isLoading = true;
                      //             });
                      //
                      //             openConfirmDialog(_userEmail2);
                      //           }
                      //         }
                      //       },
                      //       child: Text(
                      //         _isLogin ? " 로그인 " : "계정만들기",
                      //         style: const TextStyle(
                      //             fontSize: 16,
                      //             color: Colors.white70,
                      //             fontWeight: FontWeight.bold),
                      //       )),
                      // )
                      //     : const Center(
                      //     child: CircularProgressIndicator()),
                      )
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
