import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/credential.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/helper/login.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/user.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/util/session_manager.dart';

class AuthService {
  final FirebaseFirestore _databaseFirestore = FirebaseFirestore.instance;

  Future<LoginInformation> login(String username, String password) async {
    try {
      // --- LANGKAH 1: Cari User berdasarkan Username ---
      QuerySnapshot userQuery = await _databaseFirestore
          .collection(User.collectionName)
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      // Cek apakah user ada
      if (userQuery.docs.isEmpty) {
        print("Username tidak ditemukan");
        return LoginInformation();
      }

      // Ambil data user
      var userDoc = userQuery.docs.first;
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // --- LANGKAH 2: Verifikasi Password ---
      // (Catatan: Untuk PoC password plain text oke, tapi production WAJIB hashing)
      if (userData['password'] != password) {
        print("Password salah");
        return LoginInformation();
      }
      String
          credentialId; // Variabel untuk menampung ID (baik lama maupun baru)
      String userId = userDoc.id; // Ini ID dokumen user

      // --- LANGKAH 3: Cari Dokumen Kredensial terkait User ini ---
      // Kita cari dokumen di 'credentials' yang field 'user_id' == userId
      QuerySnapshot credQuery = await _databaseFirestore
          .collection(Credential.collectionName)
          .where('user_id', isEqualTo: userId)
          .limit(1) // Asumsi 1 user hanya punya 1 kredensial aktif
          .get();

      if (credQuery.docs.isNotEmpty) {
        // KASUS A: Kredensial SUDAH ADA
        var credDoc = credQuery.docs.first;
        credentialId = credDoc.id;
        print("Credential lama ditemukan: $credentialId");
      } else {
        // KASUS B: Kredensial TIDAK ADA -> BUAT BARU
        print("Credential tidak ditemukan. Membuat credential baru...");

        // Siapkan data credential baru
        Map<String, dynamic> newCredData = {
          // 'id': credentialId,
          'user_id': userId,
          'created_at':
              FieldValue.serverTimestamp(), // Opsional: timestamp pembuatan
        };

        // Simpan ke Firestore dan ambil referensinya
        DocumentReference newCredRef = await _databaseFirestore
            .collection(Credential.collectionName)
            .add(newCredData);

        credentialId = newCredRef.id; // Ambil ID yang baru digenerate
        print("Credential baru berhasil dibuat: $credentialId");
      }

      print("Login Sukses. User ID: $userId, Cred ID: $credentialId");

      // --- LANGKAH 4: Simpan ke SharedPreferences ---
      await SessionManager.saveSession(
        userId: userId,
        credentialId: credentialId,
        username: username,
      );

      log("userData['role'] = ${userData['role']}");

      return LoginInformation(success: true, role: userData['role']);
    } catch (e) {
      print("Error Login: $e");
      return LoginInformation();
    }
  }

  /// Mengambil Role user berdasarkan User ID
  Future<String?> getUserRole(String userId) async {
    try {
      DocumentSnapshot doc = await _databaseFirestore
          .collection(User.collectionName)
          .doc(userId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Pastikan field di firestore namanya 'role'
        return data['role'] as String?;
      }
      return null;
    } catch (e) {
      print("Error getting user role: $e");
      return null;
    }
  }

  /// Menghapus dokumen credential berdasarkan ID
  Future<void> deleteCredential(String credentialId) async {
    try {
      await _databaseFirestore
          .collection(Credential.collectionName)
          .doc(credentialId)
          .delete();
      print("Credential $credentialId berhasil dihapus.");
    } catch (e) {
      print("Gagal menghapus credential: $e");
      // Opsional: throw error jika ingin di-handle di UI
    }
  }
}
