import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/core/widgets/custom_header.dart';
import 'package:majadigi/core/widgets/custom_search_bar.dart';
import 'package:majadigi/features/layanan/presentation/bloc/layanan_bloc.dart';
import 'package:majadigi/features/layanan/presentation/bloc/layanan_event.dart';
import 'package:majadigi/features/layanan/presentation/bloc/layanan_state.dart';
import 'package:majadigi/features/list_layanan/presentation/bloc/list_layanan_bloc.dart';

class LayananPage extends StatelessWidget {
  const LayananPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LayananBloc>()..add(FetchLayananData()),
      child: const _LayananView(),
    );
  }
}

class _LayananView extends StatelessWidget {
  const _LayananView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Builder(
            builder: (context) {
              return Column(
                children: [
                  const CustomHeader(
                    title: 'Cari Layanan',
                    subtitle: 'Temukan layanan sesuai kebutuhanmu.',
                    showBackButton: false,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300)
                    ),
                    child: CustomSearchBar(
                      hintText: 'Cari layanan...',
                      onChanged: (value) {
                        context.read<LayananBloc>().add(SearchLayananEvent(value));
                      },
                    ),
                  )
                ],
              );
            }
          ),
          Expanded(
            child: BlocBuilder<LayananBloc, LayananState>(
              builder: (context, state) {
                if (state is LayananLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LayananLoaded) {
                  final services = state.filteredServices;
                  final katalog = state.filteredKatalogLayanan;
                  final totalCount = services.length + katalog.length;

                  if (totalCount == 0) {
                    return const Center(child: Text("Tidak ada layanan ditemukan"));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: totalCount,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      if (index < services.length) {
                        final item = services[index];
                        return _buildListItem(
                          context,
                          name: item.name,
                          iconUrl: item.icon,
                          onTap: () {
                            context.pushNamed('detail_layanan', extra: item);
                          },
                        );
                      } else {
                        final item = katalog[index - services.length];
                        return _buildListItem(
                          context,
                          name: item.nama,
                          iconUrl: item.icon,
                          onTap: () {
                            // TODO: Add routing for katalog if needed
                          },
                        );
                      }
                    },
                  );
                } else if (state is LayananError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, {required String name, required String iconUrl, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  iconUrl,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}