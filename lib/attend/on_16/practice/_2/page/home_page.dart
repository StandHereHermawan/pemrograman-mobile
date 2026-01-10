import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:svg_flutter/svg.dart';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/styles/box_decoration_default.dart';

import 'package:pemprograman_mobile/attend/on_16/practice/_2/styles/text_style_default.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/styles/colors.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/admin_auth.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/product_customer.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isConnected = false;
  StreamSubscription? _internetConnection;

  @override
  void initState() {
    super.initState();
    // Mendengarkan perubahan status internet secara realtime
    _internetConnection =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      setState(() {
        isConnected = status == InternetStatus.connected;
      });
    });
  }

  @override
  void dispose() {
    // Jangan lupa matikan listener saat widget ditutup
    _internetConnection?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // 
    // final double defaultIconStatusWhatsappSize = 158;
    // 
    // final dynamic defaultPeopleIcon = Icon(
    //   Icons.image,
    //   size: defaultIconStatusWhatsappSize,
    //   color: DefaultColors.primaryColors,
    // );
    // 

    final dynamic defaultIcon = Image.asset("assets/images/logo_unibi.png");

    final dynamic customerPageButton = MaterialButton(
      onPressed: () {
        Route route =
            MaterialPageRoute(builder: (context) => ProductCustomerViewPage());
        Navigator.push(context, route);
      },
      color: DefaultColors.secondaryColors,
      padding: EdgeInsets.only(bottom: 10, top: 10, left: 40, right: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        "Customer",
        style: TextStyleDefault.defaultBlack35SizeTextStyle(),
      ),
    );

    final dynamic adminPageButton = MaterialButton(
      onPressed: () {
        Route route =
            MaterialPageRoute(builder: (context) => AuthenticationAdminPage());
        Navigator.push(context, route);
      },
      color: DefaultColors.secondaryColors,
      padding: EdgeInsets.only(bottom: 10, top: 10, left: 40, right: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        "Admin",
        style: TextStyleDefault.defaultBlack35SizeTextStyle(),
      ),
    );

    final dynamic logoSection = Container(
      height: 600,
      width: 400,
      decoration: BoxDecorationDefault.defaultYellowBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          defaultIcon,
          Text("Destination.",
              style: TextStyleDefault.defaultBlack35SizeTextStyle())
        ],
      ),
    );

    final dynamic customerPageButtonSection = Container(
      child: customerPageButton,
    );

    final dynamic adminPageButtonSection = Container(
      child: adminPageButton,
    );

    final dynamic contentSelectMenuVisitorOrAdminSection = Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 50,
          children: [
            logoSection,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 7,
              children: [customerPageButtonSection, adminPageButtonSection],
            )
          ],
        ),
      ),
    );

    final dynamic scaffoldHomePage = Scaffold(
        backgroundColor: DefaultColors.primaryColors,
        body: contentSelectMenuVisitorOrAdminSection,
        appBar: null);

    if (isConnected) {
      return MaterialApp(
        title: null,
        debugShowCheckedModeBanner: false,
        home: scaffoldHomePage,
      );
    }

    return Scaffold(
      backgroundColor: DefaultColors.primaryColors,
      appBar: AppBar(title: const Text("Cek Internet Realtime")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              size: 100,
              color: isConnected ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              isConnected ? "Terhubung ke Internet" : "Tidak ada Internet",
              style: TextStyleDefault.defaultBlack35SizeTextStyle(
                  color: DefaultColors.tertiaryColors),
            ),
          ],
        ),
      ),
    );
  }
}
