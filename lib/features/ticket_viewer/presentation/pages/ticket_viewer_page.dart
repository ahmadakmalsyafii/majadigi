import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/widgets/custom_header.dart';
import '../bloc/ticket_viewer_bloc.dart';
import '../bloc/ticket_viewer_event.dart';
import '../bloc/ticket_viewer_state.dart';

class TicketViewerPage extends StatelessWidget {
  final String ticketId;
  final String type;

  const TicketViewerPage({
    super.key,
    required this.ticketId,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<TicketViewerBloc>()..add(FetchTicketDetailEvent(ticketId: ticketId, type: type)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Column(
            children: [
              const CustomHeader(
                title: 'Detail Tiket',
                showBackButton: true,
              ),
              Expanded(
                child: BlocBuilder<TicketViewerBloc, TicketViewerState>(
                  builder: (context, state) {
                    if (state is TicketViewerLoading || state is TicketViewerInitial) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF0048B5)));
                    } else if (state is TicketViewerError) {
                      return Center(child: Text(state.message));
                    } else if (state is TicketViewerLoaded) {
                      final ticket = state.ticket;
                      
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const Text(
                              'Nomor Pesanan Anda',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    ticket.orderNumber.padLeft(3, '0'),
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    ticket.name,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Divider(color: Color(0xFFEEEEEE), height: 1),
                                  ),
                                  // Specific Details
                                  ...ticket.specificDetails.entries.map((entry) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                                        ),
                                        Text(
                                          entry.value.toString(),
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  )),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Divider(color: Color(0xFFEEEEEE), height: 1),
                                  ),
                                  QrImageView(
                                    data: ticket.id,
                                    version: QrVersions.auto,
                                    size: 200.0,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    ticket.id,
                                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
