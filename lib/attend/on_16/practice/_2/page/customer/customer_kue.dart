import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/detail_product.dart';

class KuePage extends StatelessWidget {
  const KuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Katalog Kue",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(Product.collectionName)
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada koleksi kue."));
          }

          final documents = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              // KUNCI: 0.82 agar kartu pas, tidak melar ke bawah dan tidak bantet
              childAspectRatio: 0.82,
            ),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;
              final product = Product.fromJson(data);

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailProductPage(product: product),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 1. Gambar Produk (Area Circle)
                      Expanded(
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 12),
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                              // Memberi sedikit border supaya lingkaran gambar terlihat jelas
                              border: Border.all(
                                  color: Colors.grey.shade200, width: 1),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                product
                                    .image, // Mengambil path otomatis dari model
                                fit: BoxFit
                                    .cover, // Supaya gambar penuh di dalam lingkaran
                                errorBuilder: (context, error, stackTrace) {
                                  // Backup kalau path gambar tidak ketemu di assets
                                  return const Icon(Icons.cake,
                                      color: Colors.grey, size: 40);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 2. Konten Informasi (Rapat & Lega)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Rating dummy atau dari data jika ada
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.orange, size: 14),
                                Text(" ${product.rating ?? '4.8'}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Nama Kue
                            Text(
                              product.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // Deskripsi Singkat
                            const SizedBox(height: 2),
                            Text(
                              product.description,
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // Jarak ke Harga (Tidak terlalu jauh)
                            const SizedBox(height: 14),

                            // Harga & Tombol Beli
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Rp.${product.price}",
                                    style: const TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                      color: Colors.pink,
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.shopping_cart,
                                      color: Colors.white, size: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
