import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/presentation/dashboard_screen.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
    try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );    // For quick testing - sign in anonymously to avoid permission issues
    await FirebaseAuth.instance.signInAnonymously();
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Color(0xffFFC268),
          surface: Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: Color(0xFF121212),
        useMaterial3: true,
      ),
      home: DashboardScreen(),
    );
  }
}
