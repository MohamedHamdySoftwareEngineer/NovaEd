import 'package:flutter/material.dart';
import '../../../../../../../core/utils/constants.dart';
import '../../../../../../../core/utils/responsive_helper.dart';

class ProfileShimmer extends StatefulWidget {
  const ProfileShimmer({super.key});

  @override
  State<ProfileShimmer> createState() => _ProfileShimmerState();
}

class _ProfileShimmerState extends State<ProfileShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildProfileHeaderShimmer(context, size),
              SizedBox(height: ResponsiveHelper.getSpacing(size, 30)),
              _buildProfileOptionsShimmer(context, size),
              SizedBox(height: ResponsiveHelper.getSpacing(size, 50)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeaderShimmer(BuildContext context, Size size) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: backgroundBoxesColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: mainColor.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Profile Picture Shimmer
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300]?.withOpacity(0.3 + (_animation.value * 0.4)),
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Points badge shimmer
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: 60,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[300]?.withOpacity(0.3 + (_animation.value * 0.4)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(size, 15)),
              // User Name Shimmer
              Container(
                width: 150,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[300]?.withOpacity(0.3 + (_animation.value * 0.4)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(size, 8)),
              // User Email Shimmer
              Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey[300]?.withOpacity(0.3 + (_animation.value * 0.4)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileOptionsShimmer(BuildContext context, Size size) {
    return Column(
      children: [
        _buildPersonalInfoSectionShimmer(context, size),
        SizedBox(height: ResponsiveHelper.getSpacing(size, 20)),
        _buildAppOptionsSectionShimmer(context, size),
      ],
    );
  }

  Widget _buildPersonalInfoSectionShimmer(BuildContext context, Size size) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header Shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300]?.withOpacity(0.3 + (_animation.value * 0.4)),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 120,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300]?.withOpacity(0.3 + (_animation.value * 0.4)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(size, 10)),
            // Info Cards Container Shimmer
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundBoxesColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: mainColor.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoCardShimmer(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    height: 1,
                    color: mainColor.withOpacity(0.1),
                  ),
                  _buildInfoCardShimmer(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoCardShimmer() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey[300]?.withOpacity(0.3 + (_animation.value * 0.4)),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 80,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey[300]?.withOpacity(0.3 + (_animation.value * 0.4)),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 140,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[300]?.withOpacity(0.3 + (_animation.value * 0.4)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppOptionsSectionShimmer(BuildContext context, Size size) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header Shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300]?.withOpacity(0.3 + (_animation.value * 0.4)),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 100,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300]?.withOpacity(0.3 + (_animation.value * 0.4)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(size, 10)),
            // Option Cards Shimmer
            ...List.generate(4, (index) {
              return Container(
                margin: EdgeInsets.only(bottom: ResponsiveHelper.getSpacing(size, 15)),
                child: _buildProfileOptionCardShimmer(),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildProfileOptionCardShimmer() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundBoxesColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: mainColor.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Shimmer
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.grey[300]?.withOpacity(0.3 + (_animation.value * 0.4)),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(width: 20),
              // Text Shimmer
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 120,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.grey[300]?.withOpacity(0.3 + (_animation.value * 0.4)),
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}