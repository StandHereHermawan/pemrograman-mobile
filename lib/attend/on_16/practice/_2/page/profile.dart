import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/user.dart'; // Pastikan import User model ada
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
  // State variables untuk data dinamis
  String _username = "Loading...";
  String _role = "Loading...";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // --- FUNGSI BARU: Ambil Data User dari Session & Firestore ---
  Future<void> _fetchUserProfile() async {
    try {
      // 1. Ambil User ID dari Shared Preferences (SessionManager)
      String? userId = await SessionManager.getUserIdFuture();

      if (userId != null && userId.isNotEmpty) {
        // 2. Ambil dokumen user dari Firestore berdasarkan ID
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection(User
                .collectionName) // Pastikan nama collection sesuai ('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

          if (mounted) {
            setState(() {
              // Ambil field username dan role, berikan default jika null
              _username = data['username'] ?? "No Name";
              _role = data['role'] ?? "No Role";
              _isLoading = false;
            });
          }
        } else {
          print("User document not found in Firestore");
          if (mounted) setState(() => _isLoading = false);
        }
      } else {
        print("User ID not found in Session");
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error fetching profile: $e");
      if (mounted) {
        setState(() {
          _username = "Error";
          _role = "Error";
          _isLoading = false;
        });
      }
    }
  }

  // --- Logika Logout (Tetap sama seperti sebelumnya) ---
  void _handleLogout(BuildContext context) {
    void performLocalLogout() {
      SessionManager.logout().then((_) {
        print("Local session cleared.");
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      });
    }

    SessionManager.getCredentialId().then((credId) {
      if (credId != null && credId.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('credentials') // Pastikan nama collection sesuai
            .doc(credId)
            .get()
            .then((docSnapshot) {
          if (docSnapshot.exists) {
            docSnapshot.reference.delete().then((_) {
              performLocalLogout();
            }).catchError((error) {
              performLocalLogout();
            });
          } else {
            performLocalLogout();
          }
        }).catchError((error) {
          performLocalLogout();
        });
      } else {
        performLocalLogout();
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
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.black),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.home_filled, color: Colors.black),
              onPressed: () {
                if (_role == 'admin') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminHomePage(key: widget.key),
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerHomePage(key: widget.key),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Tampilkan loading
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // --- 1. Placeholder Icon ---
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.pink.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- 2. Informasi Profil (Dinamis) ---
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
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Menggunakan variabel state _username
                        _buildInfoItem(
                            Icons.account_circle, "USERNAME", _username),
                        const Divider(height: 30),

                        // Menggunakan variabel state _role
                        _buildInfoItem(Icons.badge, "ROLE", _role),
                        const Divider(height: 30),

                        _buildInfoItem(
                            Icons.email_outlined, "EMAIL", "admin@zweet.com"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- 3. Tombol Logout ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _handleLogout(context);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text("Log Out"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[50],
                          foregroundColor: Colors.pink,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.pink.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.pink, size: 22),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
