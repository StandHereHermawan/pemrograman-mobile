class Product {
  static const String collectionName = "products";
  final String id;
  final String name;
  final String description;
  final int price;
  final String createdAt;

  const Product({
    this.id = "0",
    this.name = "Kosong",
    this.description = "Kosong",
    this.price = 0,
    this.createdAt = "kosong",
  });

  @override
  String toString() {
    return "{id:${this.id},name:${this.name},description:${this.description},createdAt:${this.createdAt}}";
  }

  Product.fromJson(Map<String, dynamic>? jsonObject)
      : this(
          id: jsonObject?['id'] as String,
          name: jsonObject?['name'] as String,
          description: jsonObject?['description'] as String,
          price: jsonObject?['price'] as int,
          createdAt: jsonObject?['created_at'] as String,
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


/*

class Product {
  final String id;
  final String name;
  final String description;
  final int price;
  final String createdAt;

  const Product({
    this.id = "0",
    this.name = "Kosong",
    this.description = "Kosong",
    this.price = 0,
    this.createdAt = "kosong",
  });

  @override
  String toString() {
    return "{id:${this.id},name:${this.name},description:${this.description},createdAt:${this.createdAt}}";
  }

  Product.fromJson(Map<String, dynamic>? jsonObject)
      : this(
          id: jsonObject?['id'] as String,
          name: jsonObject?['name'] as String,
          description: jsonObject?['description'] as String,
          price: jsonObject?['price'] as int,
          createdAt: jsonObject?['created_at'] as String,
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

CollectionReference<Product> mahasiswaCollection = FirebaseFirestore
        .instance
        .collection("products")
        .withConverter(fromFirestore: (snapshots, _) {
      return Product.fromJson(snapshots.data());
    }, toFirestore: (mahasiswa, _) {
      return mahasiswa.toJson();
    });

*/