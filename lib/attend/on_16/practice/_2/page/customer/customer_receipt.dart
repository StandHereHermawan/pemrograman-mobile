import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/receipt.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_cart.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_delivery.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_finished_order.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/customer/customer_home.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/login.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/user_interface_component/appbar.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/user_interface_component/receipt_card_customer.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/util/session_manager.dart';

class CustomerReceiptPage extends StatefulWidget {
  const CustomerReceiptPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CustomerReceiptPageState();
  }
}

class _CustomerReceiptPageState extends State<CustomerReceiptPage> {
// Variable State
  String? userId;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  @override
  void dispose() {
    // Jangan lupa dispose controller agar memori tidak bocor
    super.dispose();
  }

  Future<void> _checkSession() async {
    // 1. Cek Login Status
    bool isLogin = await SessionManager.isUserLoggedIn();

    if (!mounted) return; // Cek apakah widget masih ada

    if (!isLogin) {
      _redirectToLogin();
      return;
    }

    // 2. Ambil User ID
    String? id = await SessionManager.getUserIdFuture();

    if (!mounted) return;

    if (id == null || id.isEmpty) {
      _redirectToLogin();
    } else {
      // 3. Simpan ke State dan Re-build UI
      setState(() {
        userId = id;
      });
    }
  }

  void _redirectToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("User ID block .build _CustomerReceivePageState : ${userId}");

    final dynamic appbar = CustomAppBar(title: "Customer Receipt");
    // Old
    // final dynamic appbar = AppBar(
    //   backgroundColor: Colors.white,
    //   elevation: 0,
    //   centerTitle: true,
    //   leading: IconButton(
    //     icon: const Icon(Icons.arrow_back_ios_new, color: Colors.grey),
    //     onPressed: () => Navigator.pop(context),
    //   ),
    //   title: Container(
    //     height: 45,
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(10),
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.black.withAlpha(20),
    //           blurRadius: 10,
    //           spreadRadius: 2,
    //         )
    //       ],
    //     ),
    //     child: Expanded(
    //       child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Text(
    //                 "Customer Receipt",
    //                 style: TextStyle(color: Colors.grey),
    //               ),
    //             ),
    //           ]),
    //     ),
    //   ),
    //   actions: [
    //     Padding(
    //       padding: const EdgeInsets.only(right: 16.0),
    //       child: InkWell(
    //           onTap: () {
    //             Navigator.pushReplacement(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => ProfilePageDummies(key: key),
    //               ),
    //             );
    //           },
    //           borderRadius: BorderRadius.circular(30),
    //           child: CircleAvatar(
    //             backgroundColor: Colors.black.withAlpha(50),
    //             child: Icon(Icons.person_rounded),
    //           )),
    //     )
    //   ],
    // );

