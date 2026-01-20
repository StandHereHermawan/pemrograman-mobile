import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/helper/product_quantity.dart';

class Hampers {
  static const String collectionName = "hampers";
  final String id;
  final String name;
  final String description;
  final List<ProductQuantity> idHampersWithQuantityCollection;
  final int price;
  final String createdAt;

  const Hampers({
    this.id = "0",
    this.name = "Kosong",
    this.description = "Kosong",
    this.idHampersWithQuantityCollection = const <ProductQuantity>[ProductQuantity()],
    this.price = 0,
    this.createdAt = "kosong",
  });

  @override
  String toString() {
    return "{id:${this.id},name:${this.name},description:${this.description},createdAt:${this.createdAt}}";
  }

  Hampers.fromJson(Map<String, dynamic>? jsonObject)
      : this(
          id: jsonObject?['id'] as String,
          name: jsonObject?['name'] as String,
          description: jsonObject?['description'] as String,
          price: jsonObject?['price'] as int,
          createdAt: jsonObject?['created_at'] as String,
          idHampersWithQuantityCollection: jsonObject?[''] as List<ProductQuantity>
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'created_at': createdAt,
    };
  }
}