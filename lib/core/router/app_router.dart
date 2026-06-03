import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_state.dart';
import 'package:majadigi/features/auth/presentation/pages/login_page.dart';
import 'package:majadigi/features/auth/presentation/pages/register_page.dart';
import 'package:majadigi/features/beranda/presentation/pages/beranda_page.dart';
import 'package:majadigi/features/layanan/presentation/pages/layanan_page.dart';
import 'package:majadigi/features/list_layanan/presentation/pages/list_layanan_page.dart';
import 'package:majadigi/features/navigation/presentation/pages/main_page.dart';
import 'package:majadigi/features/profile/presentation/pages/profile_page.dart';
import 'package:majadigi/features/splash_screen/presentation/pages/splash_page.dart';
import 'package:majadigi/features/tersimpan/presentation/pages/tersimpan_page.dart';
import 'package:majadigi/core/router/go_router_refresh_stream.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';
import 'package:majadigi/features/detail_layanan/presentation/pages/detail_layanan_page.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/presentation/pages/ketersediaan_kamar_page.dart' deferred as ketersediaan_kamar;
import 'package:majadigi/deffered_feature/antrean_pasien/presentation/pages/antrean_pasien_page.dart' deferred as antrean_pasien;
import 'package:majadigi/deffered_feature/jadwal_operasi/presentation/pages/jadwal_operasi_page.dart' deferred as jadwal_operasi;
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/pages/harga_bahan_pokok_page.dart' deferred as harga_bahan_pokok;
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/pages/detail_harga_bahan_pokok_page.dart' deferred as detail_harga_bahan_pokok;
import 'package:majadigi/deffered_feature/pendaftaran_pasien/presentation/pages/pendaftaran_pasien_page.dart' deferred as pendaftaran_pasien;
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/entity/klinik_hoaks_clarification_entity.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/bloc/klinik_hoaks_bloc.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/pages/klinik_hoaks_page.dart' deferred as klinik_hoaks;
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/pages/klinik_hoaks_detail_page.dart' deferred as klinik_hoaks_detail;
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/pages/laporkan_hoaks_page.dart' deferred as laporkan_hoaks;

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
          return FutureBuilder(
            future: ketersediaan_kamar.loadLibrary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ketersediaan_kamar.KetersediaanKamarPage(service: service);
              }
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            },
          );
        },
      ),
      GoRoute(
        path: '/antrean-pasien',
        name: 'antrean_pasien',
        builder: (BuildContext context, GoRouterState state) {
          return FutureBuilder(
            future: antrean_pasien.loadLibrary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return antrean_pasien.AntreanPasienPage();
              }
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            },
          );
        },
      ),
      GoRoute(
        path: '/jadwal-operasi',
        name: 'jadwal_operasi',
        builder: (BuildContext context, GoRouterState state) {
          return FutureBuilder(
            future: jadwal_operasi.loadLibrary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return jadwal_operasi.JadwalOperasiPage();
              }
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            },
          );
        },
      ),
      GoRoute(
        path: '/harga-bahan-pokok',
        name: 'harga_bahan_pokok',
        builder: (BuildContext context, GoRouterState state) {
          return FutureBuilder(
            future: harga_bahan_pokok.loadLibrary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return harga_bahan_pokok.HargaBahanPokokPage();
              }
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            },
          );
        },
      ),
      GoRoute(
        path: '/detail-harga-bahan-pokok',
        name: 'detail_harga_bahan_pokok',
        builder: (BuildContext context, GoRouterState state) {
          final bpId = state.extra as int;
          return FutureBuilder(
            future: detail_harga_bahan_pokok.loadLibrary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return detail_harga_bahan_pokok.DetailHargaBahanPokokPage(bpId: bpId);
              }
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            },
          );
        },
      ),
      GoRoute(path: "/semua-layanan", name: "semua_layanan", builder: (BuildContext context, GoRouterState state) => const ListLayananPage()),
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
          return FutureBuilder(
            future: pendaftaran_pasien.loadLibrary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return pendaftaran_pasien.PendaftaranPasienPage(service: service);
              }
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            },
          );
        },
      ),
      GoRoute(
        path: '/klinik-hoaks',
        name: 'klinik_hoaks',
        builder: (BuildContext context, GoRouterState state) {
          return FutureBuilder(
            future: klinik_hoaks.loadLibrary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return klinik_hoaks.KlinikHoaksPage();
              }
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            },
          );
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
          return FutureBuilder(
            future: klinik_hoaks_detail.loadLibrary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return klinik_hoaks_detail.KlinikHoaksDetailPage(item: item);
              }
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            },
          );
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
          return FutureBuilder(
            future: laporkan_hoaks.loadLibrary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return laporkan_hoaks.LaporkanHoaksPage(bloc: bloc);
              }
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            },
          );
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
