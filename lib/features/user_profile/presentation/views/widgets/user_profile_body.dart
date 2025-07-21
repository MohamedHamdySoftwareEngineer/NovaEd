

// 4. Updated UserProfileBody to use Cubit
import 'package:novaed_app/core/widgets/base_scaffold.dart';
import 'package:novaed_app/core/widgets/exit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaed_app/features/user_profile/presentation/manager/user_state.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../sign_in/data/models/user_model.dart';
import '../../manager/user_cubit.dart';

class UserProfileBody extends StatelessWidget {
  final int initialIndex;
  const UserProfileBody({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBartTitle: 'الملف الشخصي',
      initialIndex: initialIndex,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: backgroundColor,
        child: SafeArea(
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              if (state is UserError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.withOpacity(0.6),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'خطأ في تحميل البيانات',
                        style: TextStyle(
                          fontSize: 18,
                          color: mainTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage,
                        style: TextStyle(
                          fontSize: 14,
                          color: secondTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              
              if (state is UserLoaded) {
                return _buildProfileContent(context, state.user);
              }
              
              // If no user data, show placeholder or redirect to sign in
              return const Center(
                child: Text(
                  'لا توجد بيانات مستخدم',
                  style: TextStyle(
                    fontSize: 18,
                    color: mainTextColor,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, User userData) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.03),

              // User profile card
              _buildUserProfileCard(userData),

              const SizedBox(height: 24),

              // Account information section
              _buildInfoSection(
                title: 'معلومات الحساب',
                icon: Icons.account_circle_outlined,
                items: [
                  InfoItem(
                    icon: Icons.email_outlined,
                    title: 'البريد الإلكتروني',
                    value: userData.email ?? 'غير محدد',
                  ),
                  InfoItem(
                    icon: Icons.badge_outlined,
                    title: 'اسم المستخدم',
                    value: userData.username ?? 'غير محدد',
                  ),
                  InfoItem(
                    icon: Icons.star_outline,
                    title: 'النقاط',
                    value: userData.userPoints.toString(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Personal information section
              _buildInfoSection(
                title: 'المعلومات الشخصية',
                icon: Icons.person_outline,
                items: [
                  InfoItem(
                    icon: Icons.person_outline,
                    title: 'الاسم الكامل',
                    value: _getFullName(userData),
                  ),
                  InfoItem(
                    icon: Icons.wc_outlined,
                    title: 'الجنس',
                    value: userData.gender ? 'ذكر' : 'أنثى',
                  ),
                  if (userData.notes != null && userData.notes!.isNotEmpty)
                    InfoItem(
                      icon: Icons.note_outlined,
                      title: 'ملاحظات',
                      value: userData.notes!,
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Logout button
              const ExitButton(),

              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get full name
  String _getFullName(User userData) {
    List<String> nameParts = [];
    
    if (userData.firstName != null && userData.firstName!.isNotEmpty) {
      nameParts.add(userData.firstName!);
    }
    if (userData.secondName != null && userData.secondName!.isNotEmpty) {
      nameParts.add(userData.secondName!);
    }
    if (userData.lastName != null && userData.lastName!.isNotEmpty) {
      nameParts.add(userData.lastName!);
    }
    
    return nameParts.isEmpty ? 'غير محدد' : nameParts.join(' ');
  }

  // User profile card with avatar and basic info
  Widget _buildUserProfileCard(User userData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: backgroundBoxesColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.1),
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with points badge
          Stack(
            children: [
              // Avatar
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
                    child: Center(
                      child: Icon(
                        userData.gender ? Icons.male : Icons.female,
                        color: userData.gender ? Colors.blue : Colors.pink,
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        userData.userPoints.toString(),
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

          const SizedBox(height: 24),

          // Full name
          Text(
            _getFullName(userData),
            style: const TextStyle(
              color: mainTextColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Username or email
          Text(
            userData.username != null && userData.username!.isNotEmpty
                ? '@${userData.username}'
                : userData.email != null
                    ? '@${userData.email!.split('@').first}'
                    : '@مستخدم',
            style: const TextStyle(
              color: secondTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          // Gender badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: userData.gender
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.pink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  userData.gender ? Icons.male : Icons.female,
                  color: userData.gender ? Colors.blue : Colors.pink,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  userData.gender ? 'ذكر' : 'أنثى',
                  style: TextStyle(
                    color: userData.gender ? Colors.blue : Colors.pink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  // Information section builder
  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<InfoItem> items,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: mainColor, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: mainTextColor,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Section items
          ...items.asMap().entries.map((entry) {
            int index = entry.key;
            InfoItem item = entry.value;
            return Column(
              children: [
                if (index > 0)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    height: 1,
                    color: mainColor.withOpacity(0.1),
                  ),
                _buildInfoItemWidget(item),
              ],
            );
          }),
        ],
      ),
    );
  }

  // Info item widget
  Widget _buildInfoItemWidget(InfoItem item) {
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
            child: Icon(item.icon, color: mainColor, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: secondTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.value,
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
        ],
      ),
    );
  }
}

// InfoItem model remains the same
class InfoItem {
  final IconData icon;
  final String title;
  final String value;

  InfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });
}

