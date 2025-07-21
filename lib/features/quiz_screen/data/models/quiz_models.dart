class QuestionWithChoices {
  final int questionID;
  final String questionText;
  final int rank;
  final List<Choice> choice;

  QuestionWithChoices(
      {required this.questionID,
      required this.questionText,
      required this.rank,
      required this.choice});

  factory QuestionWithChoices.fromJson(Map<String, dynamic> json) {
    return QuestionWithChoices(
      questionID: json['questionID'],
      questionText: json['questionText'],
      rank: json['rank'],
      choice: (json['choices'] as List)
          .map((choice) => Choice.fromJson(choice as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Choice {
  final int choiceID;
  final String choiceText;

  Choice({required this.choiceID, required this.choiceText});

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      choiceID: json['choiceID'] as int,
      choiceText: json['choiceText'] as String,
    );
  }
}

class ChoiceResult {
  final int chosenChoiceID;
  final int choiceID;
  final int userID;
  final DateTime chosenDate;
  final int submissionID;

  ChoiceResult(
      {required this.chosenChoiceID,
      required this.choiceID,
      required this.userID,
      required this.chosenDate,
      required this.submissionID});

  factory ChoiceResult.fromJson(Map<String, dynamic> json) {
    return ChoiceResult(
        chosenChoiceID: json['chosen_ChoiceID'] as int,
        choiceID: json['choiceID'] as int,
        userID: json['userID'] as int,
        chosenDate: DateTime.parse(json['chosenDate'] as String),
        submissionID: json['submitionID'] as int);
  }
}


class Explanation {
  final int rightAnswerChoiceID;
  final String explanationText;
  final int explanationID;

  Explanation({
    required this.rightAnswerChoiceID,
    required this.explanationText,
    required this.explanationID,
  });

  factory Explanation.fromJson(Map<String, dynamic> json) {
    return Explanation(
      rightAnswerChoiceID: json['choiceID'] ,
      explanationText: json['explanationText'] ?? 'لا يوجد شرح',
      explanationID: json['explanationID'] ?? 0,
    );
  }
}