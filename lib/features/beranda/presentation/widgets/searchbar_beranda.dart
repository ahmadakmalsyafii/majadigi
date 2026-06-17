import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchBarBeranda extends StatelessWidget {
  const SearchBarBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GestureDetector(
        onTap: () {
          context.go('/layanan');
        },
        child: AbsorbPointer(
          child: SearchBar(
            hintText: 'Cari Layanan dan Informasi...',
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
            textStyle: const WidgetStatePropertyAll(TextStyle(color: Colors.white)),
            surfaceTintColor: const WidgetStatePropertyAll(Colors.white),
            shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            side: const WidgetStatePropertyAll(BorderSide(color: Colors.white)),
            leading: const Icon(Icons.search_rounded, color: Colors.white),
            backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          ),
        ),
      ),
    );
  }
}
