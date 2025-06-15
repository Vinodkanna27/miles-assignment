import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miles_assignment/features/auth/screens/crud_screen.dart';
import 'features/auth/screens/welcome_screen.dart';
import 'features/auth/providers/auth_providers.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.web,
    );
  } else {
    await Firebase.initializeApp();

  }
  runApp(const ProviderScope(child: MilesApp()));
}

class MilesApp extends ConsumerWidget {
  const MilesApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateChangesProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: auth.when(
        data: (user) {
          if (user != null) {
            return const CoursesPage();
          } else {
            return const WelcomeScreen();
          }
        },
        loading: () => const MaterialApp(home:  Scaffold(body: Center(child: CircularProgressIndicator()))),
        error: (_, __) => const MaterialApp(home:  Scaffold(body: Center(child: Text('Something went wrong')))),
      ),
    );
  }
}
