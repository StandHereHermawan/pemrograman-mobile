import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_home.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/login.dart';
import 'package:pemprograman_mobile/firebase_options.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
      // home: const DetailProductPageDummy(),
      // home: const CustomerReceiptPage(),
      home: const CustomerHomePage(),
      // home: const CustomerCartPage(),
      // home: const AddProductPage(),
      // home: const AddHampersPage(),
      // home: const AdminHomePage(),
      // home: const RegisterPage(),
      // home: const ProfilePage(),
      // home: const LoginPage(),
      // home: const Homepage(),
      theme: ThemeData(fontFamily: 'Sans-Serif'), // Sesuaikan font jika ada,
      debugShowCheckedModeBanner: false,
      color: Colors.white));
}
