import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/helper/hampers_quantity_detail.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/helper/product_quantity_detail.dart';

class Deliveries {
  static const String collectionName = "deliveries";
  final String id;
  final String userId;
  final String receiptId;
  final List<ProductQuantityDetail> productDeliveriesCollection;
  final List<HampersQuantityDetail> hampersDeliveriesCollection;
  final bool isOnDelivery;
  final bool isReceived;
  final String createdAt;
  final String onDeliveryAt;
  final String receivedAt;

  const Deliveries({
    this.id = "0",
    this.hampersDeliveriesCollection = const [],
    this.productDeliveriesCollection = const [],
    this.userId = "0",
    this.receiptId = "0",
    this.createdAt = "0",
    this.onDeliveryAt = "0",
    this.receivedAt = "0",
    this.isOnDelivery = false,
    this.isReceived = false,
  });

  // --- 1. FACTORY FROM JSON (Menerima Data dari Firestore) ---
  factory Deliveries.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Deliveries();

    return Deliveries(
      id: json['id'] as String? ?? "0",
      userId: json['user_id'] as String? ?? "0",
      receiptId: json['receipt_id'] as String? ?? "0",

      // Parsing List Product (List<dynamic> -> List<Product>)
      productDeliveriesCollection:
          (json['product_receipt_collection'] as List<dynamic>?)
                  ?.map((e) => ProductQuantityDetail.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],

      // Parsing List Hampers (List<dynamic> -> List<Hampers>)
      hampersDeliveriesCollection:
          (json['hampers_receipt_collection'] as List<dynamic>?)
                  ?.map((e) => HampersQuantityDetail.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],

      isOnDelivery: json['is_on_delivery'] as bool? ?? false,
      isReceived: json['is_received'] as bool? ?? false,

      createdAt: json['created_at'] as String? ?? "0",
      onDeliveryAt: json['on_delivery_at'] as String? ?? "0",
      receivedAt: json['received_at'] as String? ?? "0",
    );
  }

  // --- 2. METHOD TO JSON (Mengirim Data ke Firestore) ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'receipt_id': receiptId,

      // Convert List<Object> menjadi List<Map>
      'product_receipt_collection':
          productDeliveriesCollection.map((e) => e.toJson()).toList(),
      'hampers_receipt_collection':
          hampersDeliveriesCollection.map((e) => e.toJson()).toList(),

      'is_on_delivery': isOnDelivery,
      'is_received': isReceived,
      'created_at': createdAt,
      'on_delivery_at': onDeliveryAt,
      'received_at': receivedAt,
    };
  }

  @override
  String toString() {
    return 'Deliveries('
        'id: $id, '
        'userId: $userId, '
        'receiptId: $receiptId, '
        'createdAt: $createdAt, '
        'onDeliveryAt: $onDeliveryAt, '
        'receivedAt: $receivedAt, '
        'isReceived: $isReceived, '
        'isOnDelivery: $isOnDelivery, '
        'products: $productDeliveriesCollection, '
        'hampers: $hampersDeliveriesCollection'
        ')';
  }
}
