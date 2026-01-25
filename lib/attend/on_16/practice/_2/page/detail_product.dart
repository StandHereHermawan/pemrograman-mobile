import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/cart.dart';

import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/helper/product_quantity.dart';

import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/helper/product_quantity_detail.dart';

import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';

import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/receipt.dart';

import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/login.dart';

import 'package:pemprograman_mobile/attend/on_16/practice/_2/user_interface_component/appbar.dart';

import 'package:pemprograman_mobile/attend/on_16/practice/_2/util/session_manager.dart';

// import 'package:pemprograman_mobile/attend/on_16/practice/_2/util/session_manager.dart';

// 1. Tambahkan parameter Product pada Constructor

class DetailProductPage extends StatefulWidget {
  final Product product; // Data produk yang dilempar dari halaman sebelumnya

  const DetailProductPage({
    super.key,
    required this.product, // Syarat parameter produk
  });

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  String? userId;

  int quantity = 1;

  bool _isLoadingCart = false; // Untuk indikator loading tombol

  bool _isLoadingBuyNow = false; // Untuk indikator loading tombol

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
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
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _checkSession();
  }

  void _redirectToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // --- LOGIC ADD TO CART ---

  Future<void> _addToCart(int currentTotalPrice) async {
    setState(() {
      _isLoadingCart = true;
    });

    try {
      // 1. Buat Referensi Dokumen Baru di Collection 'carts'

      DocumentReference cartRef = FirebaseFirestore.instance
          .collection(Cart.collectionName)
          .doc(); // Biarkan Firestore generate ID unik otomatis

      // 2. Siapkan Objek ProductQuantity (Item yang mau dibeli)

      ProductQuantity item = ProductQuantity(
        productId: widget.product.id,
        quantity: quantity.toString(),
      );

      // 3. Siapkan Objek Cart (Bungkus item tadi ke dalam Cart)

      Cart newCart = Cart(
        id: cartRef.id, // Pakai ID dari referensi di atas

        userId: userId ?? "", // Ganti dengan ID User login nanti

        productCollection: [item], // Masukkan item ke dalam list

        createdAt: DateTime.now().toString(),

        cartType: "product",
      );

      // 4. Kirim ke Firestore (.set)

      await cartRef.set(newCart.toJson());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Berhasil masuk keranjang!"),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Gagal: $e"),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCart = false;
        });
      }
    }
  }

  // -------------------------

  // --- LOGIC ADD TO RECEIPT ---

  // --- LOGIC BELI SEKARANG (CREATE RECEIPT) ---

  Future<void> _addToReceipt(int currentTotalPrice, int quantity) async {
    setState(() {
      _isLoadingBuyNow = true;
    });

    try {
      DocumentReference receiptRef = FirebaseFirestore.instance
          .collection(Receipt.collectionName)
          .doc(); // 1. Buat Referensi Dokumen Baru di Collection 'receipts'

      // 2. Siapkan Data

      // Karena struktur Receipt meminta List<Product>, kita bungkus produk saat ini ke dalam List.

      // Catatan: Karena model Product tidak menyimpan quantity,

      // kita hanya menyimpan info produknya dan total harga akhirnya.

      List<ProductQuantityDetail> productsToBuy = [
        ProductQuantityDetail(
            product: widget.product, quantity: quantity.toString())
      ];

      // 3. Buat Objek Receipt

      Receipt newReceipt = Receipt(
        id: receiptRef.id,

        userId: userId ?? "", // Ganti dengan ID User login asli nanti

        productReceiptCollection: productsToBuy,

        hampersReceiptCollection: [], // Kosongkan karena ini beli produk satuan

        totalPrice:
            currentTotalPrice.toString(), // Konversi int ke String sesuai model

        isPaid: false, // Default belum bayar

        createdAt: DateTime.now().toString(),

        requestReceiptAlreadyPaid: false,
      );

      // 4. Kirim ke Firestore (.set)

      await receiptRef.set(newReceipt.toJson());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Pesanan berhasil dibuat!"),
            duration: Duration(seconds: 2),
          ),
        );

        // Opsional: Pindah ke halaman pembayaran atau history

        // Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentPage()));
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingBuyNow = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 2. Gunakan widget.product.price sebagai harga dasar

    int totalPrice = widget.product.price * quantity;

    String price = "Rp.${widget.product.price}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Detail Product"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder Gambar

                  // --- GANTI BLOK INI ---

                  Container(
                    height: 350,
                    width: double.infinity,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      // Tambahkan ClipRRect agar gambar ikut melengkung di pojoknya

                      borderRadius: BorderRadius.circular(30),

                      child: Image.asset(
                        widget
                            .product.image, // Mengambil path gambar dari model

                        fit: BoxFit
                            .cover, // Menyesuaikan gambar agar menutupi box

                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.fastfood,
                              size: 100, color: Colors.white);
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 20),
                            Text(" 4.8",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // 3. Menampilkan Nama Produk secara Dinamis

                        Text(
                          widget.product.name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 8),

                        // 4. Menampilkan Deskripsi Produk secara Dinamis

                        Text(
                          widget.product.description,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Text(
                              price,
                              style: const TextStyle(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                            const Text(".00",
                                style: TextStyle(
                                    color: Colors.pink, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomAction(context, totalPrice),
        ],
      ),
    );
  }

  // ... (Metode _buildBottomAction, _qtyBtn, dan _buildButton tetap sama seperti sebelumnya)

  Widget _buildBottomAction(BuildContext context, int currentTotalPrice) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        color: Color(0xFFFDE9D9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rp\.$currentTotalPrice",
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF131121),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _qtyBtn(Icons.remove, _decrementQuantity),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text("$quantity",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                    ),
                    _qtyBtn(Icons.add, _incrementQuantity),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _buildButton("KERANJANG", Colors.pink, Colors.white,
                      onTap: () => _addToCart(currentTotalPrice),
                      isLoading: _isLoadingCart)),
              const SizedBox(width: 15),
              Expanded(
                  child: _buildButton(
                      "BELI SEKARANG", Colors.pink, Colors.white,
                      onTap: () => _addToReceipt(currentTotalPrice, quantity),
                      isLoading: _isLoadingBuyNow)),
            ],
          )
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildButton(String label, Color bgColor, Color textColor,
      {required VoidCallback onTap, bool isLoading = false}) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap, // Disable jika loading

      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),

      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
          : Text(label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
    );
  }
}
