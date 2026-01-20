import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/data/receipt.dart'; // Adjust import path

class ReceiptAdminCard extends StatelessWidget {
  final Receipt receipt;
  final VoidCallback onTap;
  final VoidCallback?
      onRequestPaid; // Action to change requestReceiptAlreadyPaid to true
// Callback BARU: Untuk Admin mengonfirmasi pembayaran
  final VoidCallback? onConfirmPayment;
  // 1. Callback BARU: Untuk aksi Kirim Barang
  final VoidCallback? onSend;

  const ReceiptAdminCard({
    super.key,
    required this.receipt,
    required this.onTap,
    this.onRequestPaid,
    this.onConfirmPayment,
    this.onSend, // Tambahkan di constructor
  });

  @override
  Widget build(BuildContext context) {
    // 1. Format ID (Shorten for display)
    // String shortId = receipt.id.length > 6
    //     ? "#${receipt.id.substring(0, 6)}..."
    //     : "#${receipt.id}";

    // 2. Generate Item Summary String
    // Combine Product names and Hampers names into a single string
    List<String> itemNames = [];
    for (var item in receipt.productReceiptCollection) {
      itemNames.add("${item.product.name} (x${item.quantity})");
    }
    for (var item in receipt.hampersReceiptCollection) {
      itemNames.add("${item.hampers.name} (x${item.quantity})");
    }
    String itemsSummary = itemNames.isEmpty ? "No Items" : itemNames.join(", ");

    // 3. Determine Status Color & Text
    bool isPaid = receipt.isPaid;
    bool isRequesting = receipt.requestReceiptAlreadyPaid;

    Color statusColor =
        isPaid ? Colors.green : (isRequesting ? Colors.orange : Colors.red);
    String statusText =
        isPaid ? "PAID" : (isRequesting ? "WAITING APPROVAL" : "UNPAID");

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
          splashColor: Colors.pink.withOpacity(0.1),
          highlightColor: Colors.pink.withOpacity(0.05),
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
                            Icons.receipt_long_outlined,
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

                // --- B. Middle: Receipt Info ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "id: ${receipt.id}",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Receipt ID
                      Text(
                        "Receipt",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Items Summary (Truncated)
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

                      // Total Price
                      Text(
                        "Total: Rp.${receipt.totalPrice}",
                        style: const TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      // Receipt Created At
                      if (!isPaid)
                        Text(
                          receipt.createdAt,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),

                      // Receipt Has been paid at
                      if (isPaid)
                        Text(
                          "dibayar tanggal: ${receipt.hasBeenPaidAt}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),

                      // Sedang dikirim
                      if (receipt.isOnProcessToDeliveries)
                        Text(
                          "Sedang Dikirim",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),

                // --- C. Right Side: Request Payment Button ---
                // Only show button if NOT paid and NOT already requesting
                // if (!isPaid && !isRequesting && onRequestPaid != null)
                //   _buildActionButton(
                //     icon: Icons.payment,
                //     label: "Pay",
                //     color: Colors.blue,
                //     onTap: onRequestPaid!,
                //   )
                //

                // 2. Kondisi Sudah Bayar (Icon Centang)
                if (isPaid)
                  Row(
                    mainAxisSize: MainAxisSize.min, // Agar tidak makan tempat
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 24),

                      // Cek jika ada fungsi kirim yang dilempar dari parent
                      if (onSend != null &&
                          !receipt.isOnProcessToDeliveries) ...[
                        const SizedBox(
                            width: 10), // Jarak antara ceklis dan tombol
                        _buildActionButton(
                          icon: Icons.send, // Icon Kirim
                          label: "Kirim",
                          color: Colors.blue, // Warna Biru
                          onTap: onSend!,
                        ),
                      ]
                    ],
                  )

                // 3. Kondisi Waiting Approval (TOMBOL KONFIRMASI BARU)
                // Jika user minta konfirmasi, muncul tombol ini untuk Admin
                else if (isRequesting && onConfirmPayment != null)
                  _buildActionButton(
                    icon: Icons.verified_user, // Icon verifikasi
                    label: "Confirm",
                    color: Colors.green, // Warna hijau tanda setuju
                    onTap: onConfirmPayment!,
                  )

                // Fallback jika requesting tapi tidak ada fungsi callback (Icon jam pasir)
                else if (isRequesting)
                  const Icon(Icons.hourglass_top,
                      color: Colors.orange, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget agar kode lebih rapi dan tombol konsisten
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
