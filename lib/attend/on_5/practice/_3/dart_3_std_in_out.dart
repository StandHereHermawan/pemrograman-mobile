import 'dart:io';

void main() {
  String? nama;
  stdout.write("Masukkan nama: ");
  nama = stdin.readLineSync();
  print("Hello $nama");
}
