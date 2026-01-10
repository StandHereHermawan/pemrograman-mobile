import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/styles/text_style_default.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/user_interface_component/product_card_dummy.dart';

class WidgetProductListDummy extends StatelessWidget {
  const WidgetProductListDummy({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        // Item 1
        ProductCardDummy(
          title: "Lorem ipsum dolor sit amet, consectetur",
          author: "Fran Smith",
          labels: ["LABEL 1"],
          commentCount: 5,
        ),
        Divider(), // Garis pemisah antar item
        // Item 2
        ProductCardDummy(
          title: "Vivamus fermentum elementum nunc",
          author: "John Atler",
          labels: ["LABEL 2", "LABEL 3"],
          commentCount: 0,
        ),
        Divider(),
        // Item 3
        ProductCardDummy(
          title: "Quisque ex lectus, consequat gravida dolor",
          author: "Marie Sanders",
          labels: ["LABEL 3", "LABEL 1"],
          commentCount: 0,
        ),
        Divider(),
        ProductCardDummy(
          title: "Quisque ex lectus, consequat gravida doloren",
          author: "Marie Sanders",
          labels: ["LABEL 3", "LABEL 2"],
          commentCount: 0,
        ),
        Divider(),
        ProductCard(
            product: Product(
                id: "1",
                name: "Martabak Telor",
                description: "Martabak Telor, Telornya 1",
                price: 20000,
                createdAt: "2025"))
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[700], // Warna background label gelap
        borderRadius: BorderRadius.circular(4), // Sudut sedikit melengkung
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Kiri: Placeholder Gambar (Thumbnail)
          Container(
            width: 150,
            height: 150,
            color: Colors.grey[300], // Warna abu-abu placeholder
            child: const Icon(
              Icons.landscape, // Icon gunung seperti di gambar
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 16), // Jarak antara gambar dan teks

          // Bagian Kanan: Konten Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Artikel
                Text(
                  product.name,
                  style: TextStyleDefault.defaultBlack16SizeTextStyle(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Penulis (by Author)
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),

                // Bagian Komentar
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.create, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          product.createdAt,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    // Baris Label (Tags)
                    Wrap(
                      spacing: 8.0, // Jarak horizontal antar label
                      runSpacing:
                          4.0, // Jarak vertical jika label turun ke bawah
                      children: [_buildLabel("Harga Rp.${product.price}")],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
