import 'package:flutter/material.dart';

Widget mainHeader({required String title, String? subtitle}) {
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/header_background.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 60,
          left: 24,
          right: 24,
          bottom: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle ?? ' ',
              style: TextStyle(
                color: subtitle != null ? Colors.white : Colors.transparent,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
