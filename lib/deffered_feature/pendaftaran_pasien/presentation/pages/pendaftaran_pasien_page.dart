// import 'package:flutter/material.dart';

// class PendaftaranPasienPage extends StatefulWidget {
//   const PendaftaranPasienPage({super.key});

//   @override
//   State<PendaftaranPasienPage> createState() => _PendaftaranPasienPageState();
// }

// class _PendaftaranPasienPageState extends State<PendaftaranPasienPage> {
//   int _currentStep = 0;

//   // State untuk menyimpan pilihan user
//   String? _selectedPoli;
//   String? _selectedDoctor;
//   String? _selectedDate;
//   String? _selectedTime;
//   String _searchQuery = '';

//   // Data Dummy
//   final List<Map<String, dynamic>> _polis = [
//     {'name': 'Poli Umum', 'doctors': 5, 'quota': 100},
//     {'name': 'Poli Gigi', 'doctors': 3, 'quota': 50},
//     {'name': 'Poli Anak', 'doctors': 4, 'quota': 80},
//     {'name': 'Poli Jantung', 'doctors': 2, 'quota': 40},
//     {'name': 'Poli Mata', 'doctors': 3, 'quota': 60},
//     {'name': 'Poli THT', 'doctors': 2, 'quota': 45},
//     {'name': 'Poli Kandungan', 'doctors': 4, 'quota': 70},
//   ];

//   final List<Map<String, dynamic>> _doctors = [
//     {'name': 'dr. Budi Santoso', 'spesialis': 'Spesialis Umum', 'jadwal': 'Senin - Jumat, 08:00 - 14:00', 'kuota': 15},
//     {'name': 'dr. Siti Aminah', 'spesialis': 'Spesialis Umum', 'jadwal': 'Senin, Rabu, Jumat, 09:00 - 15:00', 'kuota': 5},
//     {'name': 'dr. Andi Setiawan', 'spesialis': 'Spesialis Umum', 'jadwal': 'Selasa, Kamis, 10:00 - 16:00', 'kuota': 20},
//   ];

//   final List<Map<String, dynamic>> _dates = [
//     {'hari': 'Senin', 'tanggal': '12', 'bulan': 'Mei'},
//     {'hari': 'Selasa', 'tanggal': '13', 'bulan': 'Mei'},
//     {'hari': 'Rabu', 'tanggal': '14', 'bulan': 'Mei'},
//     {'hari': 'Kamis', 'tanggal': '15', 'bulan': 'Mei'},
//     {'hari': 'Jumat', 'tanggal': '16', 'bulan': 'Mei'},
//   ];

//   final List<Map<String, dynamic>> _times = [
//     {'time': '08:00 - 09:00', 'kuota': 5},
//     {'time': '09:00 - 10:00', 'kuota': 2},
//     {'time': '10:00 - 11:00', 'kuota': 0},
//     {'time': '13:00 - 14:00', 'kuota': 10},
//     {'time': '14:00 - 15:00', 'kuota': 8},
//   ];

//   void _nextStep() {
//     if (_currentStep < 3) {
//       setState(() {
//         _currentStep++;
//         // Reset pilihan bawahnya jika user ganti step
//         if (_currentStep == 1 && _selectedDoctor == null) _searchQuery = '';
//       });
//     }
//   }

