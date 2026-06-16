import 'package:flutter/material.dart';
import 'package:majadigi/core/widgets/custom_header.dart';
import 'package:majadigi/features/payment/domain/entities/payment_method_entity.dart';
import 'package:majadigi/features/payment/domain/entities/payment_order_summary.dart';
import 'package:majadigi/features/payment/presentation/widgets/payment_method_bottom_sheet.dart';

class PaymentPage extends StatefulWidget {
  final PaymentOrderSummary orderSummary;
  final Future<void> Function(PaymentMethodEntity) onProcessPayment;

  const PaymentPage({
    super.key,
    required this.orderSummary,
    required this.onProcessPayment,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethodEntity? _selectedMethod;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (availablePaymentMethods.isNotEmpty) {
      _selectedMethod = availablePaymentMethods.first;
    }
  }

  void _showPaymentMethods() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: PaymentMethodBottomSheet(
            selectedMethod: _selectedMethod,
            onMethodSelected: (method) {
              setState(() {
                _selectedMethod = method;
              });
            },
          ),
        );
      },
    );
  }

  Future<void> _processPayment() async {
    if (_selectedMethod == null) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onProcessPayment(_selectedMethod!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0048B5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Kembali',
        ),
        title: const Text('Kembali', style: TextStyle(color: Colors.white, fontSize: 14)),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF0048B5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Langkah 2 dari 2',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pembayaran',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Progress Indicator
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 24),
                const SizedBox(width: 8),
                const Text('···', style: TextStyle(color: Colors.grey, fontSize: 18, letterSpacing: 2)),
                const SizedBox(width: 8),
                const Icon(Icons.circle, color: Colors.green, size: 24),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Metode Pembayaran',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: _showPaymentMethods,
                        child: const Row(
                          children: [
                            Text(
                              'Lihat Semua',
                              style: TextStyle(fontSize: 14, color: Colors.blue),
                            ),
                            Icon(Icons.chevron_right, color: Colors.blue, size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet, color: Colors.black87),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            _selectedMethod?.name ?? 'Pilih Metode Pembayaran',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Icon(Icons.radio_button_checked, color: Colors.blue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Rekap Pesanan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: widget.orderSummary.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      item.label,
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item.value,
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              if (item != widget.orderSummary.items.last) ...[
                                const SizedBox(height: 12),
                                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                              ]
                            ],
                          ),
                        );
                      }).toList(),
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
                onPressed: _isLoading ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0048B5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading 
                    ? const SizedBox(
                        height: 24, width: 24, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text(
                        'Pesan',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
