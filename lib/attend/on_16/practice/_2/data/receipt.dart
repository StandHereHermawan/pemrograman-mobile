import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/helper/hampers_quantity_detail.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/helper/product_quantity_detail.dart';

class Receipt {
  static const String collectionName = "receipts";
  final String id;
  final String userId;
  final List<ProductQuantityDetail> productReceiptCollection;
  final List<HampersQuantityDetail> hampersReceiptCollection;
  final String totalPrice;
  final bool isPaid;
  final bool requestReceiptAlreadyPaid;

  const Receipt({
    this.id = "0",
    this.hampersReceiptCollection = const <HampersQuantityDetail>[HampersQuantityDetail()],
    this.productReceiptCollection = const <ProductQuantityDetail>[ProductQuantityDetail()],
    this.userId = "0",
    this.totalPrice = "0",
    this.isPaid = false,
    this.requestReceiptAlreadyPaid = false,
  });

  // --- FUNCTION TOJSON ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,

      // Mengubah List<Product> menjadi List<Map>
      'product_receipt_collection':
          productReceiptCollection.map((product) => product.toJson()).toList(),

      // Mengubah List<Hampers> menjadi List<Map>
      'hampers_receipt_collection':
          hampersReceiptCollection.map((hampers) => hampers.toJson()).toList(),

      'total_price': totalPrice,
      'is_paid': isPaid,
      'request_receipt_already_paid': requestReceiptAlreadyPaid,
    };
  }
}
