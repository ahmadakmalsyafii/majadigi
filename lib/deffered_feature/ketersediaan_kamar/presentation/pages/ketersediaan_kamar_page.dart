// import 'package:flutter/material.dart';

// // ─── Model data statis (akan diganti API nanti) ─────────────────────────────

// class _RoomAvailability {
//   final String name;
//   final int available;
//   final int total;
//   final Color color;

//   const _RoomAvailability({
//     required this.name,
//     required this.available,
//     required this.total,
//     required this.color,
//   });
// }

// // ─── Page ────────────────────────────────────────────────────────────────────

// class KetersediaanKamarPage extends StatelessWidget {
//   const KetersediaanKamarPage({super.key});

//   // Data statis — akan diganti dengan data dari API setelah implementasi penuh
//   static const _hospitalName = 'RSUD Dr. Soetomo';
//   static const _hospitalAddress =
//       'Jl. Mayjend. Prof. Dr. Moestopo No. 6-8, Kecamatan Gubeng, '
//       'Kelurahan Airlangga, Kota Surabaya 60286.';
//   static const _bedTersedia = 42;
//   static const _igdTerisi = 8;
//   static const _totalBed = 182;

//   static const _rooms = <_RoomAvailability>[
//     _RoomAvailability(name: 'ICU',     available: 8,  total: 20, color: Color(0xFF016ACC)),
//     _RoomAvailability(name: 'NICU',    available: 8,  total: 20, color: Color(0xFF2ECC71)),
//     _RoomAvailability(name: 'Kelas 1', available: 9,  total: 20, color: Color(0xFFE74C3C)),
//     _RoomAvailability(name: 'Kelas II',available: 9,  total: 20, color: Color(0xFFF39C12)),
//     _RoomAvailability(name: 'Kelas III',available: 10, total: 20, color: Color(0xFF016ACC)),
//     _RoomAvailability(name: 'VIP',     available: 10, total: 20, color: Color(0xFF2ECC71)),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       body: Column(
//         children: [
//           _buildHeader(context),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildSummaryRow(),
//                   const SizedBox(height: 24),
//                   _buildRoomSection(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Header biru ────────────────────────────────────────────────────────────

//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(color: Color(0xFF016ACC)),
//       child: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Top bar: kembali & hapus
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: const Row(
//                       children: [
//                         Icon(Icons.arrow_back_ios,
//                             color: Colors.white, size: 16),
//                         SizedBox(width: 4),
//                         Text('Kembali',
//                             style:
//                                 TextStyle(color: Colors.white, fontSize: 14)),
//                       ],
//                     ),
//                   ),
//                   OutlinedButton.icon(
//                     onPressed: () {},
//                     icon: const Icon(Icons.delete_outline_rounded,
//                         color: Colors.white, size: 16),
//                     label: const Text('Hapus',
//                         style: TextStyle(color: Colors.white, fontSize: 13)),
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Colors.white),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 6),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Hospital name
//               const Text(
//                 _hospitalName,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 6),

//               // Address
//               const Text(
//                 _hospitalAddress,
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 12,
//                   height: 1.5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ── 3 Summary cards ────────────────────────────────────────────────────────

//   Widget _buildSummaryRow() {
//     return Row(
//       children: [
//         _buildSummaryCard(
//           value: '$_bedTersedia',
//           label: 'Bed Tersedia',
//           valueColor: const Color(0xFF2ECC71),
//           bgColor: const Color(0xFFEAFAF1),
//         ),
//         const SizedBox(width: 10),
//         _buildSummaryCard(
//           value: '$_igdTerisi',
//           label: 'IGD Terisi',
//           valueColor: const Color(0xFFE74C3C),
//           bgColor: const Color(0xFFFDEDEC),
//         ),
//         const SizedBox(width: 10),
//         _buildSummaryCard(
//           value: '$_totalBed',
//           label: 'Total Bed',
//           valueColor: const Color(0xFF016ACC),
//           bgColor: const Color(0xFFE8F4FD),
//         ),
//       ],
//     );
//   }

//   Widget _buildSummaryCard({
//     required String value,
//     required String label,
//     required Color valueColor,
//     required Color bgColor,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: valueColor,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 11,
//                 color: Colors.grey,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Room grid ──────────────────────────────────────────────────────────────

//   Widget _buildRoomSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Ketersediaan Kamar Rawat Inap',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1A1A2E),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.04),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.all(16),
//           child: GridView.count(
//             crossAxisCount: 2,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             mainAxisSpacing: 12,
//             crossAxisSpacing: 12,
//             childAspectRatio: 1.6,
//             children: _rooms
//                 .map((room) => _buildRoomCard(room))
//                 .toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRoomCard(_RoomAvailability room) {
//     final progress = room.available / room.total;
//     return Container(
//       padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade200),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             room.name,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1A1A2E),
//             ),
//           ),
//           Text(
//             '${room.available}',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: room.color,
//             ),
//           ),
//           Text(
//             'dari ${room.total} tersedia',
//             style: const TextStyle(fontSize: 11, color: Colors.grey),
//           ),
//           const SizedBox(height: 4),
//           // Progress bar
//           ClipRRect(
//             borderRadius: BorderRadius.circular(4),
//             child: LinearProgressIndicator(
//               value: progress,
//               minHeight: 5,
//               backgroundColor: Colors.grey.shade200,
//               valueColor: AlwaysStoppedAnimation<Color>(room.color),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
