import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: const MyApp(), debugShowCheckedModeBanner: false));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String titleAppBar = 'Chats.';

    const double defaultIconStatusWhatsappSize = 158;
    const double defaultButtonSize = 35;
    const double defaultTextSize = 15;

    const dynamic defaultColor = Colors.grey;

    const dynamic defaultPeopleIconWhatsappStatuses = Icon(
      Icons.account_circle,
      size: defaultIconStatusWhatsappSize,
      color: defaultColor,
    );

    const dynamic defaultTextStyle = TextStyle(
        fontSize: defaultButtonSize,
        color: defaultColor,
        debugLabel: "Text Style Grey");

    const dynamic defaultBoxDecoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ));

    final dynamic logoAppLoginSection = Container(
      decoration: defaultBoxDecoration,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          defaultPeopleIconWhatsappStatuses,
          Text("You", style: defaultTextStyle)
        ],
      ),
    );

    final dynamic username = Container(
      decoration: defaultBoxDecoration,
      key: key,
      padding: EdgeInsets.all(7),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: "USERNAME",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)))),
      ),
    );

    final dynamic password = Container(
      decoration: defaultBoxDecoration,
      key: key,
      padding: EdgeInsets.all(7),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: "PASSWORD",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)))),
      ),
    );

    final dynamic forgotPasswordButton = MaterialButton(
      onPressed: () {},
      color: Colors.white,
      padding: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Text(
        "Forgot Password?",
        style: TextStyle(fontSize: defaultTextSize),
      ),
    );

    final dynamic signInButton = MaterialButton(
      onPressed: () {
        Route route =
            MaterialPageRoute(builder: (context) => DestinationPages(key: key));
        Navigator.push(context, route);
      },
      color: Colors.white,
      padding: EdgeInsets.only(left: 30, right: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Text(
        "Sign in.",
        style: defaultTextStyle,
      ),
    );

    final dynamic bodyContentLogin = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: key,
      spacing: 5,
      children: [
        logoAppLoginSection,
        username,
        password,
        forgotPasswordButton,
        signInButton
      ],
    );

    final dynamic scaffold = Scaffold(
        key: key,
        backgroundColor: Colors.grey,
        body: bodyContentLogin,
        appBar: null);

    return MaterialApp(
      title: titleAppBar,
      debugShowCheckedModeBanner: false,
      home: scaffold,
    );
  }
}

class DestinationPages extends StatelessWidget {
  const DestinationPages({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic defaultWhiteAppBarTextStyle = TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.normal);

    final dynamic defaultBlackAppBarTextStyle = TextStyle(
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.normal);

    final dynamic appbar = AppBar(
      backgroundColor: Colors.grey,
      key: key,
      title: Text("Explore.", style: defaultWhiteAppBarTextStyle),
      centerTitle: false,
      leading: MaterialButton(
          child: Center(
              child: Icon(Icons.arrow_circle_left_outlined,
                  color: Colors.white, size: 35)),
          onPressed: () {
            Navigator.pop(context);
          }),
    );

    final dynamic bottomNavigationBar = Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30))),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.chat, size: 35),
          Icon(Icons.image, size: 35),
          Icon(Icons.phone, size: 35),
          Icon(Icons.settings, size: 35),
        ],
      ),
    );

    final dynamic columnChildrenForBodyContent = [
      Container(
          decoration: BoxDecoration(color: Colors.grey),
          margin: EdgeInsets.all(5),
          child: Column(
            children: [
              MaterialButton(
                  onPressed: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => DetailDestination(key: key));
                    Navigator.push(context, route);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: Text("Test")),
                      Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cukul.",
                                style: defaultBlackAppBarTextStyle,
                              ),
                              Text("Kabupaten Bandung"),
                              Row(
                                spacing: 5,
                                children: [
                                  MaterialButton(
                                    onPressed: () {},
                                    color: Colors.black,
                                    child: Text(
                                      "Jangan di Klik 1",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {},
                                    color: Colors.black,
                                    child: Text(
                                      "Jangan di Klik 2",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 5,
                                children: [
                                  Icon(Icons.comment),
                                  Text("0 Comments"),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ))
            ],
          ))
    ];

    final Center bodyContent = Center(
      child: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          key: key,
          spacing: 5,
          children: columnChildrenForBodyContent,
        ),
      ),
    );

    final dynamic scaffold = Scaffold(
      // backgroundColor: Colors.grey,
      key: key,
      body: bodyContent,
      appBar: appbar,
      bottomNavigationBar: bottomNavigationBar,
    );

    return MaterialApp(
      key: key,
      debugShowCheckedModeBanner: false,
      home: scaffold,
    );
  }
}

class DetailDestination extends StatelessWidget {
  const DetailDestination({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Detail Destination';

    final dynamic appbarDetailDestination = AppBar(
      title: const Text(appTitle),
      leading: MaterialButton(
          child: Center(
              child: Icon(Icons.arrow_circle_left_outlined,
                  color: Colors.black, size: 35)),
          onPressed: () {
            Navigator.pop(context);
          }),
    );

    final dynamic materialAppHome = Scaffold(
      appBar: appbarDetailDestination,
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ImageSection(),
            TitleSection(name: "Cukul", location: "Kabupaten Bandung"),
            ButtonSection(),
            TextSection(
              description:
                  'Lake Oeschinen lies at the foot of the Blüemlisalp in the '
                  'Bernese Alps. Situated 1,578 meters above sea level, it '
                  'is one of the larger Alpine Lakes. A gondola ride from '
                  'Kandersteg, followed by a half-hour walk through pastures '
                  'and pine forest, leads you to the lake, which warms to 20 '
                  'degrees Celsius in the summer. Activities enjoyed here '
                  'include rowing, and riding the summer toboggan run.',
            ),
          ],
        ),
      ),
    );

    return MaterialApp(
      title: appTitle,
      home: materialAppHome,
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.name, required this.location});

  final String name;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(location, style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          ),
          /*3*/
          Icon(Icons.star, color: Colors.red[500]),
          const Text('41'),
        ],
      ),
    );
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonWithText(color: color, icon: Icons.call, label: 'CALL'),
          ButtonWithText(color: color, icon: Icons.near_me, label: 'ROUTE'),
          ButtonWithText(color: color, icon: Icons.share, label: 'SHARE'),
        ],
      ),
    );
  }
}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(description, softWrap: true),
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.image, size: 240);
  }
}
