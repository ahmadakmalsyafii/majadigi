import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_bloc.dart';

import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_event.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_state.dart';
import 'package:majadigi/features/beranda/presentation/widgets/banner_carousel.dart';
import 'package:majadigi/features/no_darurat/presentation/pages/noDarurat_pages.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beranda Utama"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/main_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/main_background.png'),
                        fit: BoxFit.cover,
                      )
                  )
              ),
              BlocProvider(
                create: (context) => sl<BerandaBloc>()
                  ..add(const GetAllBannersEvent()),
                child: BlocBuilder<BerandaBloc, BerandaState>(
                  builder: (context, state) {
                    if (state is BerandaLoading) {
                      return SizedBox(
                        height: 200,
                        child: Container(
                          color: Colors.white,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    } else if (state is BerandaError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, color: Colors.red, size: 40),
                            const SizedBox(height: 16),
                            Text(state.message),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<BerandaBloc>()
                                    .add(const GetBerandaDataEvent());
                              },
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is BerandaLoaded) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BannerCarouselWidget(
                          banners: state.banners,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsetsGeometry.all(24.0),
                child:
                SearchBar(
                  hintText: 'Cari Layanan dan Informasi...',
                  padding: WidgetStatePropertyAll(const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                  textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white)),
                  surfaceTintColor: WidgetStatePropertyAll(Colors.white),
                  shadowColor: WidgetStatePropertyAll(Colors.transparent),
                  side: WidgetStatePropertyAll(BorderSide(color: Colors.white)),
                  leading: Icon(Icons.search_rounded, color: Colors.white),
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  onChanged: (value) {
                    // Implementasi pencarian di sini
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmergencyNumberPage()),
                ),
                child: const Text('Nomor Darurat'),
              ),
            ],
          ),
        ),
      )
    );
  }
}