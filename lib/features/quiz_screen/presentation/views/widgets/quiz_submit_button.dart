import 'package:flutter/material.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../../core/utils/responsive_helper.dart';

class QuizSubmitButton extends StatefulWidget {
  final bool hasSelectedAnswer;
  final bool isAnswered;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final Size size;

  const QuizSubmitButton({
    super.key,
    required this.hasSelectedAnswer,
    required this.isAnswered,
    required this.isSubmitting,
    required this.onSubmit,
    required this.size,
  });

  @override
  State<QuizSubmitButton> createState() => _QuizSubmitButtonState();
}

class _QuizSubmitButtonState extends State<QuizSubmitButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
    
    // Start pulsing when button becomes enabled
    if (widget.hasSelectedAnswer && !widget.isAnswered) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(QuizSubmitButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Control pulsing animation based on button state
    if (widget.hasSelectedAnswer && !widget.isAnswered && !widget.isSubmitting) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = widget.hasSelectedAnswer && !widget.isAnswered && !widget.isSubmitting;
    final isTablet = ResponsiveHelper.isTablet(widget.size);
    final isLargeScreen = ResponsiveHelper.isLargeScreen(widget.size);
    final padding = ResponsiveHelper.getPadding(widget.size);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.8),
            Colors.white,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(padding, padding * 0.8, padding, padding * 1.2),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isLargeScreen ? 600 : (isTablet ? 400 : double.infinity),
            ),
            child: AnimatedBuilder(
              animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value * (isButtonEnabled ? _pulseAnimation.value : 1.0),
                  child: Container(
                    width: double.infinity,
                    height: isTablet ? 68 : 60,
                    decoration: BoxDecoration(
                      gradient: isButtonEnabled
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                mainColor,
                                mainColor.withOpacity(0.8),
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                Colors.grey.withOpacity(0.6),
                                Colors.grey.withOpacity(0.4),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getBorderRadius(widget.size, 18),
                      ),
                      boxShadow: isButtonEnabled
                          ? [
                              BoxShadow(
                                color: mainColor.withOpacity(0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: mainColor.withOpacity(0.1),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                                spreadRadius: -4,
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isButtonEnabled ? widget.onSubmit : null,
                        onTapDown: isButtonEnabled ? _onTapDown : null,
                        onTapUp: isButtonEnabled ? _onTapUp : null,
                        onTapCancel: isButtonEnabled ? _onTapCancel : null,
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.getBorderRadius(widget.size, 18),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: widget.isSubmitting
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: isTablet ? 24 : 20,
                                      height: isTablet ? 24 : 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: widget.size.width * 0.03),
                                    Text(
                                      'جاري التحميل...',
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.getFontSize(widget.size, 16),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isButtonEnabled && !widget.isAnswered) ...[
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.white,
                                        size: ResponsiveHelper.getFontSize(widget.size, 20),
                                      ),
                                      SizedBox(width: widget.size.width * 0.02),
                                    ],
                                    if (widget.isAnswered) ...[
                                      Icon(
                                        Icons.done_all,
                                        color: Colors.white,
                                        size: ResponsiveHelper.getFontSize(widget.size, 20),
                                      ),
                                      SizedBox(width: widget.size.width * 0.02),
                                    ],
                                    Text(
                                      widget.isAnswered ? 'تم الإجابة' : 'تأكيد الإجابة',
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.getFontSize(widget.size, 18),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}