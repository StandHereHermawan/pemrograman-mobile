import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';

class ProductCardCustomer extends StatelessWidget {
  final Product product;
  final String id;
  final String rate;
  final VoidCallback onTap;

  const ProductCardCustomer({
    super.key,
    this.product = const Product(
      id: "Not Have An Id",
      name: "Not Have A Name",
      price: 0,
      description: "No Description Available",
    ),
    this.id = "Not Have An Id",
    this.rate = "4.8",
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String price = "Rp${product.price}";

    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.grey[200]!),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.pink.withAlpha(10),
          highlightColor: Colors.pink.withAlpha(50),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Bagian Atas (Rating) ---
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rate,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // --- Gambar Produk (VERSI CIRCLE) ---
                Center(
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      shape: BoxShape.circle, // Membuat container jadi bulat
                      border: Border.all(
                          color: Colors.grey[100]!), // Garis tepi tipis
                    ),
                    child: ClipOval(
                      // Memotong gambar agar mengikuti bentuk bulat
                      child: Image.asset(
                        product.image,
                        fit: BoxFit.cover, // Supaya gambar memenuhi lingkaran
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.stars,
                              color: Colors.orange, size: 40);
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // --- Nama Produk ---
                Text(
                  product.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
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

                // --- Harga & Tombol Cart ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        price,
                        style: const TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.pink,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
