import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:typewritertext/typewritertext.dart';
import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/utils/constants.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void navigateToChoice() {
      AppRouter.toChoiceScreen(context);
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.08),
                // Logo and Welcome Section
                _buildWelcomeSection(),
                SizedBox(height: size.height * 0.06),
                // Quiz Card
                _buildQuizCard(size, navigateToChoice),
                SizedBox(height: size.height * 0.04),
                // Additional Features Section
                _buildFeaturesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        // Logo with gradient background
        Center(
          child: Image.asset(
            AssetsData.homeLogo,
            width: 140,
            height: 140,
          ),
        ),
        const SizedBox(height: 24),
        // Welcome Text with RTL and TypeWriter
        Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              SizedBox(
                height: 45,
                child: TypeWriter.text(
                  'اختبر معلوماتك!',
                  style: const TextStyle(
                    color: mainTextColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  duration: const Duration(milliseconds: 70),
                  maintainSize: true,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  softWrap: false,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'تحدى نفسك واختبر معلوماتك مع مجموعة متنوعة من الأسئلة',
                style: TextStyle(
                  color: secondTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuizCard(Size size, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: backgroundBoxesColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Quiz Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  mainColor.withOpacity(0.2),
                  progressIndeicatorColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.quiz_rounded,
              color: mainColor,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          
          // Quiz Title
          const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'ابدأ رحلة التعلم',
              style: TextStyle(
                color: mainTextColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          
          // Quiz Description
          const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'اختر من بين مجموعة متنوعة من المواضيع واختبر مدى معرفتك',
              style: TextStyle(
                color: secondTextColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          
          // Start Quiz Button
          _buildStartButton(onPressed),
        ],
      ),
    );
  }

  Widget _buildStartButton(VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          foregroundColor: backgroundBoxesColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ).copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ابدأ الاختبار',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFeatureItem(
            icon: Icons.psychology_rounded,
            title: 'تحدي العقل',
            subtitle: 'أسئلة متنوعة',
          ),
          _buildFeatureItem(
            icon: Icons.emoji_events_rounded,
            title: 'التقييم',
            subtitle: 'نتائج فورية',
          ),
          _buildFeatureItem(
            icon: Icons.trending_up_rounded,
            title: 'التطوير',
            subtitle: 'تحسين المعرفة',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundBoxesColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: mainColor.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: mainColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: mainTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: secondTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}