import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      // --- KHUSUS WEB (CHROME) ---
      // Isi data ini dari Firebase Console -> Project Settings -> General -> Your Apps -> Web
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDSdlGuhkqUmeV9C0s2OC5zpWAAgCLE1UY",
            authDomain: "pertemuan-10-e1ace.firebaseapp.com",
            projectId: "pertemuan-10-e1ace",
            storageBucket: "pertemuan-10-e1ace.firebasestorage.app",
            messagingSenderId: "616730303962",
            appId: "1:616730303962:web:b7407f718e8157e13434e3",
            measurementId: "G-N1G154XMZX"),
      );
      log("Flutter Web Chrome!");
    } else {
      // --- KHUSUS ANDROID & IOS ---
      // Otomatis baca google-services.json
      await Firebase.initializeApp();
    }

    log("Firebase berhasil terhubung!");
  } catch (e) {
    log("Gagal inisialisasi Firebase: $e");
  }

  runApp(const MaterialApp(
      home: MyHomePage(title: 'Flutter & Firebase'),
      debugShowCheckedModeBanner: false));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dynamic textGrateful = const Text(
      'Thanks for accessing this app :)',
    );

    final dynamic textNumberState = Text(
      '$_counter',
      style: Theme.of(context).textTheme.headlineMedium,
    );

    final dynamic floatingActionButton = FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const Icon(
        Icons.add,
      ),
    );

    final dynamic text = Text("Click here");

    final dynamic future = FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          String message = "Error Firebase: ${snapshot.error}";
          log(message);
          return WidgetNotification(message: message);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          log("Snapshot connection state done.");
          return Expanded(child: WidgetListMahasiswa());
        }

        return Center(child: CircularProgressIndicator());
      },
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[future, text, textNumberState, textGrateful],
          ),
        ),
        floatingActionButton: floatingActionButton);
  }
}

class WidgetListMahasiswa extends StatelessWidget {
  const WidgetListMahasiswa({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference<Mahasiswa> mahasiswaCollection = FirebaseFirestore
        .instance
        .collection("database_1")
        .withConverter(fromFirestore: (snapshots, _) {
      return Mahasiswa.fromJson(snapshots.data());
    }, toFirestore: (mahasiswa, _) {
      return mahasiswa.toJson();
    });

    log("WidgetListMahasiswa build function called.");

    return StreamBuilder<QuerySnapshot<Mahasiswa>>(
        stream: mahasiswaCollection.snapshots(),
        builder: (contextStream, snapshotStream) {
          log("snapshotStream Anonymous Function Called.");

          if (snapshotStream.connectionState == ConnectionState.active) {
            return ListView(
              children: List<Widget>.generate(
                snapshotStream.data!.size,
                (index) {
                  Mahasiswa data = snapshotStream.data!.docs[index].data();
                  return ItemMahasiswa(mahasiswa: data);
                },
              ),
            );
          }
          if (snapshotStream.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return WidgetNotification(
              message: "Terdapat kesalahan dalam berkomunikasi dengan server.");
        });
  }
}

class ItemMahasiswa extends StatelessWidget {
  final Mahasiswa mahasiswa;
  const ItemMahasiswa({super.key, required this.mahasiswa});

  @override
  Widget build(BuildContext context) {
    final dynamic defaultTextStyle = TextStyle(
        color: Colors.black,
        backgroundColor: Colors.white,
        letterSpacing: 1.5,
        fontSize: 18);

    final dynamic textColumnMahasiswa = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(mahasiswa.nomorPokok.toString(), style: defaultTextStyle),
        SizedBox(
          height: 5,
        ),
        Text(mahasiswa.nama.toString(), style: defaultTextStyle),
        Text(mahasiswa.kelas.toString(), style: defaultTextStyle),
        Text(mahasiswa.jurusan.toString(), style: defaultTextStyle),
      ],
    );

    final dynamic body = Container(
      margin: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[textColumnMahasiswa],
      ),
    );

    return body;
  }
}

class WidgetNotification extends StatelessWidget {
  final String message;

  const WidgetNotification({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final dynamic textMessage = Text(message);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[textMessage],
    );
  }
}

class Mahasiswa {
  final String nomorPokok;
  final String nama;
  final String jurusan;
  final String kelas;

  Mahasiswa(
      {required this.nomorPokok,
      required this.nama,
      required this.jurusan,
      required this.kelas});

  Mahasiswa.fromJson(Map<String, dynamic>? jsonObject)
      : this(
          nomorPokok: jsonObject?['nomor_pokok_mahasiswa'] as String,
          nama: jsonObject?['nama'] as String,
          jurusan: jsonObject?['jurusan'] as String,
          kelas: jsonObject?['kelas'] as String,
        );

  Map<String, dynamic> toJson() {
    return {
      "nomor_pokok_mahasiswa": nomorPokok,
      'nama': nama,
      "jurusan": jurusan,
      "kelas": kelas
    };
  }
}
