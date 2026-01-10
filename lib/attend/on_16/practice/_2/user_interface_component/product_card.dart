import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/product.dart';

class ProductCardPrompted extends StatelessWidget {
  // Mendefinisikan properti sebagai variabel final
  final Product product;
  final String id;
  final String name;
  final String price;
  final String description;
  final String rate;

  // Constructor dengan Named Parameters dan Default Values
  const ProductCardPrompted({
    super.key,
    this.product = const Product(
      id: "Not Have An Id",
      name: "Not Have A Name",
      price: 0,
      description: "100 gr chicken + tomato + cheese Lettuce",
    ),
    this.id = "Not Have An Id",
    this.name = "Not Have A Name",
    this.price = "0.000",
    this.description = "100 gr chicken + tomato + cheese Lettuce",
    this.rate = "4.8",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(left: 3,right: 3),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 16),
              Text(
                rate,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFE0E0E0),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            product.description,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\Rp\.${product.price}",
                style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              )
            ],
          )
        ],
      ),
    );
  }
}
