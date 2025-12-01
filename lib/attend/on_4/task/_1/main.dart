import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String titleAppBar = 'Task Pertemuan 4';
    const double defaultAppBarFontSize = 25;
    const double defaultContentFontSize = 19;
    const double defaultBorderSize = 25;

    final double defaultSpacing = 3;
    final double defaultPadding = 10;

    final TextStyle bodyTextStyle = TextStyle(
        color: Colors.white,
        fontSize: defaultContentFontSize,
        fontWeight: AppBarTask.defaultAppBarFontWeight);

    final Widget bodyContentBasicInfoArief = Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: defaultSpacing,
      children: [
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
          child: Text(
            'Nama: Arief Karditya Hermawan',
            style: bodyTextStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
          child: Text(
            'TTL: Bandung, 12 Maret 2003',
            style: bodyTextStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
          child: Text(
            'Hobby: Nonton Youtube',
            style: bodyTextStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
          child: Text(
            'Que sera, sera.. whatever will be.. will be.',
            style: bodyTextStyle,
          ),
        ),
      ],
    );
    final Widget bodySectionBasicInfoArief = Container(
      key: key,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(defaultPadding)),
          color: Colors.white),
      padding: EdgeInsets.all(defaultSpacing),
      margin: EdgeInsets.all(defaultSpacing),
      child: bodyContentBasicInfoArief,
    );

    final Widget bodyContentEducationInfoArief = Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: defaultSpacing,
      children: [
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
          child: Text(
            'SD: SD Negeri Jelegong 2, Rancaekek.',
            style: bodyTextStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
          child: Text(
            'SMP: SMP Negeri 4, Rancaekek.',
            style: bodyTextStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
          child: Text(
            'SMA: SMA Negeri 1, Rancaekek.',
            style: bodyTextStyle,
          ),
        ),
      ],
    );
    final Widget bodySectionEducationInfoArief = Container(
      key: key,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(defaultPadding)),
          color: Colors.white),
      padding: EdgeInsets.all(defaultSpacing),
      margin: EdgeInsets.all(defaultSpacing),
      child: bodyContentEducationInfoArief,
    );

    final Widget bodyContentWishAfterGraduatedArief = Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: defaultSpacing,
      children: [
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
          child: Text(
            'Wish After Graduated.',
            style: bodyTextStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
          child: Text(
            'Cashflow pribadi positif mau itu serabutan atau kerja full time.',
            style: bodyTextStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
          child: Text(
            'Bisa ngikutin softcourse',
            style: bodyTextStyle,
          ),
        ),
      ],
    );
    final Widget bodySectionWishAfterGraduatedArief = Container(
      key: key,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(defaultPadding)),
          color: Colors.white),
      padding: EdgeInsets.all(defaultSpacing),
      margin: EdgeInsets.all(defaultSpacing),
      child: bodyContentWishAfterGraduatedArief,
    );

    final Widget bodyContentContactArief = Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: defaultSpacing,
      children: [
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
          child: Text(
            'Contact.',
            style: bodyTextStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
          child: Text(
            'Whatsapp/Handphone; 085157002283.',
            style: bodyTextStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding))),
          child: Text(
            'X; HermawanIsHere',
            style: bodyTextStyle,
          ),
        ),
      ],
    );
    final Widget bodySectionContactArief = Container(
      key: key,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(defaultPadding)),
          color: Colors.white),
      padding: EdgeInsets.all(defaultSpacing),
      margin: EdgeInsets.all(defaultSpacing),
      child: bodyContentContactArief,
    );

    final PreferredSizeWidget appBar = AppBar(
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
      actions: [],
      leading: null,
      bottom: const TabBar(tabs: [
        Tab(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            )),
        Tab(
            icon: Icon(
              Icons.school_outlined,
              color: Colors.white,
            )),
        Tab(
            icon: Icon(Icons.star_border_outlined,
                color: Colors.white)),
        Tab(
            icon: Icon(Icons.contact_page_outlined,
                color: Colors.white)),
      ]),
    );

    return MaterialApp(
        title: titleAppBar,
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: appBar,
              body: TabBarView(children: [
                bodySectionBasicInfoArief,
                bodySectionEducationInfoArief,
                bodySectionWishAfterGraduatedArief,
                bodySectionContactArief,
              ]),
            )));
  }
}

final class AppBarTask extends AppBar {
  static const double defaultAppBarFontSize = 25;
  static const double defaultAppBarIconSize = 30;
  static const FontWeight defaultAppBarFontWeight = FontWeight.w900;
  static const Color defaultAppBarFontColor = Colors.white;

  AppBarTask(
      {super.key,
      super.backgroundColor = Colors.blueAccent,
      super.title = const Text("AppBarDummy",
          style: TextStyle(
              color: defaultAppBarFontColor,
              fontSize: defaultAppBarIconSize,
              fontWeight: defaultAppBarFontWeight)),
      super.leading = const IconButton(
          onPressed: null,
          icon: Icon(
            Icons.menu_rounded,
            size: 40,
            color: Colors.black26,
          )),
      super.actions = const <Widget>[
        IconButton(
          onPressed: null,
          icon: Icon(Icons.chat, size: defaultAppBarIconSize),
          color: defaultAppBarFontColor,
        ),
        IconButton(
          onPressed: null,
          icon: Icon(Icons.account_circle_sharp, size: defaultAppBarIconSize),
          color: defaultAppBarFontColor,
        ),
      ]});
}
