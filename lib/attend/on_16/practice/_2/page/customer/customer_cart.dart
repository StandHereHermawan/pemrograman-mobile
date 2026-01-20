import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/helper/product_quantity.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/helper/product_quantity_detail.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/cart.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/receipt.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_delivery.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_finished_order.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_home.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_receipt.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/detail_product.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/login.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/user_interface_component/appbar.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/user_interface_component/cart_card.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/user_interface_component/product_card_customer.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/util/session_manager.dart';

class CustomerCartPage extends StatefulWidget {
  const CustomerCartPage({super.key});

  @override
  State<CustomerCartPage> createState() => _CustomerCartPageState();
}

class _CustomerCartPageState extends State<CustomerCartPage> {
  // Variable State
  String? userId;
  bool isLoading = true; // Indikator loading saat ambil sesi

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  @override
  void dispose() {
    // Jangan lupa dispose controller agar memori tidak bocor
    super.dispose();
  }

  // --- LOGIKA UTAMA CEK SESI ---
  Future<void> _checkSession() async {
    // 1. Cek Login Status
    bool isLogin = await SessionManager.isUserLoggedIn();

    if (!mounted) return; // Cek apakah widget masih ada

    if (!isLogin) {
      _redirectToLogin();
      return;
    }

    // 2. Ambil User ID
    String? id = await SessionManager.getUserIdFuture();

    if (!mounted) return;

    if (id == null || id.isEmpty) {
      _redirectToLogin();
    } else {
      // 3. Simpan ke State dan Re-build UI
      setState(() {
        userId = id;
        isLoading = false; // Loading selesai
      });
    }
  }

  void _redirectToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan Loading Screen jika userId belum didapat
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // --- UI UTAMA SETELAH USER ID DIDAPAT ---

    final dynamic appbar = CustomAppBar(title: "Customer Cart");

    final dynamic body = ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // --- Section Kue (Product) ---
        _buildSectionHeader("Kue"),
        const SizedBox(height: 10),
        SizedBox(
          height: 480,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(Cart.collectionName)
                .where('cart_type', isEqualTo: "product")
                .where('user_id',
                    isEqualTo: userId) // Menggunakan userId dari state
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                log(snapshot.error.toString());
                return const Center(child: Text("Terjadi kesalahan"));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Belum ada produk"));
              }

