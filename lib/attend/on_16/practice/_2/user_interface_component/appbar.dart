import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/profile.dart'; 

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onProfilePressed;

  const CustomAppBar({
    super.key,
    required this.title, // Parameter wajib
    this.onProfilePressed, // Parameter opsional
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      // Container Judul
      title: Container(
        height: 45,
        width: double.infinity, // Agar memenuhi lebar area title
        alignment: Alignment.center, // Menggantikan Column/Expanded yang berisiko error
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold, // Opsional: Agar lebih tegas
            fontSize: 16,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            // --- LOGIKA DEFAULT CALLBACK ---
            onTap: () {
              if (onProfilePressed != null) {
                // Jika parameter fungsi diisi, jalankan fungsi tersebut
                onProfilePressed!();
              } else {
                // Default value: Pindah ke ProfilePage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              }
            },
            child: CircleAvatar(
              backgroundColor: Colors.black.withAlpha(50),
              child: const Icon(Icons.person_rounded, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  // Wajib ada jika membuat custom AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}