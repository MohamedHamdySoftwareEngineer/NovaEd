import 'package:flutter/material.dart';
import 'package:novaed_app/features/quiz_screen/data/models/quiz_models.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/utils/styles.dart';
import '../../../../../core/utils/responsive_helper.dart';

class QuizQuestionCard extends StatefulWidget {
  final QuestionWithChoices question;
  final Size size;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.size,
  });

  @override
  State<QuizQuestionCard> createState() => _QuizQuestionCardState();
}

class _QuizQuestionCardState extends State<QuizQuestionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveHelper.getPadding(widget.size);
    final isTablet = ResponsiveHelper.isTablet(widget.size);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: cardPadding * 0.2),
              padding: EdgeInsets.all(cardPadding * 1.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(widget.size, 16),
                ),
                border: Border.all(
                  color: mainColor.withOpacity(0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  widget.question.questionText,
                  style: Styles.mainBlackText18.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(widget.size, isTablet ? 20 : 18),
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}