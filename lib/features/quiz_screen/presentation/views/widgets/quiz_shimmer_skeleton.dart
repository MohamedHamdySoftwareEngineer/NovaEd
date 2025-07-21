import 'package:flutter/material.dart';
import 'package:novaed_app/core/utils/responsive_helper.dart';
import 'package:shimmer/shimmer.dart';

class QuizShimmerSkeleton extends StatelessWidget {
  final double padding;
  final Size size;
  final bool isTablet;

  const QuizShimmerSkeleton({
    super.key,
    required this.padding,
    required this.size,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    // Shimmer.fromColors creates a shimmering effect by animating
    // between two colors.
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          // Header placeholder
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: ResponsiveHelper.getSpacing(size, 16),
              ),
              child: Row(
                children: [
                  Container(
                    width: isTablet ? 48 : 40,
                    height: isTablet ? 48 : 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.getSpacing(size, 12)),
                  Expanded(
                    child: Container(
                      height: isTablet ? 16 : 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(isTablet ? 8 : 7),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.getSpacing(size, 12)),
                  Container(
                    width: isTablet ? 28 : 24,
                    height: isTablet ? 28 : 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main content area
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  SizedBox(height: ResponsiveHelper.getSpacing(size, 20)),
                  // question card placeholder
                  Container(
                    width: double.infinity,
                    height: isTablet ? 180 : 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getBorderRadius(size, 24),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(size, 20)),
                  // simulate 4 answer options
                  // spread operator (...) is used to insert multiple widgets into a list
                  // Add all the widgets from this loop directly into the children list of the column.
                  for (int i = 0; i < 4; i++) ...[
                    Container(
                      width: double.infinity,
                      height: isTablet ? 70 : 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.getBorderRadius(size, 20),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(size, 16)),
                  ],
                ],
              ),
            ),
          ),

          // Submit button placeholder
          Padding(
            padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
            // To prevent the submit button from being hidden by system UI at the bottom.
            child: SafeArea(
              child: Container(
                height: isTablet ? 64 : 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(size, 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