//   void _prevStep() {
//     if (_currentStep > 0) {
//       setState(() {
//         _currentStep--;
//       });
//     } else {
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       body: Column(
//         children: [
//           _buildHeader(),
//           _buildStepIndicator(),
//           Expanded(
//             child: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               child: _buildCurrentStepContent(),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: _currentStep < 3 ? _buildBottomBar() : null,
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(color: Color(0xFF016ACC)),
//       child: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: _prevStep,
//                 child: const Row(
//                   children: [
//                     Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
//                     SizedBox(width: 4),
//                     Text('Kembali', style: TextStyle(color: Colors.white, fontSize: 14)),
//                   ],
//                 ),
//               ),
//               const Expanded(
//                 child: Center(
//                   child: Text(
//                     'Pendaftaran Pasien',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 60), // Untuk menyeimbangkan posisi teks tengah
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStepIndicator() {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _stepItem(0, 'Poli'),
//               _stepLine(0),
//               _stepItem(1, 'Dokter'),
//               _stepLine(1),
//               _stepItem(2, 'Jadwal'),
//               _stepLine(2),
//               _stepItem(3, 'Tiket'),
//             ],
//           ),
//           if (_currentStep == 2) ...[
//             const SizedBox(height: 20),
//             _buildDateSelector(),
//           ]
//         ],
//       ),
//     );
//   }

//   Widget _stepItem(int stepIndex, String title) {
//     final isActive = _currentStep >= stepIndex;
//     final isCurrent = _currentStep == stepIndex;
//     return Column(
//       children: [
//         Container(
//           width: 28,
//           height: 28,
//           decoration: BoxDecoration(
//             color: isActive ? const Color(0xFF016ACC) : Colors.grey.shade300,
//             shape: BoxShape.circle,
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             '${stepIndex + 1}',
//             style: TextStyle(
//               color: isActive ? Colors.white : Colors.grey.shade600,
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           title,
//           style: TextStyle(
//             color: isActive ? const Color(0xFF016ACC) : Colors.grey.shade600,
//             fontSize: 12,
//             fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _stepLine(int stepIndex) {
//     final isActive = _currentStep > stepIndex;
//     return Expanded(
//       child: Container(
//         height: 2,
//         margin: const EdgeInsets.symmetric(horizontal: 4).copyWith(bottom: 20),
//         color: isActive ? const Color(0xFF016ACC) : Colors.grey.shade300,
//       ),
//     );
//   }

//   Widget _buildDateSelector() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Pilih Tanggal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//         const SizedBox(height: 12),
//         SizedBox(
//           height: 70,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: _dates.length,
//             itemBuilder: (context, index) {
//               final date = _dates[index];
//               final dateString = '${date['hari']}, ${date['tanggal']} ${date['bulan']}';
//               final isSelected = _selectedDate == dateString;
//               return GestureDetector(
//                 onTap: () => setState(() => _selectedDate = dateString),
//                 child: Container(
//                   width: 65,
//                   margin: const EdgeInsets.only(right: 12),
//                   decoration: BoxDecoration(
//                     color: isSelected ? const Color(0xFF016ACC) : Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: isSelected ? const Color(0xFF016ACC) : Colors.grey.shade300),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         date['hari']!,
//                         style: TextStyle(
//                           color: isSelected ? Colors.white70 : Colors.grey.shade600,
//                           fontSize: 11,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         date['tanggal']!,
//                         style: TextStyle(
//                           color: isSelected ? Colors.white : const Color(0xFF1A1A2E),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Text(
//                         date['bulan']!,
//                         style: TextStyle(
//                           color: isSelected ? Colors.white70 : Colors.grey.shade600,
//                           fontSize: 10,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCurrentStepContent() {
//     switch (_currentStep) {
//       case 0:
//         return _buildStepPoli();
//       case 1:
//         return _buildStepDokter();
//       case 2:
//         return _buildStepJadwal();
//       case 3:
//         return _buildStepTiket();
//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   // ─── STEP 1: POLI ──────────────────────────────────────────────────────────
//   Widget _buildStepPoli() {
//     final filteredPolis = _polis.where((p) => p['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();

//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: TextField(
//             onChanged: (val) => setState(() => _searchQuery = val),
//             decoration: InputDecoration(
//               hintText: 'Cari Poliklinik...',
//               prefixIcon: const Icon(Icons.search, color: Colors.grey),
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: const EdgeInsets.symmetric(vertical: 0),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: Color(0xFF016ACC)),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: ListView.separated(
//             padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
//             itemCount: filteredPolis.length,
//             separatorBuilder: (_, __) => const SizedBox(height: 12),
//             itemBuilder: (context, index) {
//               final poli = filteredPolis[index];
//               final isSelected = _selectedPoli == poli['name'];
//               return GestureDetector(
//                 onTap: () => setState(() => _selectedPoli = poli['name']),
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: isSelected ? const Color(0xFFE8F4FD) : Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: isSelected ? const Color(0xFF016ACC) : Colors.grey.shade200,
//                       width: isSelected ? 2 : 1,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(poli['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                           const SizedBox(height: 4),
//                           Text('${poli['doctors']} Dokter tersedia', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           const Text('Kuota Total', style: TextStyle(color: Colors.grey, fontSize: 11)),
//                           const SizedBox(height: 2),
//                           Text('${poli['quota']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF016ACC))),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   // ─── STEP 2: DOKTER ────────────────────────────────────────────────────────
//   Widget _buildStepDokter() {
//     return ListView.separated(
//       padding: const EdgeInsets.all(20),
//       itemCount: _doctors.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 12),
//       itemBuilder: (context, index) {
//         final doc = _doctors[index];
//         final isSelected = _selectedDoctor == doc['name'];
//         return GestureDetector(
//           onTap: () => setState(() => _selectedDoctor = doc['name']),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: isSelected ? const Color(0xFFE8F4FD) : Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: isSelected ? const Color(0xFF016ACC) : Colors.grey.shade200,
//                 width: isSelected ? 2 : 1,
//               ),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 25,
//                   backgroundColor: Colors.grey.shade200,
//                   child: const Icon(Icons.person, color: Colors.grey),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(doc['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
//                       Text(doc['spesialis'], style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
//                       const SizedBox(height: 12),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
//                           const SizedBox(width: 6),
//                           Expanded(child: Text(doc['jadwal'], style: const TextStyle(fontSize: 12, color: Colors.grey))),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           const Icon(Icons.people_outline, size: 16, color: Colors.green),
//                           const SizedBox(width: 6),
//                           Text('Sisa Kuota Hari ini: ${doc['kuota']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // ─── STEP 3: JADWAL ────────────────────────────────────────────────────────
//   Widget _buildStepJadwal() {
//     return ListView(
//       padding: const EdgeInsets.all(20),
//       children: [
//         const Text('Pilih Waktu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
//         const SizedBox(height: 12),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 2.0,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//           ),
//           itemCount: _times.length,
//           itemBuilder: (context, index) {
//             final t = _times[index];
//             final time = t['time'];
//             final kuota = t['kuota'];
//             final isFull = kuota == 0;
//             final isSelected = _selectedTime == time;

//             return GestureDetector(
//               onTap: isFull ? null : () => setState(() => _selectedTime = time),
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: isFull ? Colors.grey.shade100 : (isSelected ? const Color(0xFFE8F4FD) : Colors.white),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: isFull ? Colors.grey.shade200 : (isSelected ? const Color(0xFF016ACC) : Colors.grey.shade300)),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       time,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: isFull ? Colors.grey : (isSelected ? const Color(0xFF016ACC) : const Color(0xFF1A1A2E)),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       isFull ? 'Penuh' : 'Sisa Kuota: $kuota',
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: isFull ? Colors.red : Colors.green,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   // ─── STEP 4: TIKET ─────────────────────────────────────────────────────────
//   Widget _buildStepTiket() {
//     return Center(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 64),
//             const SizedBox(height: 16),
//             const Text(
//               'Pendaftaran Berhasil!',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Tunjukkan tiket ini kepada petugas saat Anda tiba di Rumah Sakit.',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey, fontSize: 14),
//             ),
//             const SizedBox(height: 32),

//             // Tiket Card
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.05),
//                     blurRadius: 15,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: const BoxDecoration(
//                       color: Color(0xFF016ACC),
//                       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: const [
//                         Text(
//                           'No. Antrean',
//                           style: TextStyle(color: Colors.white70, fontSize: 14),
//                         ),
//                         Text(
//                           'A-012',
//                           style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       children: [
//                         _ticketInfoRow('Nama Pasien', 'John Doe'), // Dummy user
//                         const Divider(height: 30),
//                         _ticketInfoRow('Poliklinik', _selectedPoli ?? '-'),
//                         const Divider(height: 30),
//                         _ticketInfoRow('Dokter', _selectedDoctor ?? '-'),
//                         const Divider(height: 30),
//                         Row(
//                           children: [
//                             Expanded(child: _ticketInfoRow('Tanggal', _selectedDate ?? '-')),
//                             Expanded(child: _ticketInfoRow('Waktu', _selectedTime ?? '-')),
//                           ],
//                         ),
//                         const SizedBox(height: 30),
//                         // QR Placeholder
//                         Container(
//                           width: 150,
//                           height: 150,
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(Icons.qr_code_2, size: 120, color: Colors.black87),
//                         ),
//                         const SizedBox(height: 12),
//                         const Text('Scan QR Code ini di mesin antrean', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Kembali ke beranda
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF016ACC),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//                 ),
//                 child: const Text('Kembali ke Beranda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _ticketInfoRow(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//         const SizedBox(height: 4),
//         Text(value, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 15, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   // ─── BOTTOM NAVIGATION BAR (Action Buttons) ────────────────────────────────
//   Widget _buildBottomBar() {
//     bool isNextEnabled = false;
//     if (_currentStep == 0) isNextEnabled = _selectedPoli != null;
//     if (_currentStep == 1) isNextEnabled = _selectedDoctor != null;
//     if (_currentStep == 2) isNextEnabled = _selectedDate != null && _selectedTime != null;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: SizedBox(
//           height: 50,
//           child: ElevatedButton(
//             onPressed: isNextEnabled ? _nextStep : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF016ACC),
//               disabledBackgroundColor: Colors.grey.shade300,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(25),
//               ),
//             ),
//             child: Text(
//               _currentStep == 2 ? 'Konfirmasi Pendaftaran' : 'Lanjutkan',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: isNextEnabled ? Colors.white : Colors.grey.shade500,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
