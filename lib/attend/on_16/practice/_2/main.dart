// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:svg_flutter/svg.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer_home_page.dart';


import 'package:pemprograman_mobile/firebase_options.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
      // home: const Homepage(),
      home: const CustomerHomePage(),
      // home: const DetailProductPage(),
      // home: const LoginPage(),
      // home: const RegisterPage(),
      // home: const AddProductPage(),
      theme: ThemeData(fontFamily: 'Sans-Serif'), // Sesuaikan font jika ada,
      debugShowCheckedModeBanner: false,
      color: Colors.white));
}

