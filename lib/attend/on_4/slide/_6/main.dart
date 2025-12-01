import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String titleAppBar = 'Listview and ListTile.';
    const double defaultAppBarFontSize = 25;
    const double defaultBorderSize = 25;

    final AppBar appBar = AppBar(
      backgroundColor: Colors.blue,
      key: key,
      title: Text(titleAppBar,
          style: const TextStyle(
              color: Colors.white,
              fontSize: defaultAppBarFontSize,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.normal)),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(defaultBorderSize),
            bottomRight: Radius.circular(defaultBorderSize)),
      ),
    );

    return MaterialApp(
      title: titleAppBar,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: appBar,
          body: ListView(
            key: key,
            padding: EdgeInsets.all(5),
            children: [
              ListTile(
                tileColor: Colors.blue,
                leading: Icon(Icons.account_balance, color: Colors.white),
                style: ListTileStyle.drawer,
                title: Text(
                  "Menu 1.",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: defaultAppBarFontSize,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal),
                ),
              ),
              ListTile(
                tileColor: Colors.white,
                leading: Icon(Icons.ac_unit_sharp, color: Colors.blue),
                title: Text("Menu 2.",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: defaultAppBarFontSize,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal)),
              ),
              ListTile(
                leading: Icon(Icons.accessible, color: Colors.white),
                tileColor: Colors.blue,
                title: Text("Menu 3.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: defaultAppBarFontSize,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal)),
              ),
            ],
          )),
    );
  }
}
