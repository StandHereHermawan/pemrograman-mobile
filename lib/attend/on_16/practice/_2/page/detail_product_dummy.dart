import 'package:flutter/material.dart';

// 1. Ubah menjadi StatefulWidget
class DetailProductPageDummy extends StatefulWidget {
  const DetailProductPageDummy({super.key});

  @override
  State<DetailProductPageDummy> createState() => _DetailProductPageDummyState();
}

class _DetailProductPageDummyState extends State<DetailProductPageDummy> {
  // 2. Inisialisasi State Quantity (Default 1)
  int quantity = 1;
  // Asumsi harga dasar per item (misal $16 agar total awal sesuai gambar $32 kalau qty 2, atau sesuaikan)
  int basePrice = 16;

  // Fungsi Tambah
  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  // Fungsi Kurang
  void _decrementQuantity() {
    setState(() {
      // 3. Validasi: Hanya kurangi jika quantity lebih dari 0 (atau 1)
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hitung Total Harga dinamis
    int totalPrice = basePrice * quantity;

    final dynamic appbar = AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
        )
      ],
      leading: MaterialButton(
          onPressed: () {},
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.black, size: 20))),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bagian Gambar & Header Ikon
                  Stack(
                    children: [
                      Container(
                        height: 400,
                        width: double.infinity,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      const Positioned(
                        top: 50,
                        right: 30,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                        ),
                      ),
                    ],
                  ),

                  // Informasi Produk
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 20),
                            Text(" 3.8",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Chicken burger",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "100 gr chicken + tomato + cheese Lettuce",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          children: [
                            Text(
                              "\$ 16", // Saya sesuaikan harga satuan agar match logika total
                              style: TextStyle(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                            Text(".00",
                                style: TextStyle(
                                    color: Colors.pink, fontSize: 14)),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar (Price & Buttons)
          _buildBottomAction(context, totalPrice),
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
              // Menampilkan Total Harga sesuai Quantity
              Text(
                "\$$currentTotalPrice",
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
                    // Tombol Minus
                    _qtyBtn(Icons.remove, _decrementQuantity),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      // Menampilkan State Quantity
                      child: Text("$quantity",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                    ),

                    // Tombol Plus
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
                child: _buildButton("KERANJANG", Colors.pink, Colors.white),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildButton("BELI SEKARANG", Colors.pink, Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Update widget tombol qty agar bisa menerima fungsi onTap
  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, // Menjalankan fungsi saat diklik
      borderRadius: BorderRadius.circular(20),
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
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(
            vertical: 25), // Sedikit dikecilkan agar muat
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18), // Font disesuaikan
      ),
    );
  }
}