              final documents = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: documents.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = documents[index].data() as Map<String, dynamic>;
                  log(data.toString());
                  return CartCard(
                    onTap: () {
                      // Logic onTap
                    },
                    onDelete: () async {
                      FirebaseFirestore.instance
                          .collection(Cart.collectionName) // Nama Collection
                          .doc(Cart.fromJson(data).id) // ID Dokumen Spesifik
                          .delete();
                      // Tambahkan logika hapus di sini
                    },
                    onPaid: () async {
                      try {
                        List<ProductQuantityDetail> productsToBuy =
                            <ProductQuantityDetail>[];

                        DocumentReference receiptRef = FirebaseFirestore
                            .instance
                            .collection(Receipt.collectionName)
                            .doc(); // 1. Buat Referensi Dokumen Baru di Collection 'receipts'

                        // 2. Siapkan Data
                        // Karena struktur Receipt meminta List<Product>, kita bungkus produk saat ini ke dalam List.
                        // Catatan: Karena model Product tidak menyimpan quantity,
                        // kita hanya menyimpan info produknya dan total harga akhirnya.
                        int? currentTotalPrice = 0;
                        int? quantity = 0;

                        // --- PERBAIKAN DI SINI ---
                        // Jangan pakai .forEach, pakai variabel penampung dulu lalu loop manual
                        List<ProductQuantity> itemsInCart =
                            Cart.fromJson(data).productCollection;

                        for (ProductQuantity productQuantity in itemsInCart) {
                          // 1. Ambil data produk dari Firestore (Ditunggu sampai selesai)
                          DocumentSnapshot docSnapshot = await FirebaseFirestore
                              .instance
                              .collection(Product.collectionName)
                              .doc(productQuantity.productId)
                              .get();

                          if (docSnapshot.exists) {
                            Map<String, dynamic> jsonObject =
                                docSnapshot.data() as Map<String, dynamic>;

                            Product product = Product.fromJson(jsonObject);

                            // 2. Masukkan ke list lokal
                            productsToBuy.add(ProductQuantityDetail(
                                product: product,
                                quantity: productQuantity.quantity));

                            log("Products to buy block .for in : ${productsToBuy.toString()}");
                            log("Product to be receipt block .for in: ${product.toString()}");

                            currentTotalPrice = (currentTotalPrice! +
                                product.price *
                                    int.parse(productQuantity.quantity));
                            log("Current price in block .for in : ${currentTotalPrice.toString()}");

                            quantity = (quantity! +
                                int.parse(productQuantity.quantity));
                            log("Current quantity in block .for in : ${quantity.toString()}");

                            log("Berhasil ambil: ${product.name} - Harga sementara: $currentTotalPrice");
                          }
                        }
                        // -------------------------

                        log("Products to buy block anonymous: ${productsToBuy.toString()}");
                        log("Current quantity in block anonymous : ${quantity.toString()}");

                        // 3. Buat Objek Receipt
                        Receipt newReceipt = Receipt(
                          id: receiptRef.id,
                          userId: userId ??
                              "", // Ganti dengan ID User login asli nanti
                          productReceiptCollection: productsToBuy,
                          hampersReceiptCollection: [], // Kosongkan karena ini beli produk satuan
                          totalPrice: currentTotalPrice
                              .toString(), // Konversi int ke String sesuai model
                          isPaid: false, // Default belum bayar
                          createdAt: DateTime.now().toString(),
                          requestReceiptAlreadyPaid: false,
                        );
                        log("New receipt: ${newReceipt.toString()}");

                        // 4. Kirim ke Firestore (.set)
                        receiptRef.set(newReceipt.toJson());

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("Pesanan berhasil dibuat!"),
                              duration: Duration(seconds: 3),
                            ),
                          );

                          // Opsional: Pindah ke halaman pembayaran atau history
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => CustomerReceiptPage()));
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Gagal membuat pesanan: $e"),
                            ),
                          );
                        }
                      } finally {}
                      // Tambahkan logika bayar di sini
                    },
                    cart: Cart.fromJson(data),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        // --- Section Hampers ---
        _buildSectionHeader("Hampers"),
        const SizedBox(height: 10),
        SizedBox(
          height: 240,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(Cart.collectionName)
                .where('cart_type', isEqualTo: "hampers")
                .where('user_id',
                    isEqualTo: userId) // Menggunakan userId dari state
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Terjadi kesalahan"));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text("Belum ada Keranjang isi Hampers"));
              }

              final documents = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: documents.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = documents[index].data() as Map<String, dynamic>;
                  // Note: Pastikan model Hampers/Product sesuai dengan CartType
                  return ProductCardCustomer(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailProductPage(
                            product: Product.fromJson(data),
                          ),
                        ),
                      );
                    },
                    product: Product.fromJson(data),
                  );
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

  Widget _buildBottomNav(BuildContext context) {
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
          _navItem(Icons.home, "Home", false, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerHomePage(key: widget.key),
              ),
            );
          }),
          _navItem(Icons.shopping_cart_outlined, "Cart", true,
              badge: "0", onTap: () {}),
          _navItem(Icons.point_of_sale, "To Paid", false, badge: "0",
              onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerReceiptPage(key: widget.key),
              ),
            );
          }),
          _navItem(Icons.delivery_dining, "On Delivery", false, badge: "0",
              onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerDeliveryPage(key: widget.key),
              ),
            );
          }),
          _navItem(Icons.check_circle, "Finished", false, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CustomerFinishedOrderPage(key: widget.key),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive,
      {String? badge, VoidCallback? onTap}) {
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