    final dynamic body = ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Section Kue
        _buildSectionHeader("Belum Pengecekan Pembayaran"),
        const SizedBox(height: 10),
        SizedBox(
          height: 240,
          child: StreamBuilder<QuerySnapshot>(
            // 1. Query ke Firestore
            stream: FirebaseFirestore.instance
                .collection(Receipt.collectionName)
                .where('user_id', isEqualTo: userId)
                .where('request_receipt_already_paid', isEqualTo: false)
                .where('is_paid', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              // A. Jika sedang loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // B. Jika ada Error
              if (snapshot.hasError) {
                return const Center(child: Text("Terjadi kesalahan"));
              }

              // C. Jika Data Kosong
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Belum ada produk"));
              }

              // D. Jika Data Ada
              final documents = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: documents.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // Ambil data per dokumen
                  final data = documents[index].data() as Map<String, dynamic>;
                  return ReceiptCustomerCard(
                    onTap: () {
                      //   // Contoh penggunaan di halaman Home
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => DetailProductPage(
                      //         product: Product.fromJson(data),
                      //       ),
                      //     ),
                      //   );
                    },
                    onRequestPaid: () {
                      FirebaseFirestore.instance
                          .collection(Receipt.collectionName)
                          .doc(Receipt.fromJson(data).id)
                          .update({
                        'request_receipt_already_paid': true,
                        'updated_at': FieldValue.serverTimestamp(),
                      }).then((_) {
                        // Bagian ini dijalankan NANTI jika SUKSES
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Berhasil update!")),
                        );
                      }).catchError((error) {
                        // Bagian ini dijalankan NANTI jika GAGAL
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal: $error")),
                        );
                      });
                    },
                    receipt: Receipt.fromJson(data),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        _buildSectionHeader("Tunggu Konfirmasi Pembayaran Masuk"),
        const SizedBox(height: 10),
        SizedBox(
          height: 240,
          child: StreamBuilder<QuerySnapshot>(
            // 1. Query ke Firestore
            stream: FirebaseFirestore.instance
                .collection(Receipt.collectionName)
                .where('user_id', isEqualTo: userId)
                .where('request_receipt_already_paid', isEqualTo: true)
                .where('is_paid', isEqualTo: false)
                // .orderBy('created_at',
                //     descending:
                //         true) // Urutkan dari yang terbaru (Z-A / Waktu besar ke kecil)
                // .limit(5) // Batasi hanya 5 dokumen
                .snapshots(),
            builder: (context, snapshot) {
              // A. Jika sedang loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // B. Jika ada Error
              if (snapshot.hasError) {
                return const Center(child: Text("Terjadi kesalahan"));
              }

              // C. Jika Data Kosong
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text("Belum ada pembayaran tunggu konfirmasi"));
              }

              // D. Jika Data Ada
              final documents = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: documents.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // Ambil data per dokumen
                  final data = documents[index].data() as Map<String, dynamic>;
                  return ReceiptCustomerCard(
                    onTap: () {
                      //   // Contoh penggunaan di halaman Home
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => DetailProductPage(
                      //         product: Product.fromJson(data),
                      //       ),
                      //     ),
                      //   );
                    },
                    onRequestPaid: () {
                      FirebaseFirestore.instance
                          .collection(Receipt.collectionName)
                          .doc(Receipt.fromJson(data).id)
                          .update({
                        'request_receipt_already_paid': true,
                        'updated_at': FieldValue.serverTimestamp(),
                      }).then((_) {
                        // Bagian ini dijalankan NANTI jika SUKSES
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Berhasil update!")),
                        );
                      }).catchError((error) {
                        // Bagian ini dijalankan NANTI jika GAGAL
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal: $error")),
                        );
                      });
                    },
                    receipt: Receipt.fromJson(data),
                  );
                },
              );
            },
          ),
        ),

        _buildSectionHeader("Pembayaran Diterima Penjual."),
        const SizedBox(height: 10),
        SizedBox(
          height: 240,
          child: StreamBuilder<QuerySnapshot>(
            // 1. Query ke Firestore
            stream: FirebaseFirestore.instance
                .collection(Receipt.collectionName)
                .where('user_id', isEqualTo: userId)
                .where('request_receipt_already_paid', isEqualTo: true)
                .where('is_paid', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              // A. Jika sedang loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // B. Jika ada Error
              if (snapshot.hasError) {
                return const Center(child: Text("Terjadi kesalahan"));
              }

              // C. Jika Data Kosong
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child:
                        Text("Belum ditemukan informasi pembayaran diterima."));
              }

              // D. Jika Data Ada
              final documents = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: documents.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // Ambil data per dokumen
                  final data = documents[index].data() as Map<String, dynamic>;
                  return ReceiptCustomerCard(
                    onTap: () {
                      //   // Contoh penggunaan di halaman Home
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => DetailProductPage(
                      //         product: Product.fromJson(data),
                      //       ),
                      //     ),
                      //   );
                    },
                    onRequestPaid: () {
                      FirebaseFirestore.instance
                          .collection(Receipt.collectionName)
                          .doc(Receipt.fromJson(data).id)
                          .update({
                        'request_receipt_already_paid': true,
                        'updated_at': FieldValue.serverTimestamp(),
                      }).then((_) {
                        // Bagian ini dijalankan NANTI jika SUKSES
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Berhasil update!")),
                        );
                      }).catchError((error) {
                        // Bagian ini dijalankan NANTI jika GAGAL
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal: $error")),
                        );
                      });
                    },
                    receipt: Receipt.fromJson(data),
                  );
                },
              );
            },
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar,
      body: body,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final dynamic appbar = CustomAppBar(title: "Customer Receipt");
  //   // Old
  //   // final dynamic appbar = AppBar(
  //   //   backgroundColor: Colors.white,
  //   //   elevation: 0,
  //   //   centerTitle: true,
  //   //   leading: IconButton(
  //   //     icon: const Icon(Icons.arrow_back_ios_new, color: Colors.grey),
  //   //     onPressed: () => Navigator.pop(context),
  //   //   ),
  //   //   title: Container(
  //   //     height: 45,
  //   //     decoration: BoxDecoration(
  //   //       color: Colors.white,
  //   //       borderRadius: BorderRadius.circular(10),
  //   //       boxShadow: [
  //   //         BoxShadow(
  //   //           color: Colors.black.withAlpha(20),
  //   //           blurRadius: 10,
  //   //           spreadRadius: 2,
  //   //         )
  //   //       ],
  //   //     ),
  //   //     child: Expanded(
  //   //       child: Column(
  //   //           crossAxisAlignment: CrossAxisAlignment.center,
  //   //           mainAxisAlignment: MainAxisAlignment.center,
  //   //           children: [
  //   //             Padding(
  //   //               padding: const EdgeInsets.all(8.0),
  //   //               child: Text(
  //   //                 "Customer Receipt",
  //   //                 style: TextStyle(color: Colors.grey),
  //   //               ),
  //   //             ),
  //   //           ]),
  //   //     ),
  //   //   ),
  //   //   actions: [
  //   //     Padding(
  //   //       padding: const EdgeInsets.only(right: 16.0),
  //   //       child: InkWell(
  //   //           onTap: () {
  //   //             Navigator.pushReplacement(
  //   //               context,
  //   //               MaterialPageRoute(
  //   //                 builder: (context) => ProfilePageDummies(key: key),
  //   //               ),
  //   //             );
  //   //           },
  //   //           borderRadius: BorderRadius.circular(30),
  //   //           child: CircleAvatar(
  //   //             backgroundColor: Colors.black.withAlpha(50),
  //   //             child: Icon(Icons.person_rounded),
  //   //           )),
  //   //     )
  //   //   ],
  //   // );
  //
  //   final dynamic body = ListView(
  //     padding: const EdgeInsets.all(16.0),
  //     children: [
  //       // Section Kue
  //       _buildSectionHeader("Belum Pengecekan Pembayaran"),
  //       const SizedBox(height: 10),
  //       SizedBox(
  //         height: 240,
  //         child: StreamBuilder<QuerySnapshot>(
  //           // 1. Query ke Firestore
  //           stream: FirebaseFirestore.instance
  //               .collection(Receipt.collectionName)
  //               .where('user_id', isEqualTo: userId ?? "")
  //               .where('request_receipt_already_paid', isEqualTo: false)
  //               .where('is_paid', isEqualTo: false)
  //               // .orderBy('created_at',
  //               //     descending:
  //               //         true) // Urutkan dari yang terbaru (Z-A / Waktu besar ke kecil)
  //               // .limit(5) // Batasi hanya 5 dokumen
  //               .snapshots(),
  //           builder: (context, snapshot) {
  //             // A. Jika sedang loading
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return const Center(child: CircularProgressIndicator());
  //             }
  //
  //             // B. Jika ada Error
  //             if (snapshot.hasError) {
  //               return const Center(child: Text("Terjadi kesalahan"));
  //             }
