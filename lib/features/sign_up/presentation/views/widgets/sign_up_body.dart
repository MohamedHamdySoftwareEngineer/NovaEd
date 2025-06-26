import 'package:flutter/material.dart';
import 'package:novaed_app/core/services/api_service.dart';
import 'package:typewritertext/typewritertext.dart';
import '../../../../../core/utils/app_router.dart';
import 'package:novaed_app/core/utils/assets.dart';
import '../../../../../core/utils/constants.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                // Sign Up Form Card
                _buildSignUpCard(size),
                SizedBox(height: size.height * 0.02),
                // Sign In Link
                _buildSignInSection(),
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
            AssetsData.logoIcon,
            width: 120,
            height: 120,
          ),
        ),
        const SizedBox(height: 28),
        // Welcome Text with RTL
        Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              SizedBox(
                height: 45,
                child: TypeWriter.text(
                  'حساب جديد!',
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
                'انضم إلينا في رحلة التعلم',
                style: TextStyle(
                  color: secondTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpCard(Size size) {
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Header section
            _buildSignUpHeader(),
            const SizedBox(height: 32),
            
            // Google Sign-up button
            _buildGoogleSignUpButton(),
            
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpHeader() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          // Icon with gradient background
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  mainColor.withOpacity(0.1),
                  mainColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.person_add_rounded,
              size: 32,
              color: mainColor,
            ),
          ),
          const SizedBox(height: 20),
          
          // Title
          const Text(
            'إنشاء حساب جديد',
            style: TextStyle(
              color: mainTextColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          // Subtitle
          const Text(
            'استخدم حساب Google الخاص بك للبدء',
            style: TextStyle(
              color: secondTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleSignUpButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          try {
            final result = await ApiService().signInWithGoogle();
            // result['user'], result['tokens']…
            AppRouter.toHomeView(context);
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
          // AppRouter.toHomeView(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
        ).copyWith(
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(
            Colors.grey.withOpacity(0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google Logo with better styling
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://developers.google.com/identity/images/g-logo.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Google إنشاء حساب بـ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  

  Widget _buildSignInSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              AppRouter.toSignIn(context);
            },
            child: const Text(
              'تسجيل الدخول',
              style: TextStyle(
                color: mainColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const Text(
            'لديك حساب بالفعل؟ ',
            style: TextStyle(
              color: secondTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}