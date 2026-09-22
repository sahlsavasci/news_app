import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    final cardColor = isDark ? Colors.grey[900]! : Colors.white;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 4,
      itemBuilder: (context, index) {
        if (index == 0) {
          // Headline Shimmer
          return Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    color: cardColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          width: double.infinity,
                          color: cardColor,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 24,
                          width: 250,
                          color: cardColor,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 100,
                          color: cardColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Standard Card Shimmer
        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 12,
                            width: 80,
                            color: cardColor,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 16,
                            width: double.infinity,
                            color: cardColor,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 16,
                            width: 150,
                            color: cardColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
              if (index < 3)
                const Divider(height: 1, thickness: 1),
            ],
          ),
        );
      },
    );
  }
}
