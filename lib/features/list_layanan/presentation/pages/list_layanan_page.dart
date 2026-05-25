import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi/core/widgets/custom_header.dart';
import 'package:majadigi/core/widgets/custom_search_bar.dart';
import 'package:majadigi/features/list_layanan/presentation/bloc/list_layanan_bloc.dart';
import 'package:majadigi/features/list_layanan/presentation/bloc/list_layanan_state.dart';


import '../../../../../core/di/di.dart';
import '../bloc/list_layanan_event.dart';

class ListLayananPage extends StatelessWidget {
  const ListLayananPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ListLayananBloc>()..add(const GetListLayananEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Builder(
              builder: (context) {
                return Column(
                  children: [
                    CustomHeader(
                      title: 'Cari Layanan',
                      subtitle: 'Temukan layanan sesuai kebutuhanmu.',
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: CustomSearchBar(
                        hintText: 'Cari layanan...',
                        onChanged: (value) {
                          context.read<ListLayananBloc>().add(SearchListLayananEvent(value));
                        },
                      ),
                    )
                  ],
                );
              }
            ),
            Expanded(
              child: BlocBuilder<ListLayananBloc, ListLayananState>(builder: (context, state) {
                if (state is ListLayananLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ListLayananLoaded) {
                  final layananList = state.filteredServices;
                  if (layananList.isEmpty) {
                    return const Center(child: Text('Tidak ada layanan tersedia'));
                  }
                  return ListView.builder(
                    itemCount: layananList.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final item = layananList[index];
                      return InkWell(
                        onTap: () {
                          context.pushNamed(
                            'detail_layanan',
                            extra: item,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsetsGeometry.symmetric(horizontal: 12),
                                width: 60,
                                height: 60,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    item.icon,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.grey),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.name,
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
                  );
                } else if (state is ListLayananError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              }),
            ),
          ],
        ),
      ),
    );
  }
}