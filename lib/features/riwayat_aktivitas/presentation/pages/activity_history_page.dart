import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/activity_history_bloc.dart';
import '../bloc/activity_history_event.dart';
import '../bloc/activity_history_state.dart';
import '../widgets/activity_history_card.dart';
import '../widgets/activity_history_shimmer.dart';
import 'package:majadigi/core/widgets/custom_header.dart';
class ActivityHistoryPage extends StatefulWidget {
  final String userId; // Pass user ID to fetch their history

  const ActivityHistoryPage({super.key, required this.userId});

  @override
  State<ActivityHistoryPage> createState() => _ActivityHistoryPageState();
}

class _ActivityHistoryPageState extends State<ActivityHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<ActivityHistoryBloc>().add(FetchActivityHistories(userId: widget.userId));
  }

  void _navigateToDetail(BuildContext context, String type, String ticketId) {
    context.pushNamed(
      'ticket_viewer',
      extra: {
        'ticketId': ticketId,
        'type': type,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const CustomHeader(
            title: 'Riwayat Aktivitas',
          ),
           Expanded(
             child: BlocBuilder<ActivityHistoryBloc, ActivityHistoryState>(
               builder: (context, state) {
                 if (state is ActivityHistoryLoading) {
                   return const ActivityHistoryShimmer(itemCount: 5);
                 } else if (state is ActivityHistoryError) {
                   return Center(child: Text(state.message));
                 } else if (state is ActivityHistoryLoaded) {
                   final histories = state.histories;

                   if (histories.isEmpty) {
                     return const Center(child: Text('Belum ada riwayat aktivitas'));
                   }

                   return ListView.builder(
                     padding: const EdgeInsets.all(16),
                     itemCount: histories.length,
                     itemBuilder: (context, index) {
                       final history = histories[index];
                       return ActivityHistoryCard(
                         history: history,
                         onTap: () => _navigateToDetail(context, history.type, history.ticketId),
                       );
                     },
                   );
                 }
                 return const SizedBox.shrink();
               },
             ),
           ),
        ],
      ),
    );
  }
}
