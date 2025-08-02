import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaed_app/core/widgets/base_scaffold.dart';
import '../../../../../../../core/utils/constants.dart';
import '../../../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/profile_shimmer.dart';
import '../../../../LogIn/data/models/user_model.dart';
import '../../manager/profile_cubit.dart';
import '../../manager/profile_state.dart';

class UserProfileBody extends StatelessWidget {
  final int initialIndex;
  const UserProfileBody({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final user = state.user;
          return BaseScaffold(
            appBartTitle: 'الملف الشخصي',
            initialIndex: initialIndex,
            child: Container(
              color: backgroundColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildProfileHeader(context, size, user),
                      SizedBox(height: ResponsiveHelper.getSpacing(size, 30)),
                      _buildProfileOptions(context, size, user),
                      SizedBox(height: ResponsiveHelper.getSpacing(size, 50)),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        // Return a fallback widget if not authenticated
        return const ProfileShimmer();
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, Size size, User user) {
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
          // Profile Picture
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      mainColor.withOpacity(0.8),
                      progressIndeicatorColor.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: backgroundBoxesColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: mainColor,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              // Points badge
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: mainColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        user.userPoints.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(size, 15)),
          // User Name
          Text(
            '${user.firstName} ${user.lastName}',
            style: const TextStyle(
              color: mainTextColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(size, 5)),
          // User Email
          Text(
            user.username.toString(),
            style: const TextStyle(
              color: secondTextColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context, Size size, User user) {
    return Column(
      children: [
        _buildPersonalInfoSection(context, size, user),
        SizedBox(height: ResponsiveHelper.getSpacing(size, 20)),
        _buildAppOptionsSection(context, size),
      ],
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context, Size size, User user) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline,
                    color: mainColor, size: 20),
              ),
              const SizedBox(width: 16),
              const Text(
                'المعلومات الشخصية',
                style: TextStyle(
                  color: mainTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: ResponsiveHelper.getSpacing(size, 10)),
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
            _buildInfoCard(
              context: context,
              title: 'البريد الإلكتروني',
              value: user.email,
              icon: Icons.email_rounded,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 1,
              color: mainColor.withOpacity(0.1),
            ),
            _buildInfoCard(
              context: context,
              title: 'ملاحظات',
              value: user.notes,
              icon: Icons.note_rounded,
            ),
          ],
        ),
      ),
    ],
  );
}

  Widget _buildAppOptionsSection(BuildContext context, Size size) {
    final appOptions = [
      
      // {
      //   'title': 'الإعدادات',
      //   'icon': Icons.settings_rounded,
      //   'onTap': () {
      //     // Navigate to settings screen
      //   },
      // },
      {
        'title': 'المساعدة والدعم',
        'icon': Icons.help_outline_rounded,
        'onTap': () {
          // Navigate to help screen
        },
      },
      {
        'title': 'حول التطبيق',
        'icon': Icons.info_outline_rounded,
        'onTap': () {
          // Navigate to about screen
        },
      },
      {
        'title': 'تسجيل الخروج',
        'icon': Icons.logout_rounded,
        'onTap': () {},
      },
      {
        'title': 'حذف الحساب',
        'icon': Icons.delete_forever_rounded,
        'isDestructive': true,
        'onTap': () {},
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.apps_rounded,
                      color: mainColor, size: 20),
                ),
                const SizedBox(width: 16),
                const Text(
                  'خيارات التطبيق',
                  style: TextStyle(
                    color: mainTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(size, 10)),
        ...appOptions.map((option) {
          return Container(
            margin:
                EdgeInsets.only(bottom: ResponsiveHelper.getSpacing(size, 15)),
            child: _buildProfileOptionCard(
              context: context,
              title: option['title'] as String,
              icon: option['icon'] as IconData,
              onTap: option['onTap'] as VoidCallback,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: mainColor, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: secondTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      color: mainTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Icon section
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: mainColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            // Text section
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: mainTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