//
  //             // C. Jika Data Kosong
  //             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //               return const Center(child: Text("Belum ada produk"));
  //             }
//
  //             // D. Jika Data Ada
  //             final documents = snapshot.data!.docs;
//
  //             return ListView.builder(
  //               scrollDirection: Axis.vertical,
  //               itemCount: documents.length,
  //               physics: const AlwaysScrollableScrollPhysics(),
  //               itemBuilder: (context, index) {
  //                 // Ambil data per dokumen
  //                 final data = documents[index].data() as Map<String, dynamic>;
  //                 return ReceiptCustomerCard(
  //                   onTap: () {
  //                     //   // Contoh penggunaan di halaman Home
  //                     //   Navigator.push(
  //                     //     context,
  //                     //     MaterialPageRoute(
  //                     //       builder: (context) => DetailProductPage(
  //                     //         product: Product.fromJson(data),
  //                     //       ),
  //                     //     ),
  //                     //   );
  //                   },
  //                   onRequestPaid: () {
  //                     FirebaseFirestore.instance
  //                         .collection(Receipt.collectionName)
  //                         .doc(Receipt.fromJson(data).id)
  //                         .update({
  //                       'request_receipt_already_paid': true,
  //                       'updated_at': FieldValue.serverTimestamp(),
  //                     }).then((_) {
  //                       // Bagian ini dijalankan NANTI jika SUKSES
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(content: Text("Berhasil update!")),
  //                       );
  //                     }).catchError((error) {
  //                       // Bagian ini dijalankan NANTI jika GAGAL
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         SnackBar(content: Text("Gagal: $error")),
  //                       );
  //                     });
  //                   },
