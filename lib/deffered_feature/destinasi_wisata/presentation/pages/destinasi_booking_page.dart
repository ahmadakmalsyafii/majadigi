import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/entity/destination_entity.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/presentation/bloc/destination_ticket_bloc.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/presentation/pages/destinasi_ticket_page.dart';
import 'package:majadigi/features/payment/domain/entities/payment_order_summary.dart';
import 'package:majadigi/features/payment/presentation/pages/payment_page.dart';

class DestinasiBookingPage extends StatefulWidget {
  final DestinationEntity destination;

  const DestinasiBookingPage({
    super.key,
    required this.destination,
  });

  @override
  State<DestinasiBookingPage> createState() => _DestinasiBookingPageState();
}

class _DestinasiBookingPageState extends State<DestinasiBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  final _dateController = TextEditingController();
  final _totalTicketController = TextEditingController(text: '1');

  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _dateController.dispose();
    _totalTicketController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _onLanjutkan() {
    if (_formKey.currentState!.validate()) {
      final totalTicket = int.tryParse(_totalTicketController.text) ?? 1;
      final totalPrice = totalTicket * widget.destination.priceAmount;

      final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

      final orderSummary = PaymentOrderSummary(
        items: [
          PaymentOrderItem(label: 'Nama Lengkap', value: _nameController.text),
          PaymentOrderItem(label: 'NIK', value: _nikController.text),
          PaymentOrderItem(label: 'Hari dan Tanggal', value: _dateController.text),
          PaymentOrderItem(label: 'Destinasi', value: widget.destination.name),
          PaymentOrderItem(label: 'Jumlah Tiket', value: '$totalTicket Orang'),
          PaymentOrderItem(
            label: 'Tarif', 
            value: '${formatCurrency.format(widget.destination.priceAmount)} x $totalTicket'
          ),
        ],
        totalPriceLabel: 'Total',
        totalPriceAmount: totalPrice,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (pageContext) => BlocProvider(
            create: (context) => sl<DestinationTicketBloc>(),
            child: Builder(
              builder: (innerContext) {
                return BlocListener<DestinationTicketBloc, DestinationTicketState>(
                  listener: (context, state) {
                    if (state is DestinationTicketError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal membuat pesanan: ${state.message}')),
                      );
                    } else if (state is DestinationTicketSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DestinasiTicketPage(ticket: state.ticket),
                        ),
                      );
                    }
                  },
                  child: PaymentPage(
                    orderSummary: orderSummary,
                    onProcessPayment: (paymentMethod) async {
                      final completer = Completer<void>();
                      innerContext.read<DestinationTicketBloc>().add(
                        CreateDestinationTicketEvent(
                          userId: FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user',
                          name: _nameController.text,
                          nik: _nikController.text,
                          date: _dateController.text,
                          totalTicket: totalTicket,
                          paymentMethod: paymentMethod.name,
                          destinationId: widget.destination.id,
                          destinationName: widget.destination.name,
                          priceAmount: widget.destination.priceAmount,
                          completer: completer,
                        )
                      );
                      return completer.future;
                    },
                  ),
                );
              }
            ),
          ),
        ),
      );
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
        ),
        title: const Text('Kembali', style: TextStyle(color: Colors.white, fontSize: 14)),
        titleSpacing: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              decoration: const BoxDecoration(
                color: Color(0xFF0048B5),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Langkah 1 dari 2',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Isi Identitas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 24),
                  SizedBox(width: 8),
                  Text('···', style: TextStyle(color: Colors.grey, fontSize: 18, letterSpacing: 2)),
                  SizedBox(width: 8),
                  Icon(Icons.circle_outlined, color: Colors.grey, size: 24),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nama Lengkap', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Nama Lengkap',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Nama harus diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    const Text('NIK', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nikController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Masukkan NIK',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'NIK harus diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    const Text('Hari dan Tanggal', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        hintText: 'dd/mm/yyyy',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Tanggal harus dipilih' : null,
                    ),
                    const SizedBox(height: 16),

                    const Text('Jumlah Tiket', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _totalTicketController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Jumlah Tiket',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Jumlah tiket harus diisi';
                        if (int.tryParse(value) == null || int.parse(value) < 1) return 'Jumlah tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
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
                  onPressed: _onLanjutkan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0048B5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Lanjutkan',
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
