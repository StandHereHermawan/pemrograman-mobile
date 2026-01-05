import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pemprograman_mobile/firebase_options.dart';

void main() async {
  runApp(MaterialApp(
      home: const UmKmStatefulHomePage(),
      debugShowCheckedModeBanner: false,
      color: Colors.white));
}

class DefaultColors {
  static final primaryColors = Colors.black;
  static final secondaryColors = Colors.yellow;
  static final tertiaryColors = Colors.white;
  static final tertiary2ndColors = Colors.grey[700];
}

class TextStyleDefault {
  static TextStyle defaultBlack35SizeTextStyle(
      {double? fontSize = 35, Color? color}) {
    color ??= DefaultColors.primaryColors;
    return TextStyle(
        fontSize: fontSize, color: color, debugLabel: "Text Style Black");
  }

  static TextStyle defaultBlack16SizeTextStyle(
      {double? fontSize = 16, Color? color}) {
    color ??= DefaultColors.primaryColors;
    return TextStyle(
        fontSize: fontSize, color: color, debugLabel: "Text Style Black");
  }
}

class BoxDecorationDefault {
  static BoxDecoration? defaultYellowBoxDecoration(
      {double borderRadius = 30, Color? color}) {
    color ??= DefaultColors.secondaryColors;
    return BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadius),
      ),
      color: color,
    );
  }
}

class UmKmStatefulHomePage extends StatefulWidget {
  const UmKmStatefulHomePage({super.key});

  @override
  State<UmKmStatefulHomePage> createState() => _UmKmStatefulHomePageState();
}

class _UmKmStatefulHomePageState extends State<UmKmStatefulHomePage> {
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
    final double defaultIconStatusWhatsappSize = 158;

    final dynamic defaultPeopleIconWhatsappStatuses = Icon(
      Icons.image,
      size: defaultIconStatusWhatsappSize,
      color: DefaultColors.primaryColors,
    );

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
          defaultPeopleIconWhatsappStatuses,
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

class CustomAppBar {
  static dynamic appBarDefault(
      {key,
      context,
      titleAppbar = "DefaultAppbarTitle.",
      TextStyle? style,
      primaryColor = Colors.yellow,
      backgroundColor = Colors.black,
      onPressed}) {
    style ??= TextStyleDefault.defaultBlack35SizeTextStyle();

    return AppBar(
      backgroundColor: backgroundColor,
      key: key,
      title: Text(titleAppbar, style: style),
      centerTitle: true,
      leading: MaterialButton(
        onPressed: onPressed,
        child: Center(
            child: Icon(Icons.arrow_circle_left_outlined,
                color: primaryColor, size: 35)),
      ),
    );
  }
}

class ProductCustomerViewPage extends StatelessWidget {
  const ProductCustomerViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String titleAppBar = 'Our Products';