//
  //                   receipt: Receipt.fromJson(data),
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //       const SizedBox(height: 10),
//
  //       _buildSectionHeader("Tunggu Konfirmasi Pembayaran Masuk"),
  //       const SizedBox(height: 10),
  //       SizedBox(
  //         height: 240,
  //         child: StreamBuilder<QuerySnapshot>(
  //           // 1. Query ke Firestore
  //           stream: FirebaseFirestore.instance
  //               .collection(Receipt.collectionName)
  //               .where('user_id', isEqualTo: userId)
  //               .where('request_receipt_already_paid', isEqualTo: true)
  //               .where('is_paid', isEqualTo: false)
  //               // .orderBy('created_at',
  //               //     descending:
  //               //         true) // Urutkan dari yang terbaru (Z-A / Waktu besar ke kecil)
  //               // .limit(5) // Batasi hanya 5 dokumen
  //               .snapshots(),
  //           builder: (context, snapshot) {
  //             // A. Jika sedang loading
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return const Center(child: CircularProgressIndicator());
  //             }
//
  //             // B. Jika ada Error
  //             if (snapshot.hasError) {
  //               return const Center(child: Text("Terjadi kesalahan"));
  //             }
//
  //             // C. Jika Data Kosong
  //             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //               return const Center(
  //                   child: Text("Belum ada pembayaran tunggu konfirmasi"));
  //             }
//
  //             // D. Jika Data Ada
  //             final documents = snapshot.data!.docs;
//
  //             return ListView.builder(
  //               scrollDirection: Axis.vertical,
  //               itemCount: documents.length,
  //               physics: const AlwaysScrollableScrollPhysics(),
  //               itemBuilder: (context, index) {
  //                 // Ambil data per dokumen
  //                 final data = documents[index].data() as Map<String, dynamic>;
  //                 return ReceiptCustomerCard(
  //                   onTap: () {
  //                     //   // Contoh penggunaan di halaman Home
  //                     //   Navigator.push(
  //                     //     context,
  //                     //     MaterialPageRoute(
  //                     //       builder: (context) => DetailProductPage(
  //                     //         product: Product.fromJson(data),
  //                     //       ),
  //                     //     ),
  //                     //   );
  //                   },
  //                   onRequestPaid: () {
  //                     FirebaseFirestore.instance
  //                         .collection(Receipt.collectionName)
  //                         .doc(Receipt.fromJson(data).id)
  //                         .update({
  //                       'request_receipt_already_paid': true,
  //                       'updated_at': FieldValue.serverTimestamp(),
  //                     }).then((_) {
  //                       // Bagian ini dijalankan NANTI jika SUKSES
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(content: Text("Berhasil update!")),
  //                       );
  //                     }).catchError((error) {
  //                       // Bagian ini dijalankan NANTI jika GAGAL
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         SnackBar(content: Text("Gagal: $error")),
  //                       );
  //                     });
  //                   },
