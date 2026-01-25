import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/profile.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onProfilePressed;
  final TextStyle? style; // <--- 1. TAMBAHKAN INI

  const CustomAppBar({
    super.key,
    required this.title,
    this.onProfilePressed,
    this.style, // <--- 2. TAMBAHKAN KE CONSTRUCTOR
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Container(
        height: 45,
        width: double.infinity,
        alignment: Alignment.center,
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
          // 3. GANTI STYLE-NYA JADI SEPERTI INI
          style: style ??
              const TextStyle(
                color: Colors.grey, // Warna default kalau kamu nggak isi style
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              if (onProfilePressed != null) {
                onProfilePressed!();
              } else {
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
