import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/user.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/admin/home.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_home.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/login.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/util/session_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State variables
  String _username = "Guest";
  String _role = "Visitor";
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initProfile();
  }

  // --- LOGIKA INITIALIZE ---
  Future<void> _initProfile() async {
    bool loginStatus = await SessionManager.isUserLoggedIn();
    if (!mounted) return;

    setState(() {
      _isLoggedIn = loginStatus;
    });

    if (loginStatus) {
      await _fetchUserProfile();
    } else {
      setState(() => _isLoading = false);
    }
  }

  // --- AMBIL DATA DARI FIRESTORE ---
  Future<void> _fetchUserProfile() async {
    try {
      String? userId = await SessionManager.getUserIdFuture();

      if (userId != null && userId.isNotEmpty) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection(User.collectionName)
            .doc(userId)
            .get();

        if (userDoc.exists && mounted) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _username = data['username'] ?? "No Name";
            _role = data['role'] ?? "Customer";
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- LOGIKA LOGOUT ---
  void _handleLogout(BuildContext context) {
    SessionManager.logout().then((_) {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_filled, color: Colors.black),
            onPressed: () {
              // Navigasi balik ke home sesuai role jika login, atau ke customer home jika guest
              if (_isLoggedIn && _role == 'admin') {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const AdminHomePage()));
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CustomerHomePage()));
              }
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : _isLoggedIn
              ? _buildProfileContent() // Tampilan jika sudah login
              : _buildLoginPrompt(), // Tampilan jika belum login
    );
  }

  // --- UI: BELUM LOGIN ---
  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.lock_outline, size: 80, color: Colors.pink),
            ),
            const SizedBox(height: 24),
            const Text(
              "Yuk, Login Dulu!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Masuk ke akunmu untuk melihat profil, riwayat pesanan, dan fitur lengkap lainnya.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoginPage())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  "LOGIN SEKARANG",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI: SUDAH LOGIN ---
  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.pink.withOpacity(0.2), width: 4),
                  ),
                  child: const Icon(Icons.person, size: 70, color: Colors.grey),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.pink, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildInfoItem(Icons.account_circle, "USERNAME", _username),
                const Divider(height: 30),
                _buildInfoItem(Icons.badge, "ROLE", _role.toUpperCase()),
                const Divider(height: 30),
                _buildInfoItem(
                    Icons.email_outlined, "EMAIL", "user@example.com"),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextButton.icon(
              onPressed: () => _handleLogout(context),
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text("Log Out dari Akun",
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                backgroundColor: Colors.red[50],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.pink[50], borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.pink, size: 24),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
