import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/styles/colors.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/styles/text_style_default.dart';

class ProductCardDummy extends StatelessWidget {
  final String title;
  final String author;
  final List<String> labels;
  final int commentCount;

  const ProductCardDummy({
    super.key,
    required this.title,
    required this.author,
    required this.labels,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Kiri: Placeholder Gambar (Thumbnail)
          Container(
            width: 100,
            height: 100,
            color: DefaultColors.quadryColors, // Warna abu-abu placeholder
            child: const Icon(
              Icons.landscape, // Icon gunung seperti di gambar
              color: DefaultColors.secondaryColors,
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
                  title,
                  style: TextStyleDefault.defaultBlack16SizeTextStyle(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Penulis (by Author)
                Text(
                  "by $author",
                  style: TextStyle(
                    fontSize: 14,
                    color: DefaultColors.quadryColors,
                  ),
                ),
                const SizedBox(height: 12),

                // Baris Label (Tags)
                Wrap(
                  spacing: 8.0, // Jarak horizontal antar label
                  runSpacing: 4.0, // Jarak vertical jika label turun ke bawah
                  children: labels.map((label) => _buildLabel(label)).toList(),
                ),
                const SizedBox(height: 12),

                // Bagian Komentar
                Row(
                  children: [
                    Icon(Icons.chat_bubble,
                        size: 16, color: DefaultColors.quadryColors),
                    const SizedBox(width: 6),
                    Text(
                      "$commentCount Comments",
                      style: TextStyle(
                        fontSize: 12,
                        color: DefaultColors.quadryColors,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk membuat kotak Label abu-abu gelap
  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: DefaultColors.quadryColors, // Warna background label gelap
        borderRadius: BorderRadius.circular(4), // Sudut sedikit melengkung
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: DefaultColors.secondaryColors,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