//
  //                   receipt: Receipt.fromJson(data),
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //       ),
//
  //       _buildSectionHeader("Pembayaran Diterima Penjual."),
  //       const SizedBox(height: 10),
  //       SizedBox(
  //         height: 240,
  //         child: StreamBuilder<QuerySnapshot>(
  //           // 1. Query ke Firestore
  //           stream: FirebaseFirestore.instance
  //               .collection(Receipt.collectionName)
  //               .where('user_id', isEqualTo: userId)
  //               .where('request_receipt_already_paid', isEqualTo: true)
  //               .where('is_paid', isEqualTo: true)
  //               // .orderBy('created_at',
  //               //     descending:
  //               //         true) // Urutkan dari yang terbaru (Z-A / Waktu besar ke kecil)
  //               // .limit(5) // Batasi hanya 5 dokumen
  //               .snapshots(),
  //           builder: (context, snapshot) {
  //             // A. Jika sedang loading
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return const Center(child: CircularProgressIndicator());
  //             }
//
  //             // B. Jika ada Error
  //             if (snapshot.hasError) {
  //               return const Center(child: Text("Terjadi kesalahan"));
  //             }
//
  //             // C. Jika Data Kosong
  //             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //               return const Center(
  //                   child:
  //                       Text("Belum ditemukan informasi pembayaran diterima."));
  //             }
//
  //             // D. Jika Data Ada
  //             final documents = snapshot.data!.docs;
//
  //             return ListView.builder(
  //               scrollDirection: Axis.vertical,
  //               itemCount: documents.length,
  //               physics: const AlwaysScrollableScrollPhysics(),
  //               itemBuilder: (context, index) {
  //                 // Ambil data per dokumen
  //                 final data = documents[index].data() as Map<String, dynamic>;
  //                 return ReceiptCustomerCard(
  //                   onTap: () {
  //                     //   // Contoh penggunaan di halaman Home
  //                     //   Navigator.push(
  //                     //     context,
  //                     //     MaterialPageRoute(
  //                     //       builder: (context) => DetailProductPage(
  //                     //         product: Product.fromJson(data),
  //                     //       ),
  //                     //     ),
  //                     //   );
  //                   },
  //                   onRequestPaid: () {
  //                     FirebaseFirestore.instance
  //                         .collection(Receipt.collectionName)
  //                         .doc(Receipt.fromJson(data).id)
  //                         .update({
  //                       'request_receipt_already_paid': true,
  //                       'updated_at': FieldValue.serverTimestamp(),
  //                     }).then((_) {
  //                       // Bagian ini dijalankan NANTI jika SUKSES
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(content: Text("Berhasil update!")),
  //                       );
  //                     }).catchError((error) {
  //                       // Bagian ini dijalankan NANTI jika GAGAL
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         SnackBar(content: Text("Gagal: $error")),
  //                       );
  //                     });
  //                   },
//
  //                   receipt: Receipt.fromJson(data),
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
//
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: appbar,
  //     body: body,
  //     bottomNavigationBar: _buildBottomNav(context),
  //   );
  // }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text("See All >",
            style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildBottomNav(context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, "Home", false, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerHomePage(),
              ),
            );
          }),
          _navItem(Icons.shopping_cart_outlined, "Cart", false, badge: "0",
              onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerCartPage(),
              ),
            );
          }),
          _navItem(Icons.point_of_sale, "To Paid", true,
              badge: "0", onTap: () {}),
          _navItem(Icons.delivery_dining, "On Delivery", false, badge: "0",
              onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerDeliveryPage(),
              ),
            );
          }),
          _navItem(Icons.check_circle, "Finished", false, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerFinishedOrderPage(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive,
      {String? badge, onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.pink[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Icon(icon, color: isActive ? Colors.pink : Colors.grey),
                if (badge != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      constraints:
                          const BoxConstraints(minWidth: 12, minHeight: 12),
                      child: Text(badge,
                          style:
                              const TextStyle(color: Colors.white, fontSize: 8),
                          textAlign: TextAlign.center),
                    ),
                  )
              ],
            ),
            if (isActive) const SizedBox(width: 8),
            if (isActive)
              Text(label,
                  style: const TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
