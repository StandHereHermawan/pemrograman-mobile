import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';

class ProductQuantityDetail {
  final Product product;
  final String quantity;

  const ProductQuantityDetail({
    this.product = const Product(),
    this.quantity = "0",
  });

  // Convert Data Cart ke JSON untuk dikirim ke Firestore
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}
