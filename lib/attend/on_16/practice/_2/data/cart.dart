import 'dart:developer';

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
    this.productCollection = const <ProductQuantity>[
      ProductQuantity()
    ], // Hanya product atau hampers.
    this.cartType = "product",
    this.createdAt = "kosong",
  });

  @override
  String toString() {
    return 'Cart('
        'id: $id, '
        'userId: $userId, '
        'cartType: $cartType, '
        'createdAt: $createdAt, '
        'products: $productCollection'
        ')';
  }

  int totalQuantitiesItem() {
    int total = 0;

    for (var i = 0; i < productCollection.length; i++) {
      log("total quantities: ${int.parse(productCollection[i].quantity)}");
      total = total + int.parse(productCollection[i].quantity);
    }

    return total;
  }

  factory Cart.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Cart();

    return Cart(
      id: json['id'] as String? ?? "0",
      userId: json['user_id'] as String? ?? "0",
      cartType: json['cart_type'] as String? ?? "product",
      createdAt: json['created_at'] as String? ?? "kosong",

      // LOGIC PARSING LIST:
      // 1. Ambil data 'product_cart' sebagai List<dynamic>
      // 2. Cek jika null
      // 3. Map (looping) setiap item menjadi objek ProductQuantity
      productCollection: (json['product_cart'] as List<dynamic>?)
              ?.map((item) =>
                  ProductQuantity.fromJson(item as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  // Convert Data Cart ke JSON untuk dikirim ke Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_cart': productCollection
          .map((item) => item.toJson())
          .toList(), // Mengubah List<Object> menjadi List<Map>
      'cart_type': cartType,
      'created_at': createdAt,
    };
  }
}

// class ProductQuantity {
//   final String productId;
//   final String quantity;
// }
