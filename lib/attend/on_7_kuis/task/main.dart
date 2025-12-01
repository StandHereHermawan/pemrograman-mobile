import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String titleAppBar = 'Chats.';
    const double defaultAppBarFontSize = 35;
    // const double defaultContentFontSize = 19;
    // const double defaultBorderSize = 25;
    const double defaultIconStatusWhatsappSize = 88;
    const double defaultIconContactWhatsappSize = 78;
    const double defaultIconBottomWhatsappSize = 50;

    const Icon defaultPeopleIconWhatsappStatuses =
        Icon(Icons.account_circle, size: defaultIconStatusWhatsappSize);
    const Icon defaultPeopleIconWhatsappContacts =
        Icon(Icons.account_circle, size: defaultIconContactWhatsappSize);

    final dynamic appbar = AppBar(
      backgroundColor: Colors.black87,
      key: key,
      title: Text(titleAppBar,
          style: const TextStyle(
              color: Colors.white,
              fontSize: defaultAppBarFontSize,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.normal)),
      centerTitle: false,
    );

    final dynamic searchBar = Container(
      color: Colors.white,
      key: key,
      margin: EdgeInsets.all(7),
      child: TextFormField(
        decoration: InputDecoration(labelText: "Search"),
      ),
    );
    final dynamic sectionRowWhatsAppLikeStatusColumn = Container(
      color: Colors.white,
      child: Row(
        children: [
          Column(
            children: [defaultPeopleIconWhatsappStatuses, Text("You")],
          ),
          Column(
            children: [defaultPeopleIconWhatsappStatuses, Text("Yes King")],
          ),
          Column(
            children: [defaultPeopleIconWhatsappStatuses, Text("Mas Amba")],
          ),
          Column(
            children: [defaultPeopleIconWhatsappStatuses, Text("Si imut")],
          ),
          Column(
            children: [
              Icon(Icons.account_circle, size: defaultIconStatusWhatsappSize),
              Text("Jokowi")
            ],
          ),
        ],
      ),
    );
    final dynamic sectionChatWhatsappLike = Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Column(
        children: [
          ListTile(
            leading: defaultPeopleIconWhatsappContacts,
            key: key,
            title: Text("Yes King"),
            subtitle: Text("Bersiaplah."),
          ),
          ListTile(
            leading: defaultPeopleIconWhatsappContacts,
            key: key,
            title: Text("Mas Amba"),
            subtitle:
                Text("Kita harus bersyukur meski jadi icon humor karamel."),
          ),
          ListTile(
            leading: defaultPeopleIconWhatsappContacts,
            key: key,
            title: Text("Jokowi"),
            subtitle: Text("Whoosh bukan tanggung jawab gw lagi cuy."),
          ),
          ListTile(
            leading: defaultPeopleIconWhatsappContacts,
            key: key,
            title: Text("Purbaya"),
            subtitle: Text("Pusing cok punya kementrian setengah gila semua."),
          ),
          MaterialButton(
            onPressed: () {},
            child: ListTile(
              leading: defaultPeopleIconWhatsappContacts,
              key: key,
              title: Text("Si Imut"),
              subtitle: Text("Kapan mau cukur bareng lagi? :(."),
            ),
          ),
          MaterialButton(
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (context) => ChatPage(key));
                Navigator.push(context, route);
              },
              child: ListTile(
                leading: defaultPeopleIconWhatsappContacts,
                key: key,
                title: Text("Penjual Vape"),
                subtitle: Text("Ambil hikmahna we kang."),
              )
          ),
        ],
      ),
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
          Icon(Icons.chat, size: defaultIconBottomWhatsappSize),
          Icon(Icons.image, size: defaultIconBottomWhatsappSize),
          Icon(Icons.phone, size: defaultIconBottomWhatsappSize),
          Icon(Icons.settings, size: defaultIconBottomWhatsappSize),
        ],
      ),
    );

    final dynamic scaffold = Scaffold(
      appBar: appbar,
      key: key,
      backgroundColor: Colors.grey,
      body: Column(
        key: key,
        children: [
          searchBar,
          sectionRowWhatsAppLikeStatusColumn,
          sectionChatWhatsappLike,
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );

    return MaterialApp(
      title: titleAppBar,
      debugShowCheckedModeBanner: false,
      home: scaffold,
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage(Key? key) : super(key: key);

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
