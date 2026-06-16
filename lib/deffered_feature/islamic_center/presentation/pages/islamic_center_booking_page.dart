import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/entity/facility_entity.dart';
import 'package:majadigi/features/payment/domain/entities/payment_order_summary.dart';
import 'package:majadigi/features/payment/presentation/pages/payment_page.dart';
import 'package:majadigi/deffered_feature/islamic_center/presentation/pages/islamic_center_ticket_page.dart';

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/deffered_feature/islamic_center/presentation/bloc/islamic_center_ticket_bloc.dart';

class IslamicCenterBookingPage extends StatefulWidget {
  final RoomEntity room;
  final FacilityEntity
  facility; // Need facility if we want to show facility name

  const IslamicCenterBookingPage({
    super.key,
    required this.room,
    required this.facility,
  });

  @override
  State<IslamicCenterBookingPage> createState() =>
      _IslamicCenterBookingPageState();
}

class _IslamicCenterBookingPageState extends State<IslamicCenterBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  void _onLanjutkan() {
    if (_formKey.currentState!.validate()) {
      final orderSummary = PaymentOrderSummary(
        items: [
          PaymentOrderItem(label: 'Nama Lengkap', value: _nameController.text),
          PaymentOrderItem(
            label: 'Hari dan Tanggal',
            value: _dateController.text,
          ),
          PaymentOrderItem(label: 'Waktu', value: _timeController.text),
          PaymentOrderItem(
            label: 'Fasilitas',
            value: widget.facility.tags.join(', '),
          ),
          PaymentOrderItem(label: 'Tempat', value: widget.room.name),
          PaymentOrderItem(
            label: 'Kapasitas',
            value: '${widget.room.capacity} Orang',
          ),
          PaymentOrderItem(label: 'Tarif', value: widget.room.priceFormatted),
        ],
        totalPriceLabel: 'Total',
        totalPriceAmount: widget.room.priceAmount,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (pageContext) => BlocProvider(
            create: (context) => sl<IslamicCenterTicketBloc>(),
            child: Builder(
              builder: (innerContext) {
                return BlocListener<IslamicCenterTicketBloc, IslamicCenterTicketState>(
                  listener: (context, state) {
                    if (state is IslamicCenterTicketError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Gagal membuat pesanan: ${state.message}',
                          ),
                        ),
                      );
                    } else if (state is IslamicCenterTicketSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              IslamicCenterTicketPage(ticket: state.ticket),
                        ),
                      );
                    }
                  },
                  child: PaymentPage(
                    orderSummary: orderSummary,
                    onProcessPayment: (paymentMethod) async {
                      final completer = Completer<void>();
                      innerContext.read<IslamicCenterTicketBloc>().add(
                        CreateIslamicCenterTicketEvent(
                          userId:
                              FirebaseAuth.instance.currentUser?.uid ??
                              'unknown_user',
                          name: _nameController.text,
                          reservDate: _dateController.text,
                          reservTime: _timeController.text,
                          roomName: widget.room.name,
                          paymentMethod: paymentMethod.name,
                          facilityId: widget.facility.facilityId,
                          roomId: widget.room.roomId,
                          completer: completer,
                        ),
                      );
                      return completer.future;
                    },
                  ),
                );
              },
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
        title: const Text(
          'Kembali',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        titleSpacing: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              decoration: const BoxDecoration(color: Color(0xFF0048B5)),
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
            // Progress Indicator
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 24),
                  SizedBox(width: 8),
                  Text(
                    '···',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      letterSpacing: 2,
                    ),
                  ),
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
                    const Text(
                      'Nama Lengkap',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Nama harus diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Hari dan Tanggal',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Tanggal harus dipilih'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Waktu',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _timeController,
                      readOnly: true,
                      onTap: () => _selectTime(context),
                      decoration: InputDecoration(
                        hintText: '10:30',
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Waktu harus dipilih'
                          : null,
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Rekap Tempat',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tempat',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                widget.room.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Kapasitas',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${widget.room.capacity} Orang',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tarif',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                widget.room.priceFormatted,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
              decoration: const BoxDecoration(color: Colors.white),
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