    final dynamic appbar = AppBar(
      backgroundColor: DefaultColors.secondaryColors,
      key: key,
      title: Text(titleAppBar,
          style: TextStyleDefault.defaultBlack35SizeTextStyle()),
      centerTitle: true,
      leading: MaterialButton(
          child: Center(
              child: Icon(Icons.arrow_circle_left_outlined,
                  color: DefaultColors.primaryColors, size: 35)),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: [
        MaterialButton(
            child: Center(
                child: Icon(Icons.arrow_circle_right_outlined,
                    color: DefaultColors.primaryColors, size: 35)),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );

    final dynamic scaffold = Scaffold(
        key: key,
        backgroundColor: DefaultColors.tertiary2ndColors,
        body: Container(
            key: key,
            margin: EdgeInsets.all(10),
            decoration: BoxDecorationDefault.defaultYellowBoxDecoration(
                color: DefaultColors.primaryColors),
            child: WidgetListProduct(key: key)),
        appBar: appbar);

    return MaterialApp(
      title: titleAppBar,
      debugShowCheckedModeBanner: false,
      home: scaffold,
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[700], // Warna background label gelap
        borderRadius: BorderRadius.circular(4), // Sudut sedikit melengkung
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Kiri: Placeholder Gambar (Thumbnail)
          Container(
            width: 150,
            height: 150,
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
                  product.name,
                  style: TextStyleDefault.defaultBlack16SizeTextStyle(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Penulis (by Author)
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),

                // Bagian Komentar
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.create, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          product.createdAt,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    // Baris Label (Tags)
                    Wrap(
                      spacing: 8.0, // Jarak horizontal antar label
                      runSpacing:
                          4.0, // Jarak vertical jika label turun ke bawah
                      children: [_buildLabel("Harga Rp.${product.price}")],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetListProduct extends StatelessWidget {
  const WidgetListProduct({super.key});

  @override
  Widget build(BuildContext context) {
    log("WidgetListProduct build function called.");

    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    CollectionReference<Product> mahasiswaCollection = FirebaseFirestore
        .instance
        .collection("products")
        .withConverter(fromFirestore: (snapshots, _) {
      return Product.fromJson(snapshots.data());
    }, toFirestore: (mahasiswa, _) {
      return mahasiswa.toJson();
    });

    return StreamBuilder<QuerySnapshot<Product>>(
        stream: mahasiswaCollection.snapshots(),
        builder: (contextStream, snapshotStream) {
          log("snapshotStream Anonymous Function Called.");
          if (snapshotStream.connectionState == ConnectionState.active) {
            return ListView(
              key: key,
              padding: const EdgeInsets.all(15.0),
              
              children: List<Widget>.generate(
                snapshotStream.data!.size,
                (index) {
                  Product data = snapshotStream.data!.docs[index].data();
                  log(data.toString());
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      color: DefaultColors.secondaryColors,
                      child: ProductCard(product: data, key: key),
                    ),
                  );
                },
              ),
            );
          }
          if (snapshotStream.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return WidgetProductListDummy(key: key);
          // return Scaffold(
          //   backgroundColor: DefaultColors.primaryColors,
          //   appBar: AppBar(title: const Text("Cek Internet Realtime")),
          //   body: Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(
          //           Icons.wifi_off,
          //           size: 100,
          //           color: Colors.red,
          //         ),
          //         const SizedBox(height: 20),
          //         Text(
          //           "Ada kesalahan yang belum diketahui.",
          //           style: TextStyleDefault.defaultBlack35SizeTextStyle(
          //               color: DefaultColors.tertiaryColors),
          //         ),
          //       ],
          //     ),
          //   ),
          // );
        });
  }
}

class WidgetProductListDummy extends StatelessWidget {
  const WidgetProductListDummy({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        // Item 1
        ProductCardDummy(
          title: "Lorem ipsum dolor sit amet, consectetur",
          author: "Fran Smith",
          labels: ["LABEL 1"],
          commentCount: 5,
        ),
        Divider(), // Garis pemisah antar item
        // Item 2
        ProductCardDummy(
          title: "Vivamus fermentum elementum nunc",
          author: "John Atler",
          labels: ["LABEL 2", "LABEL 3"],
          commentCount: 0,
        ),
        Divider(),
        // Item 3
        ProductCardDummy(
          title: "Quisque ex lectus, consequat gravida dolor",
          author: "Marie Sanders",
          labels: ["LABEL 3", "LABEL 1"],
          commentCount: 0,
        ),
        Divider(),
        ProductCardDummy(
          title: "Quisque ex lectus, consequat gravida doloren",
          author: "Marie Sanders",
          labels: ["LABEL 3", "LABEL 2"],
          commentCount: 0,
        ),
        Divider(),
        ProductCard(
            product: Product(
                id: "1",
                name: "Martabak Telor",
                description: "Martabak Telor, Telornya 1",
                price: 20000,
                createdAt: "2025"))
      ],
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final int price;
  final String createdAt;

  const Product({
    this.id = "0",
    this.name = "Kosong",
    this.description = "Kosong",
    this.price = 0,
    this.createdAt = "kosong",
  });

  @override
  String toString() {
    return "{id:${this.id},name:${this.name},description:${this.description},createdAt:${this.createdAt}}";
  }

  Product.fromJson(Map<String, dynamic>? jsonObject)
      : this(
          id: jsonObject?['id'] as String,
          name: jsonObject?['name'] as String,
          description: jsonObject?['description'] as String,
          price: jsonObject?['price'] as int,
          createdAt: jsonObject?['created_at'] as String,
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'created_at': createdAt,
    };
  }
}

class ProductCardDummy extends StatelessWidget {
  final String title;
  final String author;
  final List<String> labels;
  final int commentCount;

  const ProductCardDummy({
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
                  style: TextStyleDefault.defaultBlack16SizeTextStyle(),
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

                // Baris Label (Tags)
                Wrap(
                  spacing: 8.0, // Jarak horizontal antar label
                  runSpacing: 4.0, // Jarak vertical jika label turun ke bawah
                  children: labels.map((label) => _buildLabel(label)).toList(),
                ),
                const SizedBox(height: 12),

                // Bagian Komentar
                Row(
                  children: [
                    Icon(Icons.chat_bubble, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      "$commentCount Comments",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk membuat kotak Label abu-abu gelap
  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[700], // Warna background label gelap
        borderRadius: BorderRadius.circular(4), // Sudut sedikit melengkung
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
