import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/credential.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/user.dart'; // 1. Import Firestore

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 2. Buat Controller untuk menangkap input teks
// Di dalam class _RegisterPageState
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController(); // Tambahkan ini

  bool _obscureText = true;
  bool _isLoading = false; // Untuk indikator loading

  // Jangan lupa dispose controller saat halaman ditutup
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // Tambahkan ini
    super.dispose();
  }

  // 3. Fungsi Logika Sign Up ke Firestore
  //

  Future<void> _signUp() async {
    //
    // Validasi sederhana
    //
    // 1. Validasi field tidak kosong
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi")),
      );
      return;
    }

    // 2. Validasi kecocokan password (LOGIK BARU)
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text("Password dan Konfirmasi Password tidak cocok!"),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // PROSES PENGIRIMAN DATA KE FIRESTORE
      CollectionReference users =
          FirebaseFirestore.instance.collection(Users.collectionName);
      CollectionReference credentials =
          FirebaseFirestore.instance.collection(Credential.collectionName);

      // 1. Buat referensi (ID dibuat di sini)
      DocumentReference usersDocumentReference = users.doc();
      DocumentReference credentialsDocumentReference = credentials.doc();

      // 2. Gunakan referensi tersebut untuk menyimpan (.set)
      await usersDocumentReference.set({
        'id': usersDocumentReference.id,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'role': Users.defaultRole,
        'created_at': FieldValue.serverTimestamp(),
      });

      await credentialsDocumentReference.set({
        'id': credentialsDocumentReference.id,
        'user_id': usersDocumentReference.id,
        'created_at': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text("Berhasil Sign Up!")),
        );
        // Reset form setelah sukses
        _usernameController.clear();
        _passwordController.clear();
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
      backgroundColor: const Color(0xFFFDE9D9),
      body: Column(
        children: [
          const SizedBox(height: 60),
          // Bagian Logo (Tidak berubah)
          Center(
            child: Column(
              children: [
                const Text(
                  "Zweet",
                  style: TextStyle(
                    fontFamily: 'Cursive',
                    fontSize: 48,
                    color: Color(0xFFD81B60),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "corner",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFD81B60),
                    letterSpacing: 2,
                  ),
                ),
                const Text(
                  "Handcrafted Cookies",
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Bagian Form
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
                    _buildLabel("USERNAME"),
                    // 4. Pasang Controller ke TextField
                    _buildTextField(
                        hint: "abcd", controller: _usernameController),
                    const SizedBox(height: 20),
                    _buildLabel("PASSWORD"),
                    // 4. Pasang Controller ke TextField
                    _buildTextField(
                      hint: "**********",
                      isPassword: true,
                      controller: _passwordController,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.blueGrey[200],
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
                    ),

                    const SizedBox(height: 20), // Jarak

                    _buildLabel("CONFIRM PASSWORD"), // Label Baru
                    _buildTextField(
                      hint: "**********",
                      isPassword: true,
                      controller: _confirmPasswordController, // Controller Baru
                      suffixIcon:
                          Icon(Icons.lock_outline, color: Colors.blueGrey[200]),
                    ),

                    const SizedBox(height: 30),

                    // Button Sign Up
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        // 5. Panggil fungsi _signUp saat ditekan
                        onPressed: _isLoading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD81B60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Footer Sign Up (Tidak berubah)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ",
                            style: TextStyle(color: Colors.grey)),
                        GestureDetector(
                          child: const Text(
                            "log in",
                            style: TextStyle(
                              color: Color(0xFFD81B60),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

  // 6. Update Helper Widget untuk menerima Controller
  Widget _buildTextField({
    required String hint,
    bool isPassword = false,
    Widget? suffixIcon,
    required TextEditingController controller, // Tambahkan parameter ini
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller, // Hubungkan controller ke TextField
        obscureText: isPassword ? _obscureText : false,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.blueGrey[200]),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
