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
}
