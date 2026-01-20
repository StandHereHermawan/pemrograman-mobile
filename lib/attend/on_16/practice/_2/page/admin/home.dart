import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/hampers.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/admin/add_hampers.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/admin/add_product.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/admin/admin_delivery.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/admin/admin_finished_order.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/admin/admin_receipt.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/detail_product.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/admin/edit_product.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/user_interface_component/appbar.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/user_interface_component/product_card_admin.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic appbar = CustomAppBar(
      title: "Admin Home",
      key: key,
    );

    final dynamic body = ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Section Kue
        _buildSectionHeader("Kue", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductPage(key: key),
            ),
          );
        }),
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
                  return ProductCardAdmin(
                      onTap: () {
                        // Contoh penggunaan di halaman Home
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProductPage(
                              product: Product.fromJson(data),
                              key: key,
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

        // Section Hampers
        _buildSectionHeader("Hampers", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddHampersPage(key: key),
            ),
          );
        }),
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
                  return ProductCardAdmin(
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

  Widget _buildSectionHeader(String title, onTap, {bool buttonActive = true}) {
    dynamic buttonNavigation = Container();
    dynamic buttonSeeAllItems = Container();
    if (buttonActive) {
      buttonNavigation = InkWell(
        onTap: onTap, // Fungsi yang dijalankan saat diklik
        hoverColor: Colors.pink.withAlpha(10),
        splashColor: Colors.pink.withAlpha(50), // Warna cipratan (opsional)
        highlightColor: Colors.grey.withAlpha(50), // Warna saat ditekan
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 5,
            children: [
              Text("Add $title",
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_circle_outline,
                    color: Colors.white, size: 20),
              )
            ],
          ),
        ),
      );
      buttonSeeAllItems = const Text("See All >",
          style: TextStyle(color: Colors.grey, fontSize: 12));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        buttonNavigation,
        buttonSeeAllItems
      ],
    );
  }

  // ignore: unused_element
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
        color: Colors.grey.withAlpha(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, "Home", true, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminHomePage(key: key),
              ),
            );
          }),
          _navItem(Icons.point_of_sale, "To Paid", false, badge: "0",
              onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminReceiptPage(key: key),
              ),
            );
          }),
          _navItem(Icons.delivery_dining, "To Deliver", false, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminDeliveryPage(key: key),
              ),
            );
          }, badge: "0"),
          _navItem(Icons.check_circle, "Finished", false, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminFinishedOrderPage(key: key),
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
      onTap: onTap ?? () {},
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
