import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';

// Pastikan import model Product Anda jika berada di file terpisah
// import 'path/to/product_model.dart'; 

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  // 1. Controller untuk menangkap input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // 2. Fungsi untuk menyimpan data ke Firestore
  Future<void> _saveProduct() async {
    // Validasi Input
    if (_nameController.text.isEmpty ||
        _descController.text.isEmpty ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Referensi ke Collection
      // Menggunakan 'products' string atau Product.collectionName jika aksesibel
      CollectionReference productsRef =
          FirebaseFirestore.instance.collection(Product.collectionName);

      // Generate Referensi Dokumen baru (agar kita dapat ID-nya dulu)
      DocumentReference newDocRef = productsRef.doc();

      // Persiapkan Data
      final newProductData = {
        'id': newDocRef.id, // Simpan ID dokumen di dalam field juga
        'name': _nameController.text,
        'description': _descController.text,
        'price': int.parse(_priceController.text), // Konversi String ke Int
        'created_at': DateTime.now().toString(),   // Sesuai model String
      };

      // Simpan ke Firestore
      await newDocRef.set(newProductData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Produk berhasil ditambahkan!"),
          ),
        );
        // Navigator.pop(context); // Kembali ke halaman sebelumnya
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text("Error: $e")),
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
    return Scaffold(
      backgroundColor: const Color(0xFFFDE9D9), // Warna krem sesuai tema
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFD81B60)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add New Product",
          style: TextStyle(
            color: Color(0xFFD81B60),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Container Putih Melengkung
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("PRODUCT NAME"),
                    _buildTextField(
                      hint: "e.g. Choco Lava Cookies",
                      controller: _nameController,
                    ),
                  
                    const SizedBox(height: 20),
                    
                    _buildLabel("DESCRIPTION"),
                    _buildTextField(
                      hint: "e.g. Delicious cookies with melted chocolate inside...",
                      controller: _descController,
                      maxLines: 3, // Agar input lebih tinggi
                    ),
                    
                    const SizedBox(height: 20),
                    
                    _buildLabel("PRICE (IDR)"),
                    _buildTextField(
                      hint: "e.g. 15000",
                      controller: _priceController,
                      isNumber: true, // Input khusus angka
                    ),

                    const SizedBox(height: 40),

                    // Tombol Save
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD81B60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Save Product",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets (Reusable) ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blueGrey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Background abu-abu
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.blueGrey[200]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }
}