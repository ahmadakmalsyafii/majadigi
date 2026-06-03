import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_state.dart';
import 'package:majadigi/features/auth/presentation/pages/login_page.dart';
import 'package:majadigi/features/auth/presentation/pages/register_page.dart';
import 'package:majadigi/features/beranda/presentation/pages/beranda_page.dart';
import 'package:majadigi/features/layanan/presentation/pages/layanan_page.dart';
import 'package:majadigi/features/navigation/presentation/pages/main_page.dart';
import 'package:majadigi/features/profile/presentation/pages/profile_page.dart';
import 'package:majadigi/features/splash_screen/presentation/pages/splash_page.dart';
import 'package:majadigi/features/tersimpan/presentation/pages/tersimpan_page.dart';
import 'package:majadigi/core/router/go_router_refresh_stream.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';
import 'package:majadigi/features/detail_layanan/presentation/pages/detail_layanan_page.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/presentation/pages/ketersediaan_kamar_page.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/presentation/pages/antrean_pasien_page.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/presentation/pages/jadwal_operasi_page.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/presentation/pages/pendaftaran_pasien_page.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/entity/klinik_hoaks_clarification_entity.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/bloc/klinik_hoaks_bloc.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/pages/klinik_hoaks_page.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/pages/klinik_hoaks_detail_page.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/pages/laporkan_hoaks_page.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;

      final bool isAuth = authState is AuthAuthenticated;
      final bool isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      // final bool isSplash = state.matchedLocation == '/splash';

      // if (authState is AuthInitial || authState is AuthLoading) {
      //   return '/splash';
      // }

      if (!isAuth && !isLoggingIn) {
        return '/login';
      }

      if (isAuth && (isLoggingIn)) {
        return '/';
      }

      return null;
    },

    //PEMANGGILAN SEMUA PAGE SEMUA DI SINI FEB
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) =>
            const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterPage(),
      ),
      GoRoute(
        path: '/detail-layanan',
        name: 'detail_layanan',
        redirect: (BuildContext context, GoRouterState state) {
          if (state.extra == null) {
            return '/';
          }
          return null;
        },
        builder: (BuildContext context, GoRouterState state) {
          final service = state.extra as ServiceEntity;
          return DetailLayananPage(service: service);
        },
      ),
      GoRoute(
        path: '/ketersediaan-kamar',
        name: 'ketersediaan_kamar',
        redirect: (BuildContext context, GoRouterState state) {
          if (state.extra == null) {
            return '/';
          }
          return null;
        },
        builder: (BuildContext context, GoRouterState state) {
          final service = state.extra as ServiceEntity;
          return KetersediaanKamarPage(service: service);
        },
      ),
      GoRoute(
        path: '/antrean-pasien',
        name: 'antrean_pasien',
        builder: (BuildContext context, GoRouterState state) {
          return const AntreanPasienPage();
        },
      ),
      GoRoute(
        path: '/jadwal-operasi',
        name: 'jadwal_operasi',
        builder: (BuildContext context, GoRouterState state) {
          return const JadwalOperasiPage();
        },
      ),
      GoRoute(
        path: '/pendaftaran-pasien',
        name: 'pendaftaran_pasien',
        redirect: (BuildContext context, GoRouterState state) {
          if (state.extra == null) {
            return '/';
          }
          return null;
        },
        builder: (BuildContext context, GoRouterState state) {
          final service = state.extra as ServiceEntity;
          return PendaftaranPasienPage(service: service);
        },
      ),
      GoRoute(
        path: '/klinik-hoaks',
        name: 'klinik_hoaks',
        builder: (BuildContext context, GoRouterState state) {
          return const KlinikHoaksPage();
        },
      ),
      GoRoute(
        path: '/klinik-hoaks/detail',
        name: 'klinik_hoaks_detail',
        redirect: (BuildContext context, GoRouterState state) {
          if (state.extra == null) {
            return '/';
          }
          return null;
        },
        builder: (BuildContext context, GoRouterState state) {
          final item = state.extra as KlinikHoaksClarificationEntity;
          return KlinikHoaksDetailPage(item: item);
        },
      ),
      GoRoute(
        path: '/klinik-hoaks/lapor',
        name: 'klinik_hoaks_lapor',
        redirect: (BuildContext context, GoRouterState state) {
          if (state.extra == null) {
            return '/';
          }
          return null;
        },
        builder: (BuildContext context, GoRouterState state) {
          final bloc = state.extra as KlinikHoaksBloc;
          return LaporkanHoaksPage(bloc: bloc);
        },
      ),


      //BUAT NAV BUTTOMNYA
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              return MainPage(navigationShell: navigationShell);
            },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/',
                name: 'beranda',
                builder: (BuildContext context, GoRouterState state) =>
                    const BerandaPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/layanan',
                name: 'layanan',
                builder: (BuildContext context, GoRouterState state) =>
                    const LayananPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/tersimpan',
                name: 'tersimpan',
                builder: (BuildContext context, GoRouterState state) =>
                    const TersimpanPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/profil',
                name: 'profil',
                builder: (BuildContext context, GoRouterState state) =>
                    const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
