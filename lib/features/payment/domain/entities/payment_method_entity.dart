import 'package:equatable/equatable.dart';

class PaymentMethodEntity extends Equatable {
  final String id;
  final String name;
  final String iconAssetPath;
  final bool isVirtualAccount;

  const PaymentMethodEntity({
    required this.id,
    required this.name,
    required this.iconAssetPath,
    this.isVirtualAccount = false,
  });

  @override
  List<Object?> get props => [id, name, iconAssetPath, isVirtualAccount];
}

// Dummy data for available payment methods
final List<PaymentMethodEntity> availablePaymentMethods = [
  const PaymentMethodEntity(
    id: 'gopay',
    name: 'Gopay',
    iconAssetPath: 'assets/icons/ic_gopay.png',
  ),
  const PaymentMethodEntity(
    id: 'shopeepay',
    name: 'Shopee Pay',
    iconAssetPath: 'assets/icons/ic_shopeepay.png',
  ),
  const PaymentMethodEntity(
    id: 'va_mandiri',
    name: 'Virtual Account Mandiri',
    iconAssetPath: 'assets/icons/ic_mandiri.png',
    isVirtualAccount: true,
  ),
  const PaymentMethodEntity(
    id: 'va_bri',
    name: 'Virtual Account BRI',
    iconAssetPath: 'assets/icons/ic_bri.png',
    isVirtualAccount: true,
  ),
  const PaymentMethodEntity(
    id: 'va_bni',
    name: 'Virtual Account BNI',
    iconAssetPath: 'assets/icons/ic_bni.png',
    isVirtualAccount: true,
  ),
];
