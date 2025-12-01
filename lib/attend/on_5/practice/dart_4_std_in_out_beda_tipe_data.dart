import 'dart:io';

void main() {
  dynamic bilangan_1, bilangan_2, bilangan_3;

  print("OPERATOR pada DART");

  stdout.write("Nilai Bilangan 1: ");
  bilangan_1 = stdin.readLineSync();

  stdout.write("Nilai Bilangan 2: ");
  bilangan_2 = stdin.readLineSync();

  bilangan_3 = int.parse(bilangan_1) + int.parse(bilangan_2);
  stdout.write("Hasil penjumlahan bilangan 1 dan 2: $bilangan_3");
}
