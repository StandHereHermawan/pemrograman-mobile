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
  final bool isOnProcessToDeliveries;
  final bool requestReceiptAlreadyPaid;
  final String createdAt;
  final String hasBeenPaidAt;

  const Receipt({
    this.id = "0",
    this.hampersReceiptCollection = const <HampersQuantityDetail>[
      HampersQuantityDetail()
    ],
    this.productReceiptCollection = const <ProductQuantityDetail>[
      ProductQuantityDetail()
    ],
    this.userId = "0",
    this.totalPrice = "0",
    this.isPaid = false,
    this.requestReceiptAlreadyPaid = false,
    this.isOnProcessToDeliveries = false,
    this.createdAt = "0",
    this.hasBeenPaidAt = "",
  });

  @override
  String toString() {
    return 'Receipt('
        'id: $id, '
        'userId: $userId, '
        'totalPrice: $totalPrice, '
        'isPaid: $isPaid, '
        'isOnProcessToDeliveries: $isOnProcessToDeliveries, '
        'created_at: $createdAt, '
        'has_been_paid_at: $createdAt, '
        'request_Receipt_Already_Paid: $requestReceiptAlreadyPaid, '
        'products: $productReceiptCollection, '
        'hampers: $hampersReceiptCollection'
        ')';
  }

  // --- FUNCTION FROMJSON ---
  factory Receipt.fromJson(Map<String, dynamic>? json) {
    // 1. Safety check jika data null
    if (json == null) return const Receipt();

    return Receipt(
      id: json['id'] as String? ?? "0",
      userId: json['user_id'] as String? ?? "0",

      // 2. Parsing List Product (List<dynamic> -> List<ProductQuantityDetail>)
      productReceiptCollection: (json['product_receipt_collection']
                  as List<dynamic>?)
              ?.map((item) =>
                  ProductQuantityDetail.fromJson(item as Map<String, dynamic>))
              .toList() ??
          const [], // Jika null, kembalikan list kosong

      // 3. Parsing List Hampers (List<dynamic> -> List<HampersQuantityDetail>)
      hampersReceiptCollection: (json['hampers_receipt_collection']
                  as List<dynamic>?)
              ?.map((item) =>
                  HampersQuantityDetail.fromJson(item as Map<String, dynamic>))
              .toList() ??
          const [], // Jika null, kembalikan list kosong

      totalPrice: json['total_price'] as String? ?? "0",
      createdAt: json['created_at'] as String? ?? "0",
      hasBeenPaidAt: json['has_been_paid_at'] as String? ?? "0",
      isPaid: json['is_paid'] as bool? ?? false,
      isOnProcessToDeliveries: json['is_on_process_to_deliver'] as bool? ?? false,
      requestReceiptAlreadyPaid:
          json['request_receipt_already_paid'] as bool? ?? false,
    );
  }

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
      'is_on_process_to_deliver': isOnProcessToDeliveries,
      'created_at': createdAt,
      'has_been_paid_at': hasBeenPaidAt,
    };
  }
}
