import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/hampers.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_cart.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_delivery.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_finished_order.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_receipt.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/detail_product.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/profile_dummy.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/user_interface_component/product_card_customer.dart';

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic appbar = AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        // child: const TextField(1
        //   decoration: InputDecoration(
        //     hintText: 'Search',
        //     prefixIcon: Icon(Icons.search, color: Colors.grey),
        //     border: InputBorder.none,
        //     contentPadding: EdgeInsets.symmetric(vertical: 10),
        //   ),
        // ),
        child: Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Customer Home",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ]),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(key: key),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(30),
              child: CircleAvatar(
                backgroundColor: Colors.black.withAlpha(50),
                child: Icon(Icons.person_rounded),
              )),
        )
      ],
    );

    final dynamic body = ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Banner Placeholder

        Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(height: 10),
        // Dot Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDot(false),
            _buildDot(false),
            _buildDot(false),
          ],
        ),
        const SizedBox(height: 20),

        // Section Popular Meal
        _buildSectionHeader("Popular Meal Menu"),
        const SizedBox(height: 10),
        _buildPopularCard(),
        const SizedBox(height: 20),

        // Section Kue
        _buildSectionHeader("Kue"),
        const SizedBox(height: 10),
        SizedBox(
          height: 240,
          child: StreamBuilder<QuerySnapshot>(
            // 1. Query ke Firestore
            stream: FirebaseFirestore.instance
                .collection(Product.collectionName)
                .orderBy('created_at',
                    descending:
                        true) // Urutkan dari yang terbaru (Z-A / Waktu besar ke kecil)
                .limit(5) // Batasi hanya 5 dokumen
                .snapshots(),
            builder: (context, snapshot) {
              // A. Jika sedang loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // B. Jika ada Error
              if (snapshot.hasError) {
                return const Center(child: Text("Terjadi kesalahan"));
              }

              // C. Jika Data Kosong
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Belum ada produk"));
              }

              // D. Jika Data Ada
              final documents = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: documents.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // Ambil data per dokumen
                  final data = documents[index].data() as Map<String, dynamic>;
                  return ProductCardCustomer(
                      onTap: () {
                        // Contoh penggunaan di halaman Home
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailProductPage(
                              product: Product.fromJson(data),
                            ),
                          ),
                        );
                      },
                      product: Product.fromJson(data));
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        _buildSectionHeader("Hampers"),
        const SizedBox(height: 10),
        SizedBox(
          height: 240,
          child: StreamBuilder<QuerySnapshot>(
            // 1. Query ke Firestore
            stream: FirebaseFirestore.instance
                .collection(Hampers.collectionName)
                .orderBy('created_at',
                    descending:
                        true) // Urutkan dari yang terbaru (Z-A / Waktu besar ke kecil)
                .limit(5) // Batasi hanya 5 dokumen
                .snapshots(),
            builder: (context, snapshot) {
              // A. Jika sedang loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // B. Jika ada Error
              if (snapshot.hasError) {
                return const Center(child: Text("Terjadi kesalahan"));
              }

              // C. Jika Data Kosong
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Belum ada produk"));
              }

              // D. Jika Data Ada
              final documents = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: documents.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // Ambil data per dokumen
                  final data = documents[index].data() as Map<String, dynamic>;
                  return ProductCardCustomer(
                      onTap: () {
                        // Contoh penggunaan di halaman Home
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailProductPage(
                              product: Product.fromJson(data),
                            ),
                          ),
                        );
                      },
                      product: Product.fromJson(data));
                },
              );
            },
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar,
      body: body,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.red : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text("See All >",
            style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildPopularCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
                color: Colors.grey[200],
                height: 70,
                width: 70), // Ganti dengan Image.asset
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pepper Pizza",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("5kg box of Pizza",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Text("\$15",
              style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildBottomNav(context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, "Home", true, onTap: () {}),
          _navItem(Icons.shopping_cart_outlined, "Cart", false, badge: "0",
              onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerCartPage(key: key),
              ),
            );
          }),
          _navItem(Icons.point_of_sale, "To Paid", false, badge: "0",
              onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerReceiptPage(key: key),
              ),
            );
          }),
          _navItem(Icons.delivery_dining, "On Delivery", false, badge: "0",
              onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerDeliveryPage(key: key),
              ),
            );
          }),
          _navItem(Icons.check_circle, "Finished", false, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerFinishedOrderPage(key: key),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive,
      {String? badge, onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.pink[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Icon(icon, color: isActive ? Colors.pink : Colors.grey),
                if (badge != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      constraints:
                          const BoxConstraints(minWidth: 12, minHeight: 12),
                      child: Text(badge,
                          style:
                              const TextStyle(color: Colors.white, fontSize: 8),
                          textAlign: TextAlign.center),
                    ),
                  )
              ],
            ),
            if (isActive) const SizedBox(width: 8),
            if (isActive)
              Text(label,
                  style: const TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
