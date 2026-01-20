import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';

class ProductQuantityDetail {
  final Product product;
  final String quantity;

  const ProductQuantityDetail({
    this.product = const Product(),
    this.quantity = "0",
  });

  @override
  String toString() {
    return "ProductQuantityDetail(product:$product, quantity: $quantity);";
  }

  // Convert Data Cart ke JSON untuk dikirim ke Firestore
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory ProductQuantityDetail.fromJson(Map<String, dynamic> jsonObject) {
    return ProductQuantityDetail(
        product: Product.fromJson(jsonObject['product']),
        quantity: jsonObject['quantity']);
  }
}
