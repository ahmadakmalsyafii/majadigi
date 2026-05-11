import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_bloc.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_state.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_event.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_state.dart';
import 'package:majadigi/features/beranda/presentation/widgets/banner_carousel.dart';
import 'package:majadigi/features/no_darurat/presentation/pages/noDarurat_pages.dart';
import 'package:majadigi/features/beranda/presentation/widgets/searchbar_beranda.dart';
import 'package:majadigi/features/beranda/presentation/widgets/service_section.dart';
import 'package:majadigi/features/beranda/presentation/widgets/jatim_angka_section.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/main_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24,16,24,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          String name = "";
                          if (state is AuthAuthenticated) {
                            name = state.user.name;
                          }
                          return Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.white.withOpacity(0.3),
                          ),
                          side: WidgetStatePropertyAll(
                            BorderSide(color: Colors.white),
                          ),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                BlocProvider(
                  create: (context) =>
                      sl<BerandaBloc>()..add(const GetBerandaDataEvent()),
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
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 40,
                              ),
                              const SizedBox(height: 16),
                              Text(state.message),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<BerandaBloc>().add(
                                    const GetBerandaDataEvent(),
                                  );
                                },
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        );
                      } else if (state is BerandaLoaded) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Column(
                            children: [
                              BannerCarouselWidget(banners: state.banners),
                              SearchBarBeranda(),
                              Container(
                                padding: const EdgeInsets.all(24.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ServiceSection(services: state.services),
                                    const SizedBox(height: 24),
                                    JatimAngkaSection(jatimAngkaList: state.jatimAngka),
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
      ),
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
