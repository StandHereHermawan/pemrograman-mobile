import 'package:flutter/material.dart';

class DetailProductPage extends StatelessWidget {
  const DetailProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic appbar = AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      // title: Container(
      //   height: 45,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(10),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withAlpha(5),
      //         blurRadius: 10,
      //         spreadRadius: 2,
      //       )
      //     ],
      //   ),
      //   child: const TextField(
      //     decoration: InputDecoration(
      //       hintText: 'Search',
      //       prefixIcon: Icon(Icons.search, color: Colors.grey),
      //       border: InputBorder.none,
      //       contentPadding: EdgeInsets.symmetric(vertical: 10),
      //     ),
      //   ),
      // ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://via.placeholder.com/150'), // Ganti foto profil
          ),
        )
      ],
      // leading: MaterialButton(onPressed: () {}, child: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20)),
      leading: MaterialButton(
          onPressed: () {},
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Icon(Icons.arrow_back_ios_new,
                  color: Colors.black, size: 20))),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bagian Gambar & Header Ikon
                  Stack(
                    children: [
                      Container(
                        height: 400,
                        width: double.infinity,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      // Positioned(
                      //   top: 50,
                      //   left: 30,
                      //   child: _buildCircleButton(
                      //       Icons.arrow_back_ios_new, Colors.black),
                      // ),
                      const Positioned(
                        top: 50,
                        right: 30,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                        ),
                      ),
                    ],
                  ),

                  // Informasi Produk
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 20),
                            Text(" 3.8",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Chicken burger",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "100 gr chicken + tomato + cheese Lettuce",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Text(
                              "\$ 20",
                              style: TextStyle(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                            const Text(".00",
                                style: TextStyle(
                                    color: Colors.pink, fontSize: 14)),
                            const Spacer(),
                            // _buildCircleButton(Icons.add, Colors.white, bgColor: Colors.pink),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar (Price & Buttons)
          _buildBottomAction(context),
        ],
      ),
    );
  }

  // Widget _buildCircleButton(IconData icon, Color iconColor,
  //     {Color bgColor = Colors.white}) {
  //   return Container(
  //     padding: const EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       color: bgColor,
  //       shape: BoxShape.circle,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.1),
  //           blurRadius: 10,
  //           spreadRadius: 2,
  //         )
  //       ],
  //     ),
  //     child: Icon(icon, color: iconColor, size: 20),
  //   );
  // }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE9D9), // Warna krem sesuai gambar
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "\$32",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF131121), // Warna gelap di gambar
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _qtyBtn(Icons.remove),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("2",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                    _qtyBtn(Icons.add),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildButton(
                    "KERANJANG", Colors.pink, Colors.white),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildButton("BELI SEKARANG", Colors.pink, Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildButton(String label, Color bgColor, Color textColor) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }
}
