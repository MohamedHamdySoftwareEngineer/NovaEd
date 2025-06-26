class Choice {
  final String choiceText;
  final bool isRightAnswer;
  final int rank;

  Choice({
    required this.choiceText,
    required this.isRightAnswer,
    required this.rank,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
    choiceText:    json['choiceText']    as String,
    isRightAnswer: json['isRightAnswer'] as bool,
    rank:          json['rank']          as int,
  );
}

class QuizModel {
  final int questionID;
  final String questionText;
  final int rank;
  final List<Choice> choices;

  QuizModel({
    required this.questionID,
    required this.questionText,
    required this.rank,
    required this.choices,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
    questionID:   json['questionID']   as int,
    questionText: json['questionText'] as String,
    rank:         json['rank']         as int,
    choices: (json['choices'] as List)
        .map((e) => Choice.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
