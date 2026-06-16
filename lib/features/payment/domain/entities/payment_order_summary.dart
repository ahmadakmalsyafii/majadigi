import 'package:equatable/equatable.dart';

class PaymentOrderItem extends Equatable {
  final String label;
  final String value;

  const PaymentOrderItem({
    required this.label,
    required this.value,
  });

  @override
  List<Object?> get props => [label, value];
}

class PaymentOrderSummary extends Equatable {
  final List<PaymentOrderItem> items;
  final String totalPriceLabel;
  final int totalPriceAmount;

  const PaymentOrderSummary({
    required this.items,
    required this.totalPriceLabel,
    required this.totalPriceAmount,
  });

  @override
  List<Object?> get props => [items, totalPriceLabel, totalPriceAmount];
}
