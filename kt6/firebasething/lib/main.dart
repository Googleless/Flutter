import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/auth_service.dart';
import 'models/app_state.dart';
import 'auth/auth_screen.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService authService = AuthService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(authService),
      child: MaterialApp(
        title: 'Firebase Auth Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
          future: authService.isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData && snapshot.data == true) {
              return const MainScreen();
            } else {
              return const AuthScreen();
            }
          },
        ),
        routes: {
          '/auth': (context) => const AuthScreen(),
          '/main': (context) => const MainScreen(),
        },
      ),
    );
  }
}