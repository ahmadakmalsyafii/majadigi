import 'package:flutter/material.dart';

Widget mainHeader() {
  return Container(
    width: double.infinity,
    height: 200,
    decoration: const BoxDecoration(color: Color(0xFF004BA0)),
    child: Stack(
      children: [
        Positioned(
          right: -50,
          bottom: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          right: -10,
          bottom: -80,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        const SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
