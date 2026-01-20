import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/delivery.dart'; // Sesuaikan path import

class DeliveryAdminCard extends StatelessWidget {
  final Deliveries delivery;
  final VoidCallback onTap;
  
  // Callback untuk memulai pengiriman (Set isOnDelivery = true)
  final VoidCallback? onStartDelivery; 

  const DeliveryAdminCard({
    super.key,
    required this.delivery,
    required this.onTap,
    this.onStartDelivery,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Generate Item Summary String
    List<String> itemNames = [];
    for (var item in delivery.productDeliveriesCollection) {
      itemNames.add("${item.product.name} (x${item.quantity})");
    }
    for (var item in delivery.hampersDeliveriesCollection) {
      itemNames.add("${item.hampers.name} (x${item.quantity})");
    }
    String itemsSummary = itemNames.isEmpty ? "No Items" : itemNames.join(", ");

    // 2. Determine Status Color & Text
    bool isDelivering = delivery.isOnDelivery;
    bool isReceived = delivery.isReceived;

    Color statusColor;
    String statusText;
    IconData statusIconMain;

    if (isReceived) {
      statusColor = Colors.green;
      statusText = "RECEIVED";
      statusIconMain = Icons.home_work_outlined;
    } else if (isDelivering) {
      statusColor = Colors.blue;
      statusText = "ON WAY";
      statusIconMain = Icons.local_shipping_outlined;
    } else {
      statusColor = Colors.red; // Atau Orange
      statusText = "PENDING";
      statusIconMain = Icons.inventory_2_outlined;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.blue.withOpacity(0.1),
          highlightColor: Colors.blue.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // --- A. Left Side: Icon & Status ---
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 60,
                        width: 60,
                        color: statusColor.withOpacity(0.1),
                        child: Center(
                          child: Icon(
                            statusIconMain,
                            color: statusColor,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 15),

                // --- B. Middle: Delivery Info ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Delivery ID: ${delivery.id}", 
                        style: const TextStyle(color: Colors.grey, fontSize: 10)
                      ),
                      
                      const SizedBox(height: 4),
                      
                      const Text(
                        "Shipping",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Ref Receipt ID
                      Text(
                        "Ref Receipt: ${delivery.receiptId}",
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Items Summary
                      Text(
                        itemsSummary,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 8),

                      // Timestamps Logic
                      if (isReceived)
                         Text("Diterima: ${delivery.receivedAt}", style: const TextStyle(fontSize: 10, color: Colors.grey))
                      else if (isDelivering)
                         Text("Dikirim: ${delivery.onDeliveryAt}", style: const TextStyle(fontSize: 10, color: Colors.blue))
                      else
                         Text("Dibuat: ${delivery.createdAt}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),

                // --- C. Right Side: Actions ---
                
                // 1. Kondisi Sudah Diterima (Selesai)
                if (isReceived)
                  const Icon(Icons.check_circle, color: Colors.green, size: 24)

                // 2. Kondisi Sedang Diantar (On Delivery)
                else if (isDelivering)
                   const Icon(Icons.delivery_dining, color: Colors.blue, size: 24)

                // 3. Kondisi Belum Diantar (Pending) -> TAMPILKAN TOMBOL START
                else if (!isDelivering && onStartDelivery != null)
                  _buildActionButton(
                    icon: Icons.start,
                    label: "Start",
                    color: Colors.blue,
                    onTap: onStartDelivery!,
                  )
                  
                // Fallback jika pending tapi tidak ada callback
                else 
                   const Icon(Icons.pending_actions, color: Colors.red, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk Tombol
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              children: [
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}