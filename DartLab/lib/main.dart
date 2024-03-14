import 'package:lab2/firebase_options.dart';
import 'package:lab2/pages/auth_gate.dart';
import 'package:lab2/pages/sign_in_page.dart';
import 'package:lab2/utils/color_schemes.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: needForSpeedUnderground2ColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: europaUniversalis4ColorScheme),
      home: const AuthGate(),
    );
  }
}
