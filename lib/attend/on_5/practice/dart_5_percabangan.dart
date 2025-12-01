import 'dart:io';

void main() {
  print("### Orang Bikin Program ###");

  stdout.write("Total Rp.: ");
  String? totalBelanja = stdin.readLineSync();
  int nilaiIntTotalBelanja = int.parse("$totalBelanja");

  bool rangeA =
      nilaiIntTotalBelanja >= 10_000_000 && nilaiIntTotalBelanja <= 50_000_000;

  bool rangeB =
      nilaiIntTotalBelanja >= 50_000_000 && nilaiIntTotalBelanja <= 100_000_000;

  bool rangeC = nilaiIntTotalBelanja >= 100_000_000 &&
      nilaiIntTotalBelanja <= 200_000_000;

  bool rangeD = nilaiIntTotalBelanja > 200_000_000;

  if (rangeA) {
    print("Anda mendapatkan diskon 15%!");
  } else if (rangeB) {
    print("Anda mendapatkan diskon 20%!");
  } else if (rangeC) {
    print("Anda mendapatkan diskon 30%!");
  } else if (rangeD) {
    print("Anda mendapatkan diskon 40%!");
  } else {
    print("Anda tidak mendapat diskon");
  }
}
