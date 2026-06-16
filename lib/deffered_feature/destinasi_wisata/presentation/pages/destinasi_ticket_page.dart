import 'package:flutter/material.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/entity/destination_ticket_entity.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:majadigi/core/widgets/custom_header.dart';

class DestinasiTicketPage extends StatelessWidget {
  final DestinationTicketEntity ticket;

  const DestinasiTicketPage({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: 'Pemesanan Berhasil!',
              subtitle: 'Simpan tiket ini sebagai bukti masuk destinasi',
              showBackButton: false,
              trailing: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.check, color: Colors.white),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      'Nomor Pesanan Anda',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            ticket.orderNumber.toString().padLeft(3, '0'),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Destinasi',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            ticket.destinationName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: Color(0xFFEEEEEE)),
                          const SizedBox(height: 16),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Nama', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              Text(ticket.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tanggal', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              Text(ticket.date, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Jumlah Tiket', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              Text('${ticket.totalTicket} Orang', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          QrImageView(
                            data: ticket.id,
                            version: QrVersions.auto,
                            size: 150.0,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            ticket.id,
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0065FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
