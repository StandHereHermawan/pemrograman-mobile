import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';

// 1. Tambahkan parameter Product pada Constructor
class EditProductPage extends StatefulWidget {
  final Product product; // Data produk yang dilempar dari halaman sebelumnya

  const EditProductPage({
    super.key,
    required this.product, // Syarat parameter produk
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
// 1. Siapkan Controller untuk menangani input teks
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  bool _isLoading = false; // Indikator loading saat menyimpan

  @override
  void initState() {
    super.initState();
    // 2. Isi nilai awal controller dengan data produk yang ada
    _nameController = TextEditingController(text: widget.product.name);
    _descController = TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
  }

  @override
  void dispose() {
    // Bersihkan controller saat halaman ditutup untuk mencegah memory leak
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    // Validasi sederhana
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan Harga tidak boleh kosong")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // REFERENSI KE DOKUMEN SPESIFIK BERDASARKAN ID
      await FirebaseFirestore.instance
          .collection(Product
              .collectionName) // Pastikan nama koleksi sesuai di database Anda
          .doc(widget.product.id)
          .update({
        'name': _nameController.text,
        'description': _descController.text,
        'price':
            int.parse(_priceController.text), // Pastikan konversi ke int/number
        'updated_at':
            FieldValue.serverTimestamp(), // Opsional: catat waktu edit
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Data produk berhasil diperbarui!"),
          ),
        );
        // Navigator.pop(context); // Kembali ke halaman sebelumnya
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red, content: Text("Gagal update: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteProduct() async {
    // Validasi sederhana
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan Harga tidak boleh kosong")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // REFERENSI KE DOKUMEN SPESIFIK BERDASARKAN ID
      await FirebaseFirestore.instance
          .collection(Product
              .collectionName) // Pastikan nama koleksi sesuai di database Anda
          .doc(widget.product.id)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("produk berhasil dihapus!"),duration: Duration(seconds: 10),
          ),
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red, content: Text("Gagal update: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appbar = AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.grey),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: _deleteProduct,
              ),
            ],
          ),
        ),
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          const Text("Edit Product",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );

    final Widget body = Column(
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
                  child: const Icon(Icons.fastfood,
                      size: 100, color: Colors.white),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Rating Dummy
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 20),
                          Text(" 4.8",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // 2.1. Menampilkan Id Produk secara Dinamis
                      Text(
                        "id produk: ${widget.product.id}",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 8),

                      // 4. Ubah Text Nama menjadi TextField
                      const Text("Nama Produk",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          border:
                              UnderlineInputBorder(), // Garis bawah saja agar rapi
                          hintText: "Masukkan nama produk",
                        ),
                      ),
                      const SizedBox(height: 15),

                      // 5. Ubah Text Deskripsi menjadi TextField Multiline
                      const Text("Deskripsi",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      TextField(
                        controller: _descController,
                        maxLines: 3, // Agar bisa input panjang
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 14),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Masukkan deskripsi produk",
                        ),
                      ),
                      const SizedBox(height: 15),

                      // 6. Ubah Text Harga menjadi TextField Number
                      const Text("Harga (IDR)",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Row(
                        children: [
                          const Text(
                            "Rp. ",
                            style: TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _priceController,
                              keyboardType:
                                  TextInputType.number, // Keyboard angka
                              style: const TextStyle(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                              decoration: const InputDecoration(
                                border: InputBorder
                                    .none, // Hilangkan border agar menyatu
                                hintText: "0",
                                hintStyle: TextStyle(color: Colors.pinkAccent),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildBottomAction(context),
      ],
    );

    return Scaffold(backgroundColor: Colors.white, appBar: appbar, body: body);
  }

  // ... (Metode _buildBottomAction, _qtyBtn, dan _buildButton tetap sama seperti sebelumnya)

  Widget _buildBottomAction(BuildContext context) {
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
            children: [
              Expanded(
                  child: _buildButton("Simpan", Colors.pink, Colors.white)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildButton(String label, Color bgColor, Color textColor) {
    return ElevatedButton(
      // 7. Panggil fungsi _updateProduct saat tombol ditekan
      onPressed: _isLoading ? null : _updateProduct,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(
              color: Colors.white) // Loading indicator
          : Text(label,
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }
}
