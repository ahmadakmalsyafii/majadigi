import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LayananPage extends StatelessWidget {
  const LayananPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Layanan"),
      ),
      body: const Center(child: Text("Selamat Datang!")),
    );
  }
}
