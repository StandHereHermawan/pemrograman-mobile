import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/hampers.dart';

class HampersQuantityDetail {
  final Hampers hampers;
  final String quantity;

  const HampersQuantityDetail({
    this.hampers = const Hampers(),
    this.quantity = "0",
  });

  factory HampersQuantityDetail.fromJson(Map<String, dynamic> jsonObject) {
    return HampersQuantityDetail(
        hampers: Hampers.fromJson(jsonObject['hampers']),
        quantity: jsonObject['quantity']);
  }

  // Convert Data Cart ke JSON untuk dikirim ke Firestore
  Map<String, dynamic> toJson() {
    return {
      'hampers': hampers.toJson(),
      'quantity': quantity,
    };
  }
}
