import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/delivery.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/receipt.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/admin/admin_delivery.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/admin/admin_finished_order.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/admin/home.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/page/login.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/user_interface_component/appbar.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/user_interface_component/receipt_card_admin.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/util/session_manager.dart';

class AdminReceiptPage extends StatefulWidget {
  const AdminReceiptPage({super.key});

  @override
  State<AdminReceiptPage> createState() => _AdminReceiptPageState();
}

class _AdminReceiptPageState extends State<AdminReceiptPage> {

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

  // --- LOGIKA UTAMA CEK SESI ---
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
    final dynamic appbar = CustomAppBar(title: "Admin Receipt");

    final dynamic body = ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionHeader("Tunggu Konfirmasi Pembayaran Masuk"),
        const SizedBox(height: 10),
        SizedBox(
          height: 240,
          child: StreamBuilder<QuerySnapshot>(
            // 1. Query ke Firestore
            stream: FirebaseFirestore.instance
                .collection(Receipt.collectionName)
                .where('request_receipt_already_paid', isEqualTo: true)
                .where('is_paid', isEqualTo: false)
                .where('is_on_process_to_deliver', isEqualTo: false)
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
                  return ReceiptAdminCard(
                    onTap: () {},
                    onConfirmPayment: () {
                      // 1. Panggil Firestore
                      FirebaseFirestore.instance
                          .collection(Receipt.collectionName)
                          .doc(Receipt.fromJson(data).id)
                          .update({
                        // Ubah status menjadi bayar
                        'has_been_paid_at': DateTime.now().toString(),
                        'is_paid': true,
                      }).then((_) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Pembayaran berhasil dikonfirmasi!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }).catchError((error) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Gagal konfirmasi: $error"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      });
                    },
                    onRequestPaid: () {
                      FirebaseFirestore.instance
                          .collection(Receipt.collectionName)
                          .doc(Receipt.fromJson(data).id)
                          .update({
                        'request_receipt_already_paid': true,
                        'updated_at': FieldValue.serverTimestamp(),
                      }).then((_) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Berhasil update!")),
                          );
                        }
                      }).catchError((error) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Gagal: $error")),
                          );
                        }
                      });
                    },
                    key: ValueKey(Receipt.fromJson(data).id),
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
            stream: FirebaseFirestore.instance
                .collection(Receipt.collectionName)
                .where('request_receipt_already_paid', isEqualTo: true)
                .where('is_paid', isEqualTo: true)
                .where('is_on_process_to_deliver', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Terjadi kesalahan"));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child:
                        Text("Belum ditemukan informasi pembayaran diterima."));
              }

              final documents = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: documents.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = documents[index].data() as Map<String, dynamic>;
                  return ReceiptAdminCard(
                    onTap: () {},
                    onRequestPaid: () {
                      FirebaseFirestore.instance
                          .collection(Receipt.collectionName)
                          .doc(Receipt.fromJson(data).id)
                          .update({
                        'request_receipt_already_paid': true,
                        'updated_at': FieldValue.serverTimestamp(),
                      }).then((_) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Berhasil update!")),
                          );
                        }
                      }).catchError((error) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Gagal: $error")),
                          );
                        }
                      });
                    },
                    onSend: () {
                      FirebaseFirestore.instance
                          .collection(Receipt.collectionName)
                          .doc(Receipt.fromJson(data).id)
                          .update({
                        'is_on_process_to_deliver': true,
                        'updated_at': FieldValue.serverTimestamp(),
                      }).then((_) {
                        CollectionReference deliveriesRef = FirebaseFirestore
                            .instance
                            .collection(Deliveries.collectionName);

                        DocumentReference newdeliveriesDocumentReference =
                            deliveriesRef.doc();

                        newdeliveriesDocumentReference
                            .set(Deliveries(
                                    id: newdeliveriesDocumentReference.id,
                                    receiptId: Receipt.fromJson(data).id,
                                    hampersDeliveriesCollection:
                                        Receipt.fromJson(data)
                                            .hampersReceiptCollection,
                                    productDeliveriesCollection:
                                        Receipt.fromJson(data)
                                            .productReceiptCollection,
                                    userId: Receipt.fromJson(data).userId,
                                    createdAt: DateTime.now().toString())
                                .toJson())
                            .then((_) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                    "Receipt berhasil ditambahkan ke Deliveries!"),
                              ),
                            );
                          }
                        }).catchError((error) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text("Error: $error")),
                            );
                          }
                        });
                      }).catchError((error) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Gagal: $error")),
                          );
                        }
                      });
                    },
                    key: ValueKey(Receipt.fromJson(data).id),
                    receipt: Receipt.fromJson(data),
                  );
                },
              );
            },
          ),
        ),
        _buildSectionHeader("Pembayaran Proses dikirim."),
        const SizedBox(height: 10),
        SizedBox(
          height: 240,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(Receipt.collectionName)
                .where('request_receipt_already_paid', isEqualTo: true)
                .where('is_paid', isEqualTo: true)
                .where('is_on_process_to_deliver', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Terjadi kesalahan"));
              }
              

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text(
                        "Belum ditemukan informasi pembayaran dalam proses kirim."));
              }

              final documents = snapshot.data!.docs;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: documents.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = documents[index].data() as Map<String, dynamic>;
                  log("Cart: $data");
                  return ReceiptAdminCard(
                    onTap: () {},
                    onRequestPaid: () {
                      FirebaseFirestore.instance
                          .collection(Receipt.collectionName)
                          .doc(Receipt.fromJson(data).id)
                          .update({
                        'request_receipt_already_paid': true,
                        'updated_at': FieldValue.serverTimestamp(),
                      }).then((_) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Berhasil update!")),
                          );
                        }
                      }).catchError((error) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Gagal: $error")),
                          );
                        }
                      });
                    },
                    onSend: () {},
                    key: ValueKey(Receipt.fromJson(data).id),
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

  Widget _buildBottomNav(BuildContext context) {
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
                builder: (context) => AdminHomePage(key: widget.key),
              ),
            );
          }),
          _navItem(Icons.point_of_sale, "To Paid", true, badge: "0", onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminReceiptPage(key: widget.key),
              ),
            );
          }),
          _navItem(Icons.delivery_dining, "To Deliver", false, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminDeliveryPage(key: widget.key),
              ),
            );
          }, badge: "0"),
          _navItem(Icons.check_circle, "Finished", false, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminFinishedOrderPage(key: widget.key),
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
