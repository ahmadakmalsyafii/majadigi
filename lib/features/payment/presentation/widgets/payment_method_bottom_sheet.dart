import 'package:flutter/material.dart';
import 'package:majadigi/features/payment/domain/entities/payment_method_entity.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  final PaymentMethodEntity? selectedMethod;
  final Function(PaymentMethodEntity) onMethodSelected;

  const PaymentMethodBottomSheet({
    super.key,
    this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Separate into E-Wallet and Virtual Account for better grouping if needed, 
    // or just list them all. Based on requirements, just listing them.
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pilih Metode Pembayaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: availablePaymentMethods.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final method = availablePaymentMethods[index];
                final isSelected = selectedMethod?.id == method.id;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.account_balance_wallet, color: Colors.blue), // Placeholder icon
                  title: Text(
                    method.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.blue)
                      : const Icon(Icons.circle_outlined, color: Colors.grey),
                  onTap: () {
                    onMethodSelected(method);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Helper constant for text style to fix compilation if not imported
const FontWeight bold = FontWeight.bold;
