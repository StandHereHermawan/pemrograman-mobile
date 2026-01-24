import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/helper/login.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/admin/home.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_home.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/register.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/visitor.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/service/auth.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/util/session_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  // bool _rememberMe = false;
  bool _isLoading = false;
  // State baru untuk handle loading awal saat cek sesi
  bool _isCheckingSession = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  // --- LOGIKA UTAMA CEK SESI ---
  void _checkSession() async {
    // 1. Cek apakah ada data login di Shared Preferences
    bool isLogin = await SessionManager.isUserLoggedIn();

    if (isLogin) {
      // 2. Ambil User ID dari Shared Preferences
      String? userId = await SessionManager.getUserIdFuture();

      if (userId != null) {
        // 3. Ambil data User (Role) dari Firestore
        String? role = await _authService.getUserRole(userId);

        if (role != null) {
          // 4. Jika sukses, langsung navigasi
          _navigateBasedOnRole(role);
          return; // Stop eksekusi agar tidak mengubah state _isCheckingSession
        } else {
          // Kasus aneh: Di HP login, tapi di Firestore user sudah dihapus/error
          // Maka paksa logout dari HP
          await SessionManager.logout();
        }
      }
    }

    // Jika tidak ada sesi atau sesi tidak valid, matikan loading dan tampilkan form
    if (mounted) {
      setState(() {
        _isCheckingSession = false;
      });
    }
  }

  // Helper untuk navigasi
  void _navigateBasedOnRole(String role) {
    if (!mounted) return;

    if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomerHomePage()),
      );
    }
  }

  void _handleLogin() async {
    // 1. Validasi Input Kosong
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Username dan Password harus diisi")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // 2. Panggil Service Login
    LoginInformation statusLogin = await _authService.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    // 3. Navigasi jika sukses
    if (statusLogin.success) {
      // NOTE: Pastikan di dalam method _authService.login() Anda sudah memanggil
      // SessionManager.saveSession(...) agar auto-login bekerja di pembukaan aplikasi berikutnya.

      _navigateBasedOnRole(statusLogin.role);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Gagal. Cek username atau password.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Panggil pengecekan sesi saat halaman pertama kali dibuat
    _checkSession();
  }

  @override
  void dispose() {
    // Jangan lupa dispose controller agar memori tidak bocor
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Jika sedang mengecek sesi, tampilkan Loading Screen polos
    // Ini mencegah Form Login "berkedip" sebelum pindah halaman
    if (_isCheckingSession) {
      return const Scaffold(
        backgroundColor: Color(0xFFFDE9D9),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFD81B60),
          ),
        ),
      );
    }

    return Scaffold(
      // Background warna krem muda sesuai bagian atas gambar
      backgroundColor: const Color(0xFFFDE9D9),
      body: Column(
        children: [
          const SizedBox(height: 60),
          // Bagian Logo
          Center(
            child: Column(
              children: [
                // Ganti dengan Image.asset('assets/logo.png') jika sudah ada filenya
                const Text(
                  "Zweet",
                  style: TextStyle(
                    fontFamily:
                        'Cursive', // Gunakan font dekoratif jika tersedia
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
          // Bagian Form dengan background putih melengkung
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
                    _buildTextField(
                        hint: "abcd", controller: _usernameController),
                    const SizedBox(height: 20),
                    _buildLabel("PASSWORD"),
                    _buildTextField(
                      controller: _passwordController,
                      hint: "**********",
                      isPassword: true,
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

                    // Remember Me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Row(
                        //   children: [
                        //     SizedBox(
                        //       height: 24,
                        //       width: 24,
                        //       child: Checkbox(
                        //         value: _rememberMe,
                        //         activeColor: const Color(0xFFD81B60),
                        //         onChanged: (value) {
                        //           setState(() {
                        //             _rememberMe = value!;
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //     const Text(" Remember me",
                        //         style: TextStyle(
                        //             color: Colors.grey, fontSize: 12)),
                        //   ],
                        // ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const VisitorHomePage()),
                            );
                          },
                          child: const Text(
                            "Visitor Page",
                            style: TextStyle(
                                color: Color(0xFFD81B60), fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Button Log In
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD81B60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "LOG IN",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Footer Sign Up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors
                              .transparent, // Agar background tetap terlihat
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                                10), // Biar sudut ripple melengkung
                            onTap: () {
                              // Masukkan logic pindah halaman di sini
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  8.0), // Jarak sentuh agar lebih empuk
                              child: Row(
                                children: const [
                                  Text("Don't have an account? ",
                                      style: TextStyle(color: Colors.grey)),
                                  const Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                      color: Color(0xFFD81B60),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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

  Widget _buildTextField({
    required TextEditingController controller, // 1. Tambahkan parameter ini
    required String hint,
    bool isPassword = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller, // 2. Pasang controller di sini
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
