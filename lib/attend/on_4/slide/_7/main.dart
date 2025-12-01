import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String titleAppBar = 'Navigator, Halaman 1.';
    const double defaultAppBarFontSize = 25;
    const double defaultBorderSize = 25;

    final AppBar appBar = AppBar(
      key: key,
      backgroundColor: Colors.blue,
      centerTitle: true,
      title: Text(titleAppBar,
          style: const TextStyle(
              color: Colors.white,
              fontSize: defaultAppBarFontSize,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.normal)),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(defaultBorderSize),
            bottomRight: Radius.circular(defaultBorderSize)),
      ),
    );

    final Widget body = Column(
      key: key,
      children: [
        Container(
          key: key,
          padding: EdgeInsets.all(7),
          margin: EdgeInsets.all(4),
          width: double.infinity,
          height: 200,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: 3),
              borderRadius: BorderRadiusDirectional.circular(20)),
          child: Center(
            child: MaterialButton(
                onPressed: () {
                  Route navigationTo2ndPage =
                  MaterialPageRoute(builder: (context) => Page2());
                  Navigator.push(context, navigationTo2ndPage);
                },
                child: Text("Klik untuk ke halaman 2.")),
          ),
        ),
      ],
    );

    return MaterialApp(
      title: titleAppBar,
      debugShowCheckedModeBanner: false,
      home: Scaffold(appBar: appBar, body: body),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String titleAppBar = 'Navigator, Halaman 2.';
    const double defaultAppBarFontSize = 25;
    const double defaultBorderSize = 25;

    final AppBar appBar = AppBar(
      key: key,
      backgroundColor: Colors.purple,
      centerTitle: true,
      title: Text(titleAppBar,
          style: const TextStyle(
              color: Colors.white,
              fontSize: defaultAppBarFontSize,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.normal)),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(defaultBorderSize),
            bottomRight: Radius.circular(defaultBorderSize)),
      ),
    );

    final Widget body = Column(
      key: key,
      children: [
        Container(
          key: key,
          padding: EdgeInsets.all(7),
          margin: EdgeInsets.all(4),
          width: double.infinity,
          height: 200,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: 3),
              borderRadius: BorderRadiusDirectional.circular(20)),
          child: Center(
            child: MaterialButton(
                child: Text("Kembali ke Halaman 1."),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
