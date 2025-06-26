import 'package:novaed_app/core/widgets/header_section.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_scaffold.dart';

class Question {
  final int questionID;
  final String questionText;
  final List<Choice> choices;
  Question(
      {required this.questionID,
      required this.questionText,
      required this.choices});
}

class Choice {
  final int choiceID;
  final String choiceText;
  final bool isRightAnswer;
  Choice(
      {required this.choiceID,
      required this.choiceText,
      required this.isRightAnswer});
}

class QuizScreenBody extends StatefulWidget {
  const QuizScreenBody({
    super.key,
  });

  @override
  QuizScreenBodyState createState() => QuizScreenBodyState();
}

class QuizScreenBodyState extends State<QuizScreenBody> {
  int selectedChoiceId = -1;
  bool isLoading = false;
  int currentQuestionIndex = 0;

  final List<Question> _questions = [
    Question(
      questionID: 1,
      questionText: 'ما هي عاصمة مصر؟',
      choices: [
        Choice(choiceID: 1, choiceText: 'القاهرة', isRightAnswer: true),
        Choice(choiceID: 2, choiceText: 'الإسكندرية', isRightAnswer: false),
        Choice(choiceID: 3, choiceText: 'الأقصر', isRightAnswer: false),
        Choice(choiceID: 4, choiceText: 'أسوان', isRightAnswer: false),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty)
      return const Center(child: Text('لا توجد أسئلة للعرض'));

    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // const SizedBox(height: 30),
              // _buildProgressSection(),
              const SizedBox(height: 40),
              const HeaderSection(
                  text: 'اختبار تفاعلي', imagePath: AssetsData.quizIconLogo),
              const SizedBox(height: 30),
              _buildQuestionCard(_questions[currentQuestionIndex]),
              const SizedBox(height: 20),
              _buildAnswerOptions(_questions[currentQuestionIndex]),
              const SizedBox(height: 20),
              _buildFinishButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Method for Progress Section
  Widget _buildProgressSection() {
    double progress = (currentQuestionIndex + 1) / _questions.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundBoxesColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: secondTextColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'السؤال ${currentQuestionIndex + 1} من ${_questions.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: mainTextColor,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: mainColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: mainColor.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(mainColor),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          sheetForFinishTest();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: wrongAnswerColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('إنهاء الاختبار',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(width: 8),
            Icon(Icons.exit_to_app, size: 20),
          ],
        ),
      ),
    );
  }

  Future<dynamic> sheetForFinishTest() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'هل أنت متأكد أنك تريد إنهاء الاختبار؟',
                style: Styles.mainBlackText18,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        AppRouter.toChoiceScreen(context); // Close sheet
                        // Add your finish logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('نعم', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close sheet
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: mainColor,
                        side: const BorderSide(color: mainColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('لا', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuestionCard(Question q) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: backgroundBoxesColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: secondTextColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('السؤال ${q.questionID}',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: mainColor)),
            ),
            const SizedBox(height: 20),
            Text(q.questionText,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: mainTextColor,
                    height: 1.5),
                textAlign: TextAlign.right),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(Question q) {
    return Column(
      children: q.choices.map<Widget>((choice) {
        final isSelected = selectedChoiceId == choice.choiceID;
        final optionLetter =
            String.fromCharCode(65 + q.choices.indexOf(choice));

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: GestureDetector(
              onTap: () => _handleAnswerSelection(choice),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: backgroundBoxesColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color:
                          isSelected ? mainColor : mainColor.withOpacity(0.2),
                      width: isSelected ? 2 : 1),
                  boxShadow: [
                    BoxShadow(
                        color: secondTextColor.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            isSelected ? mainColor : mainColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: isSelected && isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white)),
                            )
                          : Center(
                              child: isSelected
                                  ? const Icon(Icons.check,
                                      color: Colors.white, size: 24)
                                  : Text(optionLetter,
                                      style: const TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                            ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                        child: Text(choice.choiceText,
                            style: Styles.mainBlackText18,
                            textAlign: TextAlign.right)),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _handleAnswerSelection(Choice choice) {
    setState(() {
      selectedChoiceId = choice.choiceID;
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(choice.isRightAnswer ? Icons.check_circle : Icons.cancel,
                    color: Colors.white),
                const SizedBox(width: 12),
                Text(choice.isRightAnswer ? 'إجابة صحيحة!' : 'إجابة خاطئة!',
                    style: const TextStyle(
                        fontSize: 19, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          backgroundColor:
              choice.isRightAnswer ? correctAnswerColor : wrongAnswerColor,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        ),
      );
    });
  }
}
