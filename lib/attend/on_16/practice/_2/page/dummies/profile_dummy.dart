// import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_home.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/login.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/util/session_manager.dart';

class ProfilePageDummies extends StatelessWidget {
  // Data statis (bisa diganti data dari Firebase nantinya)
  final String username;
  final String role;

  const ProfilePageDummies({
    super.key,
    this.username = "Admin Zweet", // Default value
    this.role = "Administrator", // Default value
  });

  void _handleLogout(BuildContext context) {
    // Fungsi lokal untuk bersih-bersih session & pindah halaman
    // Dibuat fungsi agar bisa dipanggil di berbagai kondisi (sukses/gagal/tidak ada data)
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

    // 1. Ambil ID dari Session Manager
    SessionManager.getCredentialId().then((credId) {
      if (credId != null && credId.isNotEmpty) {
        print("Checking Firestore for ID: $credId");

        // 2. Cek apakah dokumen ada di Firestore
        FirebaseFirestore.instance
            .collection('credentials')
            .doc(credId)
            .get()
            .then((docSnapshot) {
          if (docSnapshot.exists) {
            // 3a. Jika ADA -> Hapus dulu, baru logout
            docSnapshot.reference.delete().then((_) {
              print("Document exist. Deleted successfully.");
              performLocalLogout(); // Pindah halaman setelah hapus
            }).catchError((error) {
              print("Failed to delete: $error");
              performLocalLogout(); // Tetap logout meski gagal hapus (biar user tidak terjebak)
            });
          } else {
            // 3b. Jika TIDAK ADA -> Langsung logout
            print("Document does not exist in Firestore.");
            performLocalLogout();
          }
        }).catchError((error) {
          // Handle jika koneksi internet mati / error cek firestore
          print("Error checking firestore: $error");
          performLocalLogout(); // Tetap logout agar aman
        });
      } else {
        // Jika tidak ada ID di session manager
        print("No Credential ID found locally.");
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerHomePage(key: key),
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // --- 1. Placeholder Icon Person Outlined ---
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[100], // Background abu sangat muda
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.pink.withOpacity(0.2), // Border tipis pink
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person_outline, // Ikon yang diminta
                  size: 60,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // --- 2. Informasi Profil ---
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
                  _buildInfoItem(Icons.account_circle, "USERNAME", username),
                  const Divider(height: 30), // Garis pemisah
                  _buildInfoItem(Icons.badge, "ROLE", role),
                  const Divider(height: 30),
                  _buildInfoItem(
                      Icons.email_outlined, "EMAIL", "admin@zweet.com"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 3. Tombol Logout (Opsional) ---
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
                    backgroundColor: Colors.pink[50], // Pink sangat muda
                    foregroundColor: Colors.pink, // Teks pink
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

  // Helper Widget untuk membuat baris info agar kode lebih rapi
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
