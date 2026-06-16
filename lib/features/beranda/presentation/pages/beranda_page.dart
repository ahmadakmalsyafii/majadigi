import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_bloc.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_state.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_event.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_state.dart';
import 'package:majadigi/features/beranda/presentation/widgets/banner_carousel.dart';
import 'package:majadigi/features/beranda/presentation/widgets/searchbar_beranda.dart';
import 'package:majadigi/features/beranda/presentation/widgets/service_section.dart';
import 'package:majadigi/features/beranda/presentation/widgets/jatim_angka_section.dart';
import 'package:majadigi/features/beranda/presentation/widgets/beranda_shimmer.dart';

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
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
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
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.white.withOpacity(0.3),
                          ),
                          side: WidgetStatePropertyAll(
                            BorderSide(color: Colors.white),
                          ),
                          shape: WidgetStatePropertyAll(
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
                      return Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Column(
                          children: [
                            if (state.bannerStatus == BerandaSectionStatus.loading || state.bannerStatus == BerandaSectionStatus.initial)
                              const BannerShimmer()
                            else if (state.bannerStatus == BerandaSectionStatus.loaded)
                              BannerCarouselWidget(banners: state.banners)
                            else
                              const SizedBox.shrink(),

                            const SearchBarBeranda(),

                            Container(
                              padding: const EdgeInsets.all(24.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              child: Column(
                                children: [
                                  if (state.serviceStatus == BerandaSectionStatus.loading || state.serviceStatus == BerandaSectionStatus.initial)
                                    const ServiceShimmer()
                                  else if (state.serviceStatus == BerandaSectionStatus.loaded)
                                    ServiceSection(services: state.services)
                                  else
                                    const SizedBox.shrink(),

                                  const SizedBox(height: 24),

                                  if (state.jatimAngkaStatus == BerandaSectionStatus.loading || state.jatimAngkaStatus == BerandaSectionStatus.initial)
                                    const JatimAngkaShimmer()
                                  else if (state.jatimAngkaStatus == BerandaSectionStatus.loaded)
                                    JatimAngkaSection(
                                      jatimAngkaList: state.jatimAngka,
                                    )
                                  else
                                    const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
