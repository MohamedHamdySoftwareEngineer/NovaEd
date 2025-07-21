import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaed_app/core/services/api_service.dart';
import 'package:novaed_app/features/choice_screen/presentation/manager/submission_state.dart';

// this class extends Cubit to manage the state of submission creation
// it uses the SubmissionState to represent different states of the submission process
class SubmissionCubit extends Cubit<SubmissionState> {

  final ApiService apiService;
  SubmissionCubit(this.apiService) : super(SubmissionInitial());
  

  Future<void> create(int collectionId) async {
    // emit means : we are changing the state of the cubit
    emit(SubmissionLoading());
    try {
      final submissionId = await apiService.createSubmission(collectionId);
      emit(SubmissionSuccess(submissionId));
    } catch (e) {
      emit(SubmissionFailure(e.toString()));
    }
  }

  
}
