import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_home.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/login.dart';
import 'package:pemprograman_mobile/firebase_options.dart';

void main() async {
  // untuk aplikasi yang pakai async (Firebase/SharedPreferences)
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
      home: const CustomerHomePage(),
      theme: ThemeData(fontFamily: 'Sans-Serif'),
      debugShowCheckedModeBanner: false,
      color: Colors.white));
}
