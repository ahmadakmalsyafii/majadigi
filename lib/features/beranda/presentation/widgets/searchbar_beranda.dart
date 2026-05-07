import 'package:flutter/material.dart';

class SearchBarBeranda extends StatelessWidget {
  const SearchBarBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.all(24.0),
      child: SearchBar(
        hintText: 'Cari Layanan dan Informasi...',
        padding: WidgetStatePropertyAll(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
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
    );
  }
}
