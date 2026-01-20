import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/cart.dart';

class CartCard extends StatelessWidget {
  final Cart cart;
  final VoidCallback onTap;
  final VoidCallback? onDelete; // Opsional: Tambahan aksi delete
  final VoidCallback? onPaid; // Opsional: Tambahan aksi delete

  const CartCard({
    super.key,
    required this.cart,
    required this.onTap,
    this.onDelete,
    this.onPaid,
  });

  @override
  Widget build(BuildContext context) {
    // --- 1. Logic Persiapan Data (Sama seperti CartCard) ---

    // Menghitung jumlah item
    // int totalItems = cart.productCollection.length;

    // Format tanggal (YYYY-MM-DD)
    String dateDisplay = cart.createdAt.length > 10
        ? cart.createdAt.substring(0, 10)
        : cart.createdAt;

    // Format ID pendek
    // String shortId =
    //     cart.id.length > 6 ? "#${cart.id.substring(0, 6)}..." : "#${cart.id}";

    // --- 2. Struktur UI (Style _buildPopularCard) ---
    return Container(
      margin: const EdgeInsets.only(bottom: 15), // Margin antar kartu vertikal
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      // Material & InkWell agar bisa diklik dengan efek ripple
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.pink.withOpacity(0.1),
          highlightColor: Colors.pink.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(12), // Padding container
            child: Row(
              children: [
                // --- A. Bagian Gambar (Kiri) ---
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 70,
                    width: 70,
                    color: Colors.grey[200], // Background abu
                    child: Center(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.grey[500],
                        size: 30,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                // --- B. Bagian Info Teks (Tengah) ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tipe Cart (Product/Hampers)
                      Text(
                        cart.cartType.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // ID Order
                      Text(
                        "Order",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      Text(
                        "cart id: ${cart.id}",
                        style: const TextStyle(
                          color: Colors.grey,
                          // fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),

                      Text(
                      "product id: ${cart.productCollection.first.productId}",
                      style: const TextStyle(
                        color: Colors.grey,
                        // fontWeight: FontWeight.bold,
                        fontSize: 12, // Ukuran font mirip harga
                      ),
                    ),

                      // Tanggal
                      Text(
                        dateDisplay,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // --- C. Bagian Harga/Jumlah & Action (Kanan) ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${cart.totalQuantitiesItem()} Quantities",
                      style: const TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                        fontSize: 16, // Ukuran font mirip harga
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Total Items (Menggantikan posisi Harga $15)
                    // Text(
                    //   "$totalItems Items",
                    //   style: const TextStyle(
                    //     color: Colors.pink,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 12, // Ukuran font mirip harga
                    //   ),
                    // ),
                    // const SizedBox(height: 0),
                  ],
                ),

                const SizedBox(width: 15),

                // --- C. Bagian Harga/Jumlah & Action (Kanan) ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Total Items (Menggantikan posisi Harga $15)

                    if (onPaid != null)
                      InkWell(
                        onTap: onPaid,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.point_of_sale,
                            size: 18,
                            color: Colors.red,
                          ),
                        ),
                      ),

                    const SizedBox(height: 8),

                    // Tombol Delete (Jika ada function onDelete)
                    if (onDelete != null)
                      InkWell(
                        onTap: onDelete,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
