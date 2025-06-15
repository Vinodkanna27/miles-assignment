import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth;
  AuthController(this._auth);

  Future<String?> signIn({required String email, required String password}) async {
    try {

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } finally {

    }
  }

  Future<String?> signUp({required String email, required String password}) async {
    try {

      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } finally {

    }
  }

  Future<void> signOut() async => await _auth.signOut();


}


