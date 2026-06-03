import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/core/widgets/custom_header.dart';
import 'package:majadigi/core/widgets/custom_search_bar.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_bloc.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_event.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/entity/destination_entity.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/presentation/bloc/destination_bloc.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/presentation/bloc/destination_event.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/presentation/bloc/destination_state.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/presentation/widgets/destination_card.dart';

class DestinasiWisataPage extends StatefulWidget {
  const DestinasiWisataPage({super.key});

  @override
  State<DestinasiWisataPage> createState() => _DestinasiWisataPageState();
}

class _DestinasiWisataPageState extends State<DestinasiWisataPage> {
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DestinationBloc>()..add(FetchDestinationsEvent()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            CustomHeader(
              title: 'Destinasi Wisata',
              subtitle: 'Temukan keindahan Jawa Timur',
              trailing: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Hapus Fitur'),
                        content: const Text('Apakah Anda yakin ingin menghapus fitur ini dari perangkat?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              sl<FeatureManagerBloc>().add(const UninstallFeatureEvent('destinasi_wisata'));
                              Navigator.pop(context); // close dialog
                              Navigator.pop(context); // close page
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Fitur berhasil dihapus')),
                              );
                            },
                            child: const Text('Ya'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('Hapus', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            
            // Search Bar
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: CustomSearchBar(
                hintText: 'Cari Destinasi',
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            Expanded(
              child: BlocBuilder<DestinationBloc, DestinationState>(
                builder: (context, state) {
                  if (state is DestinationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DestinationError) {
                    return Center(child: Text(state.message));
                  } else if (state is DestinationLoaded) {
                    final allCategories = ['Semua', ...state.availableCategories];
                    
                    // Filter logic
                    List<DestinationEntity> filteredList = state.destinations.where((dest) {
                      final matchesSearch = dest.name.toLowerCase().contains(_searchQuery.toLowerCase());
                      final matchesCategory = _selectedCategory == 'Semua' || dest.category.contains(_selectedCategory);
                      return matchesSearch && matchesCategory;
                    }).toList();

                    return Column(
                      children: [
                        // Categories
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: allCategories.length,
                            itemBuilder: (context, index) {
                              final category = allCategories[index];
                              final isSelected = category == _selectedCategory;
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: ChoiceChip(
                                  label: Text(category),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  },
                                  checkmarkColor: Colors.white,
                                  backgroundColor: Colors.white,
                                  selectedColor: const Color(0xFF0065FF),
                                  labelStyle: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: isSelected ? const Color(0xFF0065FF) : Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Grid View
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final destination = filteredList[index];
                              return DestinationCard(
                                destination: destination,
                                onTap: () {
                                  context.push('/detail-destinasi', extra: destination);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
