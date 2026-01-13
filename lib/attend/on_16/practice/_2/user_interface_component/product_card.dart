import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';

class ProductCardPrompted extends StatelessWidget {
  // Mendefinisikan properti sebagai variabel final
  final Product product;
  final String id;
  final String rate;
  final VoidCallback onTap;

  // Constructor dengan Named Parameters dan Default Values
  const ProductCardPrompted(
      {super.key,
      this.product = const Product(
        id: "Not Have An Id",
        name: "Not Have A Name",
        price: 0,
        description: "100 gr chicken + tomato + cheese Lettuce",
      ),
      this.id = "Not Have An Id",
      this.rate = "4.8",
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    String price = "Rp.${product.price}";
    return Container(
      width: 160,
      margin:
          const EdgeInsets.symmetric(horizontal: 4), // margin left & right 4

      // 2. Gunakan Material untuk menampung Style (Border, Radius, Color)
      // Ini menggantikan 'decoration: BoxDecoration'
      child: Material(
        color: Colors.white, // Warna background kartu
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.grey[200]!), // Border warna abu
        ),
        clipBehavior:
            Clip.antiAlias, // Agar efek ripple tidak keluar dari radius

        // 3. InkWell memberikan efek sentuhan (Ripple) dan fungsi OnTap
        child: InkWell(
          onTap: () {}, // Fungsi yang dijalankan saat diklik
          splashColor: Colors.pink.withAlpha(10), // Warna cipratan (opsional)
          highlightColor: Colors.pink.withAlpha(50), // Warna saat ditekan

          // 4. Padding dipindah ke dalam InkWell agar area klik mencakup padding
          child: Padding(
            padding: const EdgeInsets.all(12), // Padding luar (container lama)
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Padding dalam (child lama)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Bagian Atas (Rating) ---
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      Text(
                        rate,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  // --- Gambar Produk ---
                  const Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFE0E0E0),
                      // backgroundImage: NetworkImage(product.imageUrl), // Jika ada gambar
                    ),
                  ),

                  const SizedBox(height: 10),

                  // --- Nama Produk ---
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // --- Deskripsi ---
                  Text(
                    product.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // --- Harga & Tombol Cart Kecil ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Tombol icon kecil ini bisa dibuat InkWell terpisah
                      // jika ingin fungsinya beda dengan klik kartu utama
                      Material(
                        color: Colors.white, // Warna background kartu
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                              color: Colors.grey[200]!), // Border warna abu
                        ),
                        clipBehavior: Clip
                            .antiAlias, // Agar efek ripple tidak keluar dari radius

                        // 3. InkWell memberikan efek sentuhan (Ripple) dan fungsi OnTap
                        child: InkWell(
                          onTap: onTap, // Fungsi yang dijalankan saat diklik
                          splashColor: Colors.grey
                              .withAlpha(10), // Warna cipratan (opsional)
                          highlightColor:
                              Colors.grey.withAlpha(50), // Warna saat ditekan
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                              color: Colors.pink,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.shopping_cart,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
