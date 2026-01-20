import 'package:flutter/material.dart';
import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

void main() {
  runApp(MaterialApp(
      home: const UmKmStatefulHomePage(),
      debugShowCheckedModeBanner: false,
      color: Colors.white));
}

class UmKmStatefulHomePage extends StatefulWidget {
  const UmKmStatefulHomePage({super.key});

  @override
  State<UmKmStatefulHomePage> createState() => _UmKmStatefulHomePageState();
}

class _UmKmStatefulHomePageState extends State<UmKmStatefulHomePage> {
  bool isConnected = false;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();
    // Mendengarkan perubahan status internet secara realtime
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      setState(() {
        isConnected = status == InternetStatus.connected;
      });
    });
  }

  @override
  void dispose() {
    // Jangan lupa matikan listener saat widget ditutup
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double defaultIconStatusWhatsappSize = 158;
    final double defaultButtonSize = 35;

    final dynamic defaultBlack = Colors.black;

    final dynamic defaultPeopleIconWhatsappStatuses = Icon(
      Icons.image,
      size: defaultIconStatusWhatsappSize,
      color: defaultBlack,
    );

    final dynamic defaultBlack35SizeTextStyle = TextStyle(
        fontSize: defaultButtonSize,
        color: defaultBlack,
        debugLabel: "Text Style Black");

    final dynamic defaultYellowBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
      color: Colors.yellow,
    );

    final dynamic customerPageButton = MaterialButton(
      onPressed: () {
        Route route =
            MaterialPageRoute(builder: (context) => ProductCustomerViewPage());
        Navigator.push(context, route);
      },
      color: Colors.yellow,
      padding: EdgeInsets.only(bottom: 10, top: 10, left: 40, right: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        "Customer",
        style: defaultBlack35SizeTextStyle,
      ),
    );

    final dynamic adminPageButton = MaterialButton(
      onPressed: () {
        Route route =
            MaterialPageRoute(builder: (context) => AuthenticationAdminPage());
        Navigator.push(context, route);
      },
      color: Colors.yellow,
      padding: EdgeInsets.only(bottom: 10, top: 10, left: 40, right: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        "Admin",
        style: defaultBlack35SizeTextStyle,
      ),
    );

    final dynamic logoSection = Container(
      height: 600,
      width: 400,
      decoration: defaultYellowBoxDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          defaultPeopleIconWhatsappStatuses,
          Text("Destination.", style: defaultBlack35SizeTextStyle)
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 50,
        children: [
          logoSection,
          Column(
            spacing: 7,
            children: [customerPageButtonSection, adminPageButtonSection],
          )
        ],
      ),
    );

    final dynamic scaffoldHomePage = Scaffold(
        backgroundColor: defaultBlack,
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class UmkmHomePage extends StatelessWidget {
  const UmkmHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double defaultIconStatusWhatsappSize = 158;
    final double defaultButtonSize = 35;

    final dynamic defaultBlack = Colors.black;

    final dynamic defaultPeopleIconWhatsappStatuses = Icon(
      Icons.image,
      size: defaultIconStatusWhatsappSize,
      color: defaultBlack,
    );

    final dynamic defaultBlack35SizeTextStyle = TextStyle(
        fontSize: defaultButtonSize,
        color: defaultBlack,
        debugLabel: "Text Style Black");

    final dynamic defaultYellowBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
      color: Colors.yellow,
    );

    final dynamic customerPageButton = MaterialButton(
      onPressed: () {
        Route route = MaterialPageRoute(
            builder: (context) => ProductCustomerViewPage(key: key));
        Navigator.push(context, route);
      },
      color: Colors.yellow,
      padding: EdgeInsets.only(bottom: 10, top: 10, left: 40, right: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        "Customer",
        style: defaultBlack35SizeTextStyle,
      ),
    );

    final dynamic adminPageButton = MaterialButton(
      onPressed: () {
        Route route = MaterialPageRoute(
            builder: (context) => AuthenticationAdminPage(key: key));
        Navigator.push(context, route);
      },
      color: Colors.yellow,
      padding: EdgeInsets.only(bottom: 10, top: 10, left: 40, right: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        "Admin",
        style: defaultBlack35SizeTextStyle,
      ),
    );

    final dynamic logoSection = Container(
      key: key,
      height: 600,
      width: 400,
      decoration: defaultYellowBoxDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          defaultPeopleIconWhatsappStatuses,
          Text("Destination.", style: defaultBlack35SizeTextStyle)
        ],
      ),
    );

    final dynamic customerPageButtonSection = Container(
      key: key,
      child: customerPageButton,
    );

    final dynamic adminPageButtonSection = Container(
      key: key,
      child: adminPageButton,
    );

    final dynamic contentSelectMenuVisitorOrAdminSection = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        key: key,
        spacing: 50,
        children: [
          logoSection,
          Column(
            key: key,
            spacing: 7,
            children: [customerPageButtonSection, adminPageButtonSection],
          )
        ],
      ),
    );

    final dynamic scaffoldHomePage = Scaffold(
        key: key,
        backgroundColor: defaultBlack,
        body: contentSelectMenuVisitorOrAdminSection,
        appBar: null);

    return MaterialApp(
      title: null,
      debugShowCheckedModeBanner: false,
      home: scaffoldHomePage,
    );
  }
}

