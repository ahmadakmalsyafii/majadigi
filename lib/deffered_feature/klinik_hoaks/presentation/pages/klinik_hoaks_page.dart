import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/core/widgets/custom_header.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/entity/klinik_hoaks_clarification_entity.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/bloc/klinik_hoaks_bloc.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/bloc/klinik_hoaks_event.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/bloc/klinik_hoaks_state.dart';

class KlinikHoaksPage extends StatelessWidget {
  const KlinikHoaksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KlinikHoaksBloc>(
      create: (_) => sl<KlinikHoaksBloc>()..add(FetchKlinikHoaksDataEvent()),
      child: const _KlinikHoaksView(),
    );
  }
}

class _KlinikHoaksView extends StatefulWidget {
  const _KlinikHoaksView();

  @override
  State<_KlinikHoaksView> createState() => _KlinikHoaksViewState();
}

class _KlinikHoaksViewState extends State<_KlinikHoaksView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua',
    'Hoaks',
    'Disinformasi',
    'Fakta',
    'Hate Speech'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<KlinikHoaksBloc>().add(
          SearchKlinikHoaksEvent(
            query: _searchController.text,
            category: _selectedCategory,
          ),
        );
  }

  String _stripHtmlTags(String htmlString) {
    final regExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlString.replaceAll(regExp, '').replaceAll('&nbsp;', ' ').trim();
  }

  String _cleanTitle(String title) {
    final regExp = RegExp(r'^\[[^\]]+\]\s*', caseSensitive: false);
    return title.replaceAll(regExp, '').trim();
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'hoaks':
        return Colors.red.shade600;
      case 'disinformasi':
        return Colors.orange.shade600;
      case 'fakta':
        return Colors.blue.shade600;
      case 'hate speech':
        return Colors.purple.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocBuilder<KlinikHoaksBloc, KlinikHoaksState>(
        builder: (context, state) {
          if (state is KlinikHoaksLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is KlinikHoaksError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<KlinikHoaksBloc>().add(FetchKlinikHoaksDataEvent());
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is KlinikHoaksLoaded) {
            return Column(
              children: [
                // Header dengan gradasi & Statistik
                CustomHeader(
                  title: 'Klinik Hoaks',
                  subtitle: 'Verifikasi & klarifikasi informasi resmi',
                  subtitleWidget: LayoutBuilder(builder: (context, constraints) {
                    final cardWidth = (constraints.maxWidth - 24) / 4;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard(
                          '${state.stats.jmlHoaksYtd}',
                          'Berita Hoaks',
                          cardWidth,
                        ),
                        _buildStatCard(
                          '${state.stats.jmlDisinformasiYtd}',
                          'Disinformasi',
                          cardWidth,
                        ),
                        _buildStatCard(
                          '${state.stats.jmlFaktaYtd}',
                          'Fakta',
                          cardWidth,
                        ),
                        _buildStatCard(
                          '${state.stats.jmlHateSpeechYtd}',
                          'Hate Speech',
                          cardWidth,
                        ),
                      ],
                    );
                  }),
                ),

                // Area Pencarian & Kategori
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => _onSearchChanged(),
                            decoration: const InputDecoration(
                              hintText: 'Cari Informasi',
                              border: InputBorder.none,
                              filled: false,
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list_rounded, color: Colors.grey),
                          onPressed: () {
                            // Bisa memicu reset filter atau show sheet
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Horizontal Category Chips
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 4, bottom: 4),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                              _onSearchChanged();
                            }
                          },
                          selectedColor: Colors.blue.shade600,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? Colors.transparent : Colors.grey.shade200,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // List Data Klarifikasi Terkini
                Expanded(
                  child: state.filteredClarifications.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.search_off, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Data tidak ditemukan',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: state.filteredClarifications.length,
                          itemBuilder: (context, index) {
                            final item = state.filteredClarifications[index];
                            return _buildClarificationCard(context, item);
                          },
                        ),
                ),

                // Bottom Sticky Button "Laporkan Hoaks"
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/klinik-hoaks/lapor', extra: context.read<KlinikHoaksBloc>());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Laporkan Hoaks',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatCard(String count, String label, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClarificationCard(BuildContext context, KlinikHoaksClarificationEntity item) {
    final cleanTitleText = _cleanTitle(item.judul);
    final cleanBodyText = _stripHtmlTags(item.isi);
    final categoryColor = _getCategoryColor(item.kategori);

    return InkWell(
      onTap: () {
        context.push('/klinik-hoaks/detail', extra: item);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row Kategori Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.kategori,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              cleanTitleText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Short Description Snippet
            Text(
              cleanBodyText,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // Footer (Date & Source)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.tanggal,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                Text(
                  item.sumber.isNotEmpty ? 'Sumber: ${item.sumber}' : '',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
