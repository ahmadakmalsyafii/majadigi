import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileAboutShimmer extends StatelessWidget {
  const ProfileAboutShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          ...List.generate(
            3,
            (index) => Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                if (index < 2) const Divider(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

