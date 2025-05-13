import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'QrScreen.dart';
import 'LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFC Register',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'HP Simplified Regular'
      ),
      //home: QrScreen(),
      home: LoginScreen(),
    );
  }
}