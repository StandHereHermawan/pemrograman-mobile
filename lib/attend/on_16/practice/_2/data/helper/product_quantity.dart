class ProductQuantity {
  final String productId;
  final String quantity;

  const ProductQuantity({
    this.productId = "0",
    this.quantity = "0",
  });

  // Convert Data Cart ke JSON untuk dikirim ke Firestore
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
    };
  }

  factory ProductQuantity.fromJson(Map<String, dynamic> json) {
    return ProductQuantity(
      productId: json['product_id'] as String? ?? "0",
      // Menggunakan .toString() agar aman jika Firestore mengembalikan Int (angka)
      quantity: (json['quantity'] ?? "0").toString(), 
    );
  }

  // Tambahkan ini di file product_quantity.dart Anda
  @override
  String toString() {
    return '{id: $productId, qty: $quantity}';
  }
}
