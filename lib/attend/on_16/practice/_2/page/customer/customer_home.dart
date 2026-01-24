import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_kue.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_hampers.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/hampers.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_cart.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_delivery.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_finished_order.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_receipt.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/detail_product.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/login.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/user_interface_component/appbar.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/user_interface_component/product_card_customer.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/util/session_manager.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    bool isLogin = await SessionManager.isUserLoggedIn();
    if (!isLogin && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Customer Home"),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Banner Section
          SizedBox(
            height: 180,
            child: PageView(
              children: [
                _buildImageSlider("assets/images/banner1.png"),
                _buildImageSlider("assets/images/banner2.png"),
                _buildImageSlider("assets/images/banner3.png"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildDot(true), _buildDot(false), _buildDot(false)],
          ),
          const SizedBox(height: 25),

          // 2. POPULAR MENU (Hapus See All & Ambil 3 Produk)
          const Text(
            "Popular Menu",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Stream khusus untuk Popular Menu
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(Product.collectionName)
                .limit(3) // Ambil 3 data saja
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Belum ada menu populer"));
              }
              final docs = snapshot.data!.docs;
              return Column(
                children: docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final productObj = Product.fromJson(data);
                  return _buildPopularCard(productObj);
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 25),

          // 3. Section Kue
          _buildSectionHeader("Kue", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const KuePage()));
          }),
          const SizedBox(height: 10),
          _buildProductStream(Product.collectionName),

          const SizedBox(height: 25),

          // 4. Section Hampers
          _buildSectionHeader("Hampers", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HampersPage()));
          }),
          const SizedBox(height: 10),
          _buildProductStream(Hampers.collectionName),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // Desain Kartu Popular Menu
  Widget _buildPopularCard(Product product) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailProductPage(product: product)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 5,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.stars, color: Colors.orange, size: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text("Best Seller Product",
                      style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
            Text(
              "Rp${product.price}",
              style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  // Stream untuk List Horizontal
  Widget _buildProductStream(String collection) {
    return SizedBox(
      height: 230,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(collection)
            .orderBy('created_at', descending: true)
            .limit(5)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const SizedBox();
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return const SizedBox();

          final docs = snapshot.data!.docs;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final productObj = Product.fromJson(data);
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 160,
                  child: ProductCardCustomer(
                    product: productObj,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailProductPage(product: productObj))),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: onTap,
          child: Text("See All >",
              style: TextStyle(
                  color: Colors.grey[500], fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
          color: isActive ? Colors.pink : Colors.grey[300],
          shape: BoxShape.circle),
    );
  }

  Widget _buildImageSlider(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      onTap: (index) {
        if (index == 1)
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CustomerCartPage()));
        if (index == 2)
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CustomerReceiptPage()));
        if (index == 3)
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CustomerDeliveryPage()));
        if (index == 4)
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CustomerFinishedOrderPage()));
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale), label: "To Paid"),
        BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining), label: "Delivery"),
        BottomNavigationBarItem(
            icon: Icon(Icons.check_circle), label: "Finished"),
      ],
    );
  }
}
