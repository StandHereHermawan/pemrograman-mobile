import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String titleAppBar = 'Gambar Local';
    const String textBodyInsideContainer = 'I am inside the container!';
    const double defaultAppBarFontSize = 25;
    const double defaultContentFontSize = 19;
    const double defaultBorderSize = 25;

    return MaterialApp(
      title: titleAppBar,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
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
            actions: [
              IconButton(
                  onPressed: () {},
                  tooltip: 'Comment icon',
                  icon: const Icon(Icons.comment)),
              IconButton(
                  onPressed: () {},
                  tooltip: 'Settings icon',
                  icon: const Icon(Icons.settings)),
            ],
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu_rounded),
              tooltip: 'Menu',
            ),
          ),
          body: Column(
            key: key,
            children: [
              Container(
                key: key,
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(4),
                // color: Colors.purple,
                width: double.infinity,
                height: 200,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black26, width: 3)),
                child: Center(
                  child: Image.asset(
                    "assets/images/logo_unibi.png",
                    scale: 0.5,
                  ),
                ),
              ),
              Container(
                key: key,
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(4),
                // color: Colors.purple,
                width: double.infinity,
                height: 200,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26, width: 3),
                    borderRadius: BorderRadiusDirectional.circular(20)),
                child: Text(textBodyInsideContainer,
                    style: const TextStyle(
                        color: Colors.black26,
                        fontSize: defaultContentFontSize,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal)),
              ),
              Container()
            ],
          )),
    );
  }
}
