import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/auth/login.dart';
import 'package:flutterapp/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Saffron Sweets",
        theme: ThemeData(
          splashColor: Colors.transparent,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: appColor, brightness: Brightness.light),
        ),
        darkTheme: ThemeData(
          splashColor: Colors.transparent,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: appColor, brightness: Brightness.dark),
        ),
        themeMode: ThemeMode.system,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Home();
            } else {
              return LoginForm();
            }
          },
        ));
  }
}
