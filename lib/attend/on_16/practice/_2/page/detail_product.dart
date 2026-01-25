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

class DetailProductPage extends StatefulWidget {
  final Product product;

  const DetailProductPage({
    super.key,
    required this.product,
  });

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  String? userId;
  int quantity = 1;
  bool _isLoadingCart = false;
  bool _isLoadingBuyNow = false;

  @override
  void initState() {
    super.initState();
    // JANGAN panggil _checkSession di sini agar halaman bisa terbuka bebas
  }

  // --- FUNGSI PAGAR LOGIN (Internal) ---
  Future<bool> _ensureLoggedIn() async {
    bool isLogin = await SessionManager.isUserLoggedIn();
    if (!isLogin) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Silakan login untuk melanjutkan belanja")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return false;
    }
    // Jika sudah login, update userId-nya
    userId = await SessionManager.getUserIdFuture();
    return true;
  }

  void _incrementQuantity() => setState(() => quantity++);
  void _decrementQuantity() => setState(() {
        if (quantity > 1) quantity--;
      });

  // --- LOGIC ADD TO CART ---
  Future<void> _handleAddToCart(int currentTotalPrice) async {
    // 1. Cek Login Dulu
    if (await _ensureLoggedIn()) {
      _executeAddToCart(currentTotalPrice);
    }
  }

  Future<void> _executeAddToCart(int currentTotalPrice) async {
    setState(() => _isLoadingCart = true);
    try {
      DocumentReference cartRef =
          FirebaseFirestore.instance.collection(Cart.collectionName).doc();
      ProductQuantity item = ProductQuantity(
        productId: widget.product.id,
        quantity: quantity.toString(),
      );
      Cart newCart = Cart(
        id: cartRef.id,
        userId: userId ?? "",
        productCollection: [item],
        createdAt: DateTime.now().toString(),
        cartType: "product",
      );
      await cartRef.set(newCart.toJson());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text("Berhasil masuk keranjang!")),
        );
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      if (mounted) setState(() => _isLoadingCart = false);
    }
  }

  // --- LOGIC BELI SEKARANG ---
  Future<void> _handleBuyNow(int currentTotalPrice) async {
    // 1. Cek Login Dulu
    if (await _ensureLoggedIn()) {
      _executeBuyNow(currentTotalPrice);
    }
  }

  Future<void> _executeBuyNow(int currentTotalPrice) async {
    setState(() => _isLoadingBuyNow = true);
    try {
      DocumentReference receiptRef =
          FirebaseFirestore.instance.collection(Receipt.collectionName).doc();
      List<ProductQuantityDetail> productsToBuy = [
        ProductQuantityDetail(
            product: widget.product, quantity: quantity.toString())
      ];
      Receipt newReceipt = Receipt(
        id: receiptRef.id,
        userId: userId ?? "",
        productReceiptCollection: productsToBuy,
        hampersReceiptCollection: [],
        totalPrice: currentTotalPrice.toString(),
        isPaid: false,
        createdAt: DateTime.now().toString(),
        requestReceiptAlreadyPaid: false,
      );
      await receiptRef.set(newReceipt.toJson());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text("Pesanan berhasil dibuat!")),
        );
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      if (mounted) setState(() => _isLoadingBuyNow = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = widget.product.price * quantity;
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
                  _buildProductHeader(),
                  _buildProductInfo(),
                ],
              ),
            ),
          ),
          _buildBottomAction(context, totalPrice),
        ],
      ),
    );
  }

  Widget _buildProductHeader() {
    return Container(
      height: 350,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(
          widget.product.image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.fastfood, size: 100, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.star, color: Colors.orange, size: 20),
              Text(" 4.8",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 15),
          Text(widget.product.name,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(widget.product.description,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 15),
          Text("Rp.${widget.product.price}.00",
              style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, int currentTotalPrice) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        color: Color(0xFFFDE9D9),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Rp.$currentTotalPrice",
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFF131121),
                    borderRadius: BorderRadius.circular(30)),
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
                      onTap: () => _handleAddToCart(currentTotalPrice),
                      isLoading: _isLoadingCart)),
              const SizedBox(width: 15),
              Expanded(
                  child: _buildButton(
                      "BELI SEKARANG", Colors.pink, Colors.white,
                      onTap: () => _handleBuyNow(currentTotalPrice),
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
            color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildButton(String label, Color bgColor, Color textColor,
      {required VoidCallback onTap, bool isLoading = false}) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
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
                  color: Colors.white, strokeWidth: 2))
          : Text(label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
    );
  }
}
