import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/auth_controller.dart';

// Provides an instance of FirebaseAuth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Provides an instance of AuthController using FirebaseAuth
final authControllerProvider = Provider<AuthController>((ref) {
  final auth = ref.read(firebaseAuthProvider); //
  return AuthController(auth);
});

// Watch user auth state
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});




