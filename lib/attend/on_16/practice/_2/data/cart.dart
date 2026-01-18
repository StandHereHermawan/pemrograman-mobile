import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/helper/product_quantity.dart';

class Cart {
  static const String collectionName = "carts";
  final String id;
  final String userId;
  final List<ProductQuantity> productCollection;
  final String cartType;
  final String createdAt;

  const Cart({
    this.userId = "0",
    this.id = "0",
    this.productCollection = const <ProductQuantity>[ProductQuantity()], // Hanya product atau hampers.
    this.cartType = "product",
    this.createdAt = "kosong",
  });

  @override
  String toString() {
    return "{id:${this.id},createdAt:${this.createdAt}}";
  }

  Cart.fromJson(Map<String, dynamic>? jsonObject)
      : this(
          id: jsonObject?['id'] as String,
          createdAt: jsonObject?['created_at'] as String,
        );

  // Convert Data Cart ke JSON untuk dikirim ke Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_cart': productCollection.map((item) => item.toJson()).toList(), // Mengubah List<Object> menjadi List<Map>
      'cart_type': cartType,
      'created_at': createdAt,
    };
  }
}
