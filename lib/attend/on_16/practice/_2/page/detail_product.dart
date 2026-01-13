import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';

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
  int quantity = 1;

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
  Widget build(BuildContext context) {
    // 2. Gunakan widget.product.price sebagai harga dasar
    int totalPrice = widget.product.price * quantity;
    String price = "Rp.${widget.product.price}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder Gambar
                  Container(
                    height: 350,
                    width: double.infinity,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.fastfood, size: 100, color: Colors.white),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 20),
                            Text(" 4.8", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        // 3. Menampilkan Nama Produk secara Dinamis
                        Text(
                          widget.product.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        // 4. Menampilkan Deskripsi Produk secara Dinamis
                        Text(
                          widget.product.description,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
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
                            const Text(".00", style: TextStyle(color: Colors.pink, fontSize: 14)),
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
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                      child: Text("$quantity", style: const TextStyle(color: Colors.white, fontSize: 18)),
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
              Expanded(child: _buildButton("KERANJANG", Colors.pink, Colors.white)),
              const SizedBox(width: 15),
              Expanded(child: _buildButton("BELI SEKARANG", Colors.pink, Colors.white)),
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

  Widget _buildButton(String label, Color bgColor, Color textColor) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
    );
  }
}