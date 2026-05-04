import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/features/beranda/presentation/pages/beranda_page.dart';
import 'package:majadigi/features/layanan/presentation/pages/layanan_page.dart';
import 'package:majadigi/features/navigation/presentation/bloc/navigation_bloc.dart';
import 'package:majadigi/features/profile/presentation/pages/profile_page.dart';
import 'package:majadigi/features/tersimpan/presentation/pages/tersimpan_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const BerandaPage(),
      const LayananPage(),
      const TersimpanPage(),
      const ProfilePage(),
    ];

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(

          body: IndexedStack(
            index: state.currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: state.currentIndex,
              selectedItemColor: const Color(0xFF1550A6),
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              onTap: (index) {
                context
                    .read<NavigationBloc>()
                    .add(NavigationTabChanged( index));
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 2.0),
                    child: Icon(Icons.home_rounded),
                  ),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 2.0),
                    child: Icon(Icons.grid_view_rounded),
                  ),
                  label: 'Layanan',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 2.0),
                    child: Icon(Icons.bookmark),
                  ),
                  label: 'Tersimpan',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 2.0),
                    child: Icon(Icons.person),
                  ),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}