class AuthenticationAdminPage extends StatelessWidget {
  const AuthenticationAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String titleAppBar = 'Chats.';

    const double defaultIconStatusWhatsappSize = 158;
    const double defaultButtonSize = 25;

    const dynamic defaultColor = Colors.black;
    const dynamic secondColor = Colors.yellow;
    const dynamic thirdColor = Colors.white;

    const dynamic defaultPeopleIconWhatsappStatuses = Icon(
      Icons.account_circle,
      size: defaultIconStatusWhatsappSize,
      color: defaultColor,
    );

    const dynamic defaultTextStyle = TextStyle(
        fontSize: defaultButtonSize,
        color: defaultColor,
        debugLabel: "Text Style Grey");

    const dynamic defaultBlackButtonSizeTextStyle = TextStyle(
        fontSize: defaultButtonSize,
        color: defaultColor,
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
      child: Column(
          key: key,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [signInButton]),
      height: 100,
    );

    final dynamic bodyContentLogin = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: key,
      spacing: 10,
      children: [logoAdminLoginSection, username, signInButtonSection],
    );

    final dynamic appbar = AppBar(
      backgroundColor: secondColor,
      key: key,
      title: Text("Back to Home.", style: defaultBlackButtonSizeTextStyle),
      centerTitle: false,
      leading: MaterialButton(
          child: Center(
              child: Icon(Icons.arrow_circle_left_outlined,
                  color: defaultColor, size: 35)),
          onPressed: () {
            Navigator.pop(context);
          }),
    );

    final dynamic scaffold = Scaffold(
        key: key,
        backgroundColor: defaultColor,
        body: bodyContentLogin,
        appBar: appbar);

    return MaterialApp(
      title: titleAppBar,
      debugShowCheckedModeBanner: false,
      home: scaffold,
    );
  }
}

class ProductCustomerViewPage extends StatelessWidget {
  const ProductCustomerViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String titleAppBar = 'Our Products';

    final double defaultButtonSize = 35;

    final dynamic defaultColor = Colors.black;
    final dynamic secondColor = Colors.yellow;

    final dynamic defaultYellowBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
      color: Colors.yellow,
    );

    final dynamic defaultBlackButtonSizeTextStyle = TextStyle(
        fontSize: defaultButtonSize,
        color: defaultColor,
        debugLabel: "Text Style Grey");

    final dynamic appbar = AppBar(
      backgroundColor: secondColor,
      key: key,
      title: Text(titleAppBar, style: defaultBlackButtonSizeTextStyle),
      centerTitle: true,
      leading: MaterialButton(
          child: Center(
              child: Icon(Icons.arrow_circle_left_outlined,
                  color: defaultColor, size: 35)),
          onPressed: () {
            Navigator.pop(context);
          }),
    );

    final dynamic scaffold = Scaffold(
        key: key,
        backgroundColor: defaultColor,
        body: Container(
            key: key,
            margin: EdgeInsets.all(10),
            decoration: defaultYellowBoxDecoration,
            child: ProductList(key: key)),
        appBar: appbar);

    return MaterialApp(
      title: titleAppBar,
      debugShowCheckedModeBanner: false,
      home: scaffold,
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        // Item 1
        ProductCard(
          title: "Lorem ipsum dolor sit amet, consectetur",
          author: "Fran Smith",
          labels: ["LABEL 1"],
          commentCount: 5,
        ),
        Divider(), // Garis pemisah antar item
        // Item 2
        ProductCard(
          title: "Vivamus fermentum elementum nunc",
          author: "John Atler",
          labels: ["LABEL 2", "LABEL 3"],
          commentCount: 0,
        ),
        Divider(),
        // Item 3
        ProductCard(
          title: "Quisque ex lectus, consequat gravida dolor",
          author: "Marie Sanders",
          labels: ["LABEL 3", "LABEL 1"],
          commentCount: 0,
        ),
      ],
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final String price;
  final String createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.createdAt,
  });
}

class ProductCard extends StatelessWidget {
  final String title;
  final String author;
  final List<String> labels;
  final int commentCount;

  const ProductCard({
    super.key,
    required this.title,
    required this.author,
    required this.labels,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Kiri: Placeholder Gambar (Thumbnail)
          Container(
            width: 100,
            height: 100,
            color: Colors.grey[300], // Warna abu-abu placeholder
            child: const Icon(
              Icons.landscape, // Icon gunung seperti di gambar
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 16), // Jarak antara gambar dan teks

          // Bagian Kanan: Konten Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Artikel
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Sedikit tebal
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Penulis (by Author)
                Text(
                  "by $author",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
