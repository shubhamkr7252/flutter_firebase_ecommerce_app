import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static Future<String> login(
      {required String email, required String password}) async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future logout() async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    await _firebaseAuth.signOut();
  }

  static Future<String> createUser(
      {required String email, required String password}) async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return FirebaseAuth.instance.currentUser!.uid;
  }
}
