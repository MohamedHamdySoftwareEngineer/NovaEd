import 'package:novaed_app/features/quiz_screen/data/models/quiz_models.dart';

abstract class QuestionState {
  List<Object?> get props => [];
}

class QuestionInitial extends QuestionState {}

class QuestionLoading extends QuestionState {}

class ChoiceSubmitLoading extends QuestionState {}

class QuestionSuccess extends QuestionState {
  final List<QuestionWithChoices> questions;
  QuestionSuccess(this.questions);

  @override
  List<Object?> get props => [questions];
}

class ChoiceSubmitSuccess extends QuestionState {
  final ChoiceResult result;
  ChoiceSubmitSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class ExplanationSuccess extends QuestionState {
  final Explanation explanation;
  ExplanationSuccess(this.explanation);

  @override
  List<Object?> get props => [explanation];
}

class QuestionFailure extends QuestionState {
  final String errorMessage;

  QuestionFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
