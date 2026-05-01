import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TersimpanPage extends StatelessWidget {
  const TersimpanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tersimpan"),
      ),
      body: const Center(child: Text("Selamat Datang!")),
    );
  }
}
