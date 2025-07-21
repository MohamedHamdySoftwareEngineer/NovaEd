import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaed_app/core/services/api_service.dart';
import 'package:novaed_app/features/quiz_screen/presentation/manager/question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final ApiService apiService;

  QuestionCubit(this.apiService) : super(QuestionInitial());

  Future<void> getQuestions(int collectionId) async {
    emit(QuestionLoading());
    try {
      final response = await apiService.getQuestions(collectionId);
      emit(QuestionSuccess(response));
    } catch (e) {
      emit(QuestionFailure(e.toString()));
    }
  }

  Future<void> submitChoice(int choiceID, int submitionID) async {
    emit(QuestionLoading());

    try {
      final response = await apiService.submitChoice(choiceID, submitionID);
      emit(ChoiceSubmitSuccess(response));
    } catch (e) {
      emit(QuestionFailure(e.toString()));
    }
  }

  Future<void> getExplanation(int questionID) async {
    emit(QuestionLoading());
    try {
      final response = await apiService.getExplanation(questionID);
      emit(ExplanationSuccess(response));
    } catch (e) {
      emit(QuestionFailure(e.toString()));
    }
  }


}
