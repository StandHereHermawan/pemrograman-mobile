// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/styles/colors.dart';

class AuthenticationAdminPage extends StatelessWidget {
  const AuthenticationAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String titleAppBar = 'Chats.';

    const double defaultIconStatusWhatsappSize = 158;
    const double defaultButtonSize = 25;

    // const dynamic secondColor = Colors.yellow;
    const dynamic thirdColor = Colors.white;

    const dynamic defaultPeopleIconWhatsappStatuses = Icon(
      Icons.account_circle,
      size: defaultIconStatusWhatsappSize,
      color: DefaultColors.primaryColors,
    );

    const dynamic defaultTextStyle = TextStyle(
        fontSize: defaultButtonSize,
        color: DefaultColors.primaryColors,
        debugLabel: "Text Style Grey");

    const dynamic defaultBlackButtonSizeTextStyle = TextStyle(
        fontSize: defaultButtonSize,
        color: DefaultColors.primaryColors,
        debugLabel: "Text Style Grey");

    const dynamic defaultBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
      color: thirdColor,
    );

    final dynamic logoAdminLoginSection = Container(
      decoration: defaultBoxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          defaultPeopleIconWhatsappStatuses,
          Text("Admin", style: defaultBlackButtonSizeTextStyle)
        ],
      ),
    );

    final dynamic username = Container(
      decoration: defaultBoxDecoration,
      key: key,
      padding: EdgeInsets.all(7),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: "CREDENTIALS",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)))),
      ),
    );

    final dynamic signInButton = Container(
      key: key,
      child: MaterialButton(
        onPressed: () {},
        color: Colors.white,
        padding: EdgeInsets.only(left: 30, right: 30),
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Text(
          "Sign in.",
          style: defaultTextStyle,
        ),
      ),
    );

    final dynamic signInButtonSection = Container(
      key: key,
      margin: EdgeInsets.all(0),
      height: 100,
      child: Column(
          key: key,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [signInButton]),
    );

    final dynamic bodyContentLogin = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: key,
      spacing: 10,
      children: [logoAdminLoginSection, username, signInButtonSection],
    );

    final dynamic appbar = AppBar(
      backgroundColor: DefaultColors.secondaryColors,
      key: key,
      title: Text("Back to Home.", style: defaultBlackButtonSizeTextStyle),
      centerTitle: false,
      leading: MaterialButton(
          child: Center(
              child: Icon(Icons.arrow_circle_left_outlined,
                  color: DefaultColors.primaryColors, size: 35)),
          onPressed: () {
            Navigator.pop(context);
          }),
    );

    final dynamic scaffold = Scaffold(
        key: key,
        backgroundColor: DefaultColors.primaryColors,
        body: bodyContentLogin,
        appBar: appbar);

    return MaterialApp(
      title: titleAppBar,
      debugShowCheckedModeBanner: false,
      home: scaffold,
    );
  }
}