// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:gs_mvp/main.dart';
//
// class Authentication {
//   Authentication._internal();
//   static final Authentication instance = Authentication._internal();
//
//   factory Authentication() {
//     return instance;
//   }
//
//   // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final _firebaseAuth = auth;
//
//   Future<bool> signIn(String email, String pw) async {
//     try {
//       final credential = await _firebaseAuth.signInWithEmailAndPassword(
//           email: email, password: pw);
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         // logger.w('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         // logger.w('Wrong password provided for that user.');
//       }
//     } catch (e) {
//       // logger.e(e);
//       return false;
//     }
//     // authPersistence(); // 인증 영속
//     return true;
//   }
//
//   Future<void> signOut() async {
//     await _firebaseAuth.signOut();
//   }
//
//   User? getUser() {
//     final user = _firebaseAuth.currentUser;
//     if (user != null) {
//       // final name = user.displayName;
//       // final email = user.email;
//       // final photoUrl = user.photoURL;
//       // final emailVerified = user.emailVerified;
//       // final uid = user.uid;
//     }
//     return user;
//   }
// }
