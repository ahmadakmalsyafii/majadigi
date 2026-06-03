import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/core/widgets/custom_header.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/entity/facility_entity.dart';
import 'package:majadigi/deffered_feature/islamic_center/presentation/bloc/islamic_center_bloc.dart';
import 'package:majadigi/deffered_feature/islamic_center/presentation/bloc/islamic_center_event.dart';
import 'package:majadigi/deffered_feature/islamic_center/presentation/bloc/islamic_center_state.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_bloc.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_event.dart';

class IslamicCenterPage extends StatelessWidget {
  const IslamicCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<IslamicCenterBloc>()..add(GetFacilitiesEvent()),
      child: const _IslamicCenterView(),
    );
  }
}

class _IslamicCenterView extends StatelessWidget {
  const _IslamicCenterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          CustomHeader(
            title: 'Islamic Center Jawa Timur',
            subtitle: 'Sewa tempat untuk kebutuhan acara.',
            trailing: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text('Hapus Fitur'),
                      content: const Text(
                        'Apakah Anda yakin ingin menghapus data fitur ini dari perangkat?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            sl<FeatureManagerBloc>().add(
                              const UninstallFeatureEvent('islamic_center'),
                            );
                            context.pop();
                          },
                          child: const Text('Hapus'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outline, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Hapus',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<IslamicCenterBloc, IslamicCenterState>(
              builder: (context, state) {
                if (state is IslamicCenterLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is IslamicCenterError) {
                  return Center(child: Text(state.message));
                } else if (state is IslamicCenterLoaded) {
                  final facilities = state.facilities;
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: facilities.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final facility = facilities[index];
                      return _buildFacilityCard(context, facility);
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityCard(BuildContext context, FacilityEntity facility) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          'islamic_center_facility_detail',
          extra: facility,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              facility.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    facility.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    facility.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: facility.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Color(0xFF0048B5),
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
