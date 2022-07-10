import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
}
