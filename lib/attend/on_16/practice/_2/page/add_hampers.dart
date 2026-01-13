import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/hampers.dart';

class AddHampersPage extends StatefulWidget {
  const AddHampersPage({super.key});

  @override
  State<AddHampersPage> createState() => _AddHampersPageState();
}

class _AddHampersPageState extends State<AddHampersPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // State untuk Pagination & Selection
  final List<DocumentSnapshot> _products = [];
// Ganti: final Set<String> _selectedProductIds = {};
// Menjadi:
  final Map<String, int> _selectedProducts = {}; // Map<ID_Produk, Quantity>
  bool _isLoading = false;
  bool _isFetchingMore = false;
  bool _hasNextPage = true;
  DocumentSnapshot? _lastDocument;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Load data pertama kali
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // --- LOGIKA PAGINATION ---

  Future<void> _fetchProducts() async {
    if (!_hasNextPage || _isFetchingMore) return;

    setState(() => _isFetchingMore = true);

    Query query = FirebaseFirestore.instance
        .collection('products') // Nama koleksi produk Anda
        .orderBy('name')
        .limit(_pageSize);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final querySnapshot = await query.get();

    if (querySnapshot.docs.length < _pageSize) {
      _hasNextPage = false;
    }

    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
      setState(() {
        _products.addAll(querySnapshot.docs);
      });
    }

    setState(() => _isFetchingMore = false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchProducts();
    }
  }

  // --- LOGIKA SIMPAN HAMPERS ---

  Future<void> _saveHampers() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedProducts.isEmpty) {
      // Cek Map
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama, Harga, dan Produk harus diisi!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      DocumentReference newHampersRef =
          FirebaseFirestore.instance.collection(Hampers.collectionName).doc();

      // Konversi Map ke format List of Objects untuk Firestore
      List<Map<String, String>> productListObjects =
          _selectedProducts.entries.map((entry) {
        return {
          'productId': entry.key,
          'quantity':
              entry.value.toString(), // Sesuai permintaan: String quantity
        };
      }).toList();

      await newHampersRef.set({
        'id': newHampersRef.id,
        'name': _nameController.text,
        'description': _descController.text,
        'price': int.parse(_priceController.text),
        'products': productListObjects, // Sekarang berupa Array of Objects
        'created_at': DateTime.now().toString(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text("Hampers Berhasil Disimpan!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDE9D9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Create New Hampers",
            style: TextStyle(
                color: Color(0xFFD81B60), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("HAMPERS INFO"),
              _buildTextField(
                  hint: "Hampers Name", controller: _nameController),

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

              const SizedBox(height: 25),

              _buildLabel(
                  "SELECT PRODUCTS (${_selectedProducts.length} Selected)"),

              // LIST PRODUK DENGAN INFINITE SCROLL
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10),
                    itemCount: _products.length + (_hasNextPage ? 1 : 0),
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      if (index == _products.length) {
                        return const Center(
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator()));
                      }

                      final doc = _products[index];
                      final data = doc.data() as Map<String, dynamic>;
                      // Di dalam ListView.separated bagian itemBuilder:
                      final String productId = doc.id;
                      final bool isSelected =
                          _selectedProducts.containsKey(productId);

                      return Container(
                        color: isSelected
                            ? Colors.pink.withValues(alpha: 0.05)
                            : Colors.transparent,
                        child: Column(
                          children: [
                            CheckboxListTile(
                              title: Text(data['name'] ?? 'No Name',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text("IDR ${data['price']}"),
                              value: isSelected,
                              activeColor: const Color(0xFFD81B60),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedProducts[productId] =
                                        1; // Default qty 1
                                  } else {
                                    _selectedProducts.remove(productId);
                                  }
                                });
                              },
                            ),
                            if (isSelected)
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text("Qty: ",
                                        style: TextStyle(fontSize: 12)),
                                    _qtyBtn(Icons.remove, () {
                                      setState(() {
                                        if (_selectedProducts[productId]! > 1) {
                                          _selectedProducts[productId] =
                                              _selectedProducts[productId]! - 1;
                                        }
                                      });
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text(
                                          "${_selectedProducts[productId]}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    _qtyBtn(Icons.add, () {
                                      setState(() {
                                        _selectedProducts[productId] =
                                            _selectedProducts[productId]! + 1;
                                      });
                                    }),
                                  ],
                                ),
                              )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveHampers,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD81B60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("SAVE HAMPERS",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- REUSABLE WIDGETS ---
  Widget _buildLabel(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text,
          style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 11,
              fontWeight: FontWeight.bold)));

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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFD81B60),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
