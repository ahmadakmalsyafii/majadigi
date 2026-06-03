import 'package:flutter/material.dart';
import 'package:majadigi/core/utils/helpers/input_decoration_helper.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.all(4),
      child: TextField(
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        decoration: InputDecorationHelper.generalDecoration(context,
          hintText: hintText,
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
        ),
      ),
    );
  }
}
