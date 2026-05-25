import 'package:flutter/material.dart';

class InputDecorationHelper {
  /// Helper untuk form input bergaya otentikasi (Login/Register)
  static InputDecoration authDecoration(
      BuildContext context, {
        required String hintText,
        Widget? suffixIcon,
        Color? hintColor,
      }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: hintColor ?? Colors.grey,
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      suffixIcon: suffixIcon,
      // Border default
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      // Border saat tidak aktif (tapi bisa di-tap)
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      // Border saat sedang diketik (focus)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0066CC), width: 1.5),
      ),
      // Border saat ada error validasi
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  /// Helper untuk form input bergaya umum (non-auth)
  static InputDecoration generalDecoration(
      BuildContext context, {
        required String hintText,
        Widget? suffixIcon,
        Widget? prefixIcon,
        Color? hintColor,
      }) {
    return InputDecoration(

      hintText: hintText,
      hintStyle: TextStyle(
        color: hintColor ?? Colors.grey,
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(4),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      isDense: true,
      // Border default
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      // Border saat tidak aktif (tapi bisa di-tap)
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      // Border saat sedang diketik (focus)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Color(0xFF0066CC)),
      ),
      // Border saat ada error validasi
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
      ),

    );
  }
}