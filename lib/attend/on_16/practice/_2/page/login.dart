import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/helper/login.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/admin/home.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_home.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/register.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/service/auth.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/util/session_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool _isLoading = false;
  bool _isCheckingSession = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    bool isLogin = await SessionManager.isUserLoggedIn();
    if (isLogin) {
      String? userId = await SessionManager.getUserIdFuture();
      if (userId != null) {
        String? role = await _authService.getUserRole(userId);
        if (role != null) {
          _navigateBasedOnRole(role);
          return;
        } else {
          await SessionManager.logout();
        }
      }
    }
    if (mounted) {
      setState(() => _isCheckingSession = false);
    }
  }

  void _navigateBasedOnRole(String role) {
    if (!mounted) return;
    if (role == 'admin') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const AdminHomePage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const CustomerHomePage()));
    }
  }

  void _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username dan Password harus diisi")),
      );
      return;
    }
    setState(() => _isLoading = true);
    LoginInformation statusLogin = await _authService.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (statusLogin.success) {
      _navigateBasedOnRole(statusLogin.role);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Login Gagal. Cek username atau password.")),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingSession) {
      return const Scaffold(
        backgroundColor: Color(0xFFFDE9D9),
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFFD81B60))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDE9D9),
      // --- FITUR BARU: Tombol Back di AppBar ---
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFD81B60)),
          onPressed: () {
            // Kembali ke Customer Home Page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CustomerHomePage()),
            );
          },
        ),
      ),
      extendBodyBehindAppBar:
          true, // Agar background body naik sampai ke belakang AppBar
      body: Column(
        children: [
          const SizedBox(height: 80), // Sesuaikan jarak karena ada AppBar
          Center(
            child: Column(
              children: const [
                Text(
                  "Zweet",
                  style: TextStyle(
                    fontSize: 48,
                    color: Color(0xFFD81B60),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "corner",
                  style: TextStyle(
                      fontSize: 24, color: Color(0xFFD81B60), letterSpacing: 2),
                ),
                Text("Handcrafted Cookies",
                    style: TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 40),
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
                        onPressed: () =>
                            setState(() => _obscureText = !_obscureText),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD81B60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text("LOG IN",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? ",
                            style: TextStyle(color: Colors.grey)),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterPage())),
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(
                                color: Color(0xFFD81B60),
                                fontWeight: FontWeight.bold),
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
      child: Text(text,
          style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2)),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String hint,
      bool isPassword = false,
      Widget? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
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
