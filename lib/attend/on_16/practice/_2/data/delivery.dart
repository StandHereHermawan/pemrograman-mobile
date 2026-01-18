
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/hampers.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';

class Deliveries {
  static const String collectionName = "deliveries";
  final String id;
  final String userId;
  final String receiptId;
  final List<Product> productReceiptCollection;
  final List<Hampers> hampersReceiptCollection;
  final String totalPrice;
  final bool isArrived;
  final bool isReceived;

  const Deliveries({
    this.id = "0",
    this.hampersReceiptCollection = const [],
    this.productReceiptCollection = const [],
    this.userId = "0",
    this.totalPrice = "0",
    this.receiptId = "0",
    this.isArrived = false,
    this.isReceived = false,
  });
